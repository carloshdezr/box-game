-- A repo-owned 15-part R15 rig: no avatar lookup, catalog assets or uploaded animations.
local Config = script.Parent.Config
local Appearance = require(Config.Appearance)
local Physique = require(Config.Physique)
local Theme = require(Config.Theme)
local Settings = require(Config.Boxer)
local Rig = {}

local function joint(model, name, parent, child, c0, c1)
	local motor = model[child]:FindFirstChild(name)
	if not motor then
		motor = Instance.new("Motor6D")
		motor.Name, motor.Part0, motor.Part1 = name, model[parent], model[child]
		motor.Parent = model[child]
	end
	motor.C0, motor.C1 = CFrame.new(c0), CFrame.new(c1)
end

function Rig.Scale(model, data)
	local level, strength = Physique.Resolve(data)
	local height, width, arms = level.Height, level.Torso + strength, level.Arms + strength
	local sizes = {
		HumanoidRootPart = Vector3.new(2, 2, 1), Head = Vector3.new(1.4, 1.2, 1.2),
		UpperTorso = Vector3.new(1.8 * width, 1.4 * height, 0.85 * level.Torso),
		LowerTorso = Vector3.new(1.25 * level.Torso, 0.65 * height, 0.75 * level.Torso),
	}
	for _, side in ipairs({ "Left", "Right" }) do
		sizes[side .. "UpperArm"] = Vector3.new(0.65 * arms, 0.95 * height, 0.7 * arms)
		sizes[side .. "LowerArm"] = Vector3.new(0.57 * arms, 0.85 * height, 0.6 * arms)
		sizes[side .. "Hand"] = Vector3.new(0.65 * arms, 0.5, 0.7 * arms)
		sizes[side .. "UpperLeg"] = Vector3.new(0.7 * level.Legs, height, 0.8 * level.Legs)
		sizes[side .. "LowerLeg"] = Vector3.new(0.6 * level.Legs, height, 0.65 * level.Legs)
		sizes[side .. "Foot"] = Vector3.new(0.75 * level.Legs, 0.45, 1.15 * level.Legs)
	end
	for name, size in pairs(sizes) do model[name].Size = size end
	local lower, upper = sizes.LowerTorso, sizes.UpperTorso
	joint(model, "Root", "HumanoidRootPart", "LowerTorso", Vector3.zero, Vector3.zero)
	joint(model, "Waist", "LowerTorso", "UpperTorso", Vector3.new(0, lower.Y/2, 0), Vector3.new(0, -upper.Y/2, 0))
	joint(model, "Neck", "UpperTorso", "Head", Vector3.new(0, upper.Y/2, 0), Vector3.new(0, -0.6, 0))
	for _, side in ipairs({ "Left", "Right" }) do
		local sign = side == "Left" and -1 or 1
		local arm, forearm = sizes[side .. "UpperArm"], sizes[side .. "LowerArm"]
		local leg, shin = sizes[side .. "UpperLeg"], sizes[side .. "LowerLeg"]
		joint(model, side .. "Shoulder", "UpperTorso", side .. "UpperArm", Vector3.new(sign*(upper.X+arm.X)/2, upper.Y*0.35, 0), Vector3.new(0, arm.Y/2, 0))
		joint(model, side .. "Elbow", side .. "UpperArm", side .. "LowerArm", Vector3.new(0, -arm.Y/2, 0), Vector3.new(0, forearm.Y/2, 0))
		joint(model, side .. "Wrist", side .. "LowerArm", side .. "Hand", Vector3.new(0, -forearm.Y/2, 0), Vector3.new(0, 0.25, 0))
		joint(model, side .. "Hip", "LowerTorso", side .. "UpperLeg", Vector3.new(sign*lower.X*0.28, -lower.Y/2, 0), Vector3.new(0, leg.Y/2, 0))
		joint(model, side .. "Knee", side .. "UpperLeg", side .. "LowerLeg", Vector3.new(0, -leg.Y/2, 0), Vector3.new(0, shin.Y/2, 0))
		joint(model, side .. "Ankle", side .. "LowerLeg", side .. "Foot", Vector3.new(0, -shin.Y/2, 0), Vector3.new(0, 0.225, 0.15))
	end
	model.Humanoid.HipHeight = lower.Y/2 + 2*height + 0.45 - sizes.HumanoidRootPart.Y/2
	model:SetAttribute("Fisico", level.Name)
end

local function ornament(model, name, size, offset, color)
	local part = Instance.new("Part")
	part.Name, part.Size, part.Color = name, size, color
	part.CanCollide, part.CanTouch, part.CanQuery, part.Massless = false, false, false, true
	part.Material = Enum.Material.SmoothPlastic
	local weld = Instance.new("Weld")
	weld.Part0, weld.Part1, weld.C0 = model.Head, part, CFrame.new(offset)
	weld.Parent, part.Parent = part, model.Cosmetics
	return part
end

function Rig.Dress(model, choice)
	local skin = Color3.fromRGB(table.unpack(Appearance.Piel[choice.Piel].Color))
	local shorts = Color3.fromRGB(table.unpack(Appearance.Shorts[choice.Shorts].Color))
	for _, part in ipairs(model:GetChildren()) do
		if part:IsA("BasePart") then
			part.Color = skin
			if part.Name == "LowerTorso" or part.Name:find("UpperLeg") then part.Color = shorts end
			if part.Name:find("Hand") then part.Color = Theme.Boxer.Wraps end
			if part.Name:find("Foot") then part.Color = Theme.Boxer.Shoes end
		end
	end
	local old = model:FindFirstChild("Cosmetics")
	if old then old:Destroy() end
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "Cosmetics", model
	if choice.Cabello == 2 then
		ornament(model, "Cabello", Vector3.new(1.45, 0.3, 1.22), Vector3.new(0, 0.58, 0), Theme.Boxer.Hair)
	elseif choice.Cabello == 3 then
		ornament(model, "Cresta", Vector3.new(0.38, 0.55, 1.15), Vector3.new(0, 0.7, 0), Theme.Boxer.Hair)
	end
	for _, sign in ipairs({ -1, 1 }) do
		ornament(model, "Ojo", Vector3.new(0.13, 0.17, 0.06), Vector3.new(sign*0.3, 0.1, -0.62), Theme.Boxer.Ink)
		local brow = ornament(model, "Ceja", Vector3.new(0.27, 0.06, 0.06), Vector3.new(sign*0.3, 0.3, -0.62), Theme.Boxer.Hair)
		brow.Weld.C0 = brow.Weld.C0 * CFrame.Angles(0, 0, choice.Cara == 3 and sign*0.25 or 0)
	end
	ornament(model, "Boca", Vector3.new(0.42, choice.Cara == 1 and 0.15 or 0.05, 0.06), Vector3.new(0, -0.28, -0.62), choice.Cara == 1 and Theme.Boxer.Wraps or Theme.Boxer.Ink)
end

function Rig.Create(data)
	local model = Instance.new("Model")
	model.Name = "Boxeador"
	local names = { "HumanoidRootPart", "LowerTorso", "UpperTorso", "Head" }
	for _, side in ipairs({ "Left", "Right" }) do
		for _, limb in ipairs({ "UpperArm", "LowerArm", "Hand", "UpperLeg", "LowerLeg", "Foot" }) do
			table.insert(names, side .. limb)
		end
	end
	for _, name in ipairs(names) do
		local part = Instance.new("Part")
		part.Name, part.Material = name, Enum.Material.SmoothPlastic
		part.TopSurface, part.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
		part.CanCollide = name == "UpperTorso" or name == "LowerTorso"
		part.Massless = name ~= "HumanoidRootPart"
		part.Parent = model
	end
	model.HumanoidRootPart.Transparency, model.HumanoidRootPart.RootPriority = 1, 127
	local humanoid = Instance.new("Humanoid")
	humanoid.RigType, humanoid.AutomaticScalingEnabled = Enum.HumanoidRigType.R15, false
	humanoid.WalkSpeed, humanoid.Parent = Settings.WalkSpeed, model
	model.PrimaryPart = model.HumanoidRootPart
	Rig.Scale(model, data)
	Rig.Dress(model, data.Appearance or Appearance.Default)
	-- Assemble the rest pose before exposing the character to physics.
	for _, name in ipairs(names) do
		for _, motor in ipairs(model[name]:GetChildren()) do
			if motor:IsA("Motor6D") then motor.Part1.CFrame = motor.Part0.CFrame * motor.C0 * motor.C1:Inverse() end
		end
	end
	model:SetAttribute("Boxeador", true)
	return model
end

return Rig
