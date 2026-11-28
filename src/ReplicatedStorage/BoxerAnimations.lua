local RunService=game:GetService("RunService")
local Provider=game:GetService("KeyframeSequenceProvider")
local Config=require(script.Parent.Config.Boxer)
local Sequences=require(script.Parent.BoxerKeyframes)
local Animations={}
local assets={}
local warned=false
local function asset(name)
 if assets[name] then return assets[name] end
 local id=Config.AnimationIds[name]
 local animation=Instance.new("Animation")
 if id and id>0 then
  animation.AnimationId="rbxassetid://"..id
 elseif RunService:IsStudio() then
  local sequence=Sequences.Build(name)
  animation.AnimationId=Provider:RegisterKeyframeSequence(sequence)
  sequence:Destroy()
 else
  animation:Destroy()
  if not warned then warned=true warn("BoxerAnimations: faltan IDs publicados; ver docs/SUBIR_ANIMACIONES.md") end
  return nil
 end
 animation.Name=name
 assets[name]=animation
 return animation
end
function Animations.Bind(character)
 local humanoid=character:FindFirstChildOfClass("Humanoid")
 local animator=humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
 animator.Parent=humanoid
 for _,track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) end
 local tracks={}
 for _,name in ipairs(Sequences.Names) do
  local animation=asset(name)
  if animation then
   local ok,track=pcall(function() return animator:LoadAnimation(animation) end)
   if ok then
    track.Looped=not Config.PunchSeconds[name]
    track.Priority=Config.PunchSeconds[name] and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
    tracks[name]=track
   else warn("BoxerAnimations",name,track) end
  end
 end
 local mode,lastPunch,activePunch
 local function apply(nextMode,now,punch,elapsed)
  if nextMode~=mode then
   if tracks[mode] then tracks[mode]:Stop(Config.AnimationFadeSeconds) end
   mode=nextMode
   if tracks[mode] then tracks[mode]:Play(Config.AnimationFadeSeconds) end
  end
  local started=now-elapsed
  if Config.PunchSeconds[punch] and elapsed>=0 and elapsed<Config.PunchSeconds[punch]
   and (not lastPunch or math.abs(started-lastPunch)>0.0001) then
   lastPunch=started
   if activePunch then activePunch:Stop(Config.AnimationFadeSeconds) end
   activePunch=tracks[punch]
   if activePunch then
    activePunch:Play(Config.AnimationFadeSeconds)
    activePunch.TimePosition=elapsed
   end
  end
 end
 local function destroy()
  for _,track in pairs(tracks) do track:Stop(0) track:Destroy() end
  animator:Destroy()
 end
 return apply,destroy
end
return Animations
