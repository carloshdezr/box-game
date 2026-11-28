-- Pure pose sampling, reusable by players, bags and NPC combat. No AnimationIds.
local Config = require(script.Parent.Config.Boxer)
local Animations = {}
local function angle(x, y, z)
	return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
end

function Animations.Sample(mode, time, punch, elapsed)
	local pose = {
		Waist = angle(-4, -10), Neck = angle(0, 10),
		LeftShoulder = angle(40, -10, -10), RightShoulder = angle(40, 10, 10),
		LeftElbow = angle(110), RightElbow = angle(110),
		LeftHip = angle(0, 0, -4), RightHip = angle(0, 0, 4),
	}
	if mode == "Cansado" then
		pose.Waist, pose.Neck = angle(-35), angle(20)
		pose.LeftShoulder, pose.RightShoulder = angle(20, 0, -8), angle(20, 0, 8)
		pose.LeftElbow, pose.RightElbow = angle(25), angle(25)
		pose.LeftHip, pose.RightHip = angle(18), angle(18)
		pose.LeftKnee, pose.RightKnee = angle(-25), angle(-25)
	elseif mode == "Correr" then
		local stride = math.sin(time * Config.RunCycleSpeed)
		pose.Waist, pose.Neck = angle(-8), angle(6)
		pose.LeftHip, pose.RightHip = angle(stride*38), angle(-stride*38)
		pose.LeftKnee, pose.RightKnee = angle(-math.max(0, -stride)*55), angle(-math.max(0, stride)*55)
		pose.LeftShoulder, pose.RightShoulder = angle(-stride*40), angle(stride*40)
		pose.LeftElbow, pose.RightElbow = angle(65), angle(65)
	end
	local duration = Config.PunchSeconds[punch]
	if duration and elapsed >= 0 and elapsed < duration then
		local phase = elapsed / duration
		local weight = phase < 0.35 and phase / 0.35 or (1-phase) / 0.65
		local target
		if punch == "Jab" then
			target = { LeftShoulder = angle(95, -5, -5), LeftElbow = angle(5), Waist = angle(-8, 15) }
		elseif punch == "Gancho" then
			target = { RightShoulder = angle(85, -65, 55), RightElbow = angle(90), Waist = angle(-5, -30) }
		else
			target = { RightShoulder = angle(125, 0, 12), RightElbow = angle(80), Waist = angle(8, -20) }
		end
		for name, cf in pairs(target) do pose[name] = (pose[name] or CFrame.identity):Lerp(cf, weight) end
	end
	return pose
end

function Animations.Bind(character)
	local joints = {}
	for _, item in ipairs(character:GetDescendants()) do
		if item:IsA("Motor6D") then joints[item.Name] = item end
	end
	return function(mode, time, punch, elapsed, dt)
		local pose = Animations.Sample(mode, time, punch, elapsed)
		for name, motor in pairs(joints) do
			motor.Transform = motor.Transform:Lerp(pose[name] or CFrame.identity,
				1 - math.exp(-Config.PoseBlendSpeed * dt))
		end
	end
end

return Animations
