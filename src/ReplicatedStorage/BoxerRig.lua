local Players=game:GetService("Players")
local Config=script.Parent.Config
local Appearance=require(Config.Appearance)
local Physique=require(Config.Physique)
local Catalog=require(Config.BoxerCatalog)
local Settings=require(Config.Boxer)
local Rig={}
local function key(c) return table.concat({c.Piel,c.Cabello,c.Cara,c.Shorts},":") end

function Rig.Description(data,fallback)
 local c=data.Appearance or Appearance.Default
 local level,strength=Physique.Resolve(data)
 local d=Instance.new("HumanoidDescription")
 if not fallback then for part,id in pairs(Catalog.Body) do d[part]=id end end
 d.Head=Catalog.Head
 d.Face=fallback and Catalog.FallbackFace or Appearance.Cara[c.Cara].Asset
 d.WidthScale,d.DepthScale,d.HeightScale=level.Width+strength,level.Depth,level.Height
 d.HeadScale,d.BodyTypeScale,d.ProportionScale=1,0,0
 local skin=Color3.fromRGB(table.unpack(Appearance.Piel[c.Piel].Color))
 for _,name in ipairs({"HeadColor","TorsoColor","LeftArmColor","RightArmColor","LeftLegColor","RightLegColor"}) do d[name]=skin end
 d:SetAccessories({
  {AssetId=fallback and Catalog.FallbackHair or Appearance.Cabello[c.Cabello].Asset,AccessoryType=Enum.AccessoryType.Hair},
  {AssetId=Catalog.Tank,AccessoryType=Enum.AccessoryType.TShirt,Order=1,IsLayered=true},
  {AssetId=fallback and Catalog.FallbackShorts or Appearance.Shorts[c.Shorts].Asset,AccessoryType=Enum.AccessoryType.Shorts,Order=2,IsLayered=true},
 },true)
 return d
end

function Rig.Gloves(model)
 local old=model:FindFirstChild("BoxingGloves")
 if old then old:Destroy() end
 local folder=Instance.new("Folder")
 folder.Name,folder.Parent="BoxingGloves",model
 for _,side in ipairs({"Left","Right"}) do
  local hand=model:FindFirstChild(side.."Hand")
  if hand then
   local grip=hand:FindFirstChild(side.."GripAttachment")
   if not grip then
    grip=Instance.new("Attachment")
    grip.Name,grip.Parent=side.."GripAttachment",hand
   end
   local scale=math.clamp(hand.Size.X/0.6,0.85,Catalog.GloveMaximumScale)
   local glove=Instance.new("Part")
   glove.Name,glove.Shape=side.."Glove",Enum.PartType.Ball
   glove.Size=Vector3.new(table.unpack(Catalog.GloveSize))*scale
   glove.Color,glove.Material=Color3.fromRGB(table.unpack(Catalog.GloveColor)),Enum.Material.SmoothPlastic
   glove.CanCollide,glove.CanTouch,glove.CanQuery,glove.Massless=false,false,false,true
   local weld=Instance.new("Weld")
   weld.Name,weld.Part0,weld.Part1="HandAttachment",hand,glove
   weld.C0=grip.CFrame*CFrame.new(table.unpack(Catalog.GloveOffset))
   glove.CFrame=hand.CFrame*weld.C0
   weld.Parent,glove.Parent=glove,folder
  end
 end
end

function Rig.Scale(model,data)
 local level,strength=Physique.Resolve(data)
 local hum=model:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 for name,value in pairs({BodyWidthScale=level.Width+strength,BodyDepthScale=level.Depth,BodyHeightScale=level.Height,HeadScale=1}) do
  local number=hum:FindFirstChild(name)
  if number then number.Value=value end
 end
 model:SetAttribute("Fisico",level.Name)
 Rig.Gloves(model)
end

function Rig.Dress(model,choice,data)
 if model:GetAttribute("AppearanceKey")==key(choice) then return end
 local snapshot=table.clone(data or {})
 snapshot.Appearance=choice
 local description=Rig.Description(snapshot)
 local ok,err=pcall(function() model.Humanoid:ApplyDescriptionResetAsync(description) end)
 description:Destroy()
 if not ok then warn("BoxerRig: apariencia no aplicada",err) return end
 model:SetAttribute("AppearanceKey",key(choice))
 Rig.Scale(model,snapshot)
end

function Rig.Create(data)
 local description=Rig.Description(data)
 local ok,model=pcall(function() return Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15) end)
 description:Destroy()
 if not ok then
  warn("BoxerRig: catálogo no disponible; usando respaldo",model)
  description=Rig.Description(data,true)
  ok,model=pcall(function() return Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15) end)
  description:Destroy()
 end
 if not ok then error("No se pudo crear el boxeador: "..tostring(model)) end
 model.Name,model.PrimaryPart="Boxeador",model.HumanoidRootPart
 model.Humanoid.WalkSpeed=Settings.WalkSpeed
 model.Humanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
 -- Suppress Roblox's default idle/run controller: it would blend over boxing.
 local animate=Instance.new("LocalScript")
 animate.Name,animate.Disabled,animate.Parent="Animate",true,model
 -- Local Animators avoid double playback/replication; all clients read server-approved states.
 local animator=model.Humanoid:FindFirstChildOfClass("Animator")
 if animator then animator:Destroy() end
 model:SetAttribute("AppearanceKey",key(data.Appearance or Appearance.Default))
 model:SetAttribute("Boxeador",true)
 Rig.Scale(model,data)
 return model
end
function Rig.AssemblePreview(model)
 local placed={[model.HumanoidRootPart]=true}
 model.HumanoidRootPart.CFrame=CFrame.identity
 for _=1,18 do
  for _,j in ipairs(model:GetDescendants()) do
   if j:IsA("JointInstance") or j:IsA("AnimationConstraint") then
    local a,b=j.Part0,j.Part1
    if a and b then
     if placed[a] and not placed[b] then b.CFrame=a.CFrame*j.C0*j.C1:Inverse() placed[b]=true
     elseif placed[b] and not placed[a] then a.CFrame=b.CFrame*j.C1*j.C0:Inverse() placed[a]=true end
    end
   end
  end
 end
end
return Rig
