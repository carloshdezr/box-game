local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Animations = require(ReplicatedStorage:WaitForChild("BoxerAnimations"))
local Theme = require(ReplicatedStorage.Config.Theme)
local Punch = ReplicatedStorage.Remotes.BoxerPunch
local controllers = {}

local function track(other)
	local function added(character)
		local function disableDefault(item)
			if item.Name == "Animate" and item:IsA("LocalScript") then item.Disabled = true end
		end
		for _, item in ipairs(character:GetChildren()) do disableDefault(item) end
		local addedConnection = character.ChildAdded:Connect(disableDefault)
		character.Destroying:Once(function() addedConnection:Disconnect() end)
		task.spawn(function()
			local humanoid = character:WaitForChild("Humanoid", 10)
			if not humanoid or not character.Parent or other.Character ~= character then return end
			-- Character parts can arrive after CharacterAdded on a remote client.
			for _, name in ipairs({ "LeftHand", "RightHand", "LeftFoot", "RightFoot", "Head" }) do
				if not character:WaitForChild(name, 10) then return end
			end
			local apply, destroy = Animations.Bind(character)
			if other.Character ~= character then destroy() return end
			controllers[other] = { character = character, humanoid = humanoid, apply = apply, destroy = destroy }
			if other == player then workspace.CurrentCamera.CameraSubject = humanoid end
		end)
	end
	other.CharacterAdded:Connect(added)
	other.CharacterRemoving:Connect(function()
		if controllers[other] then controllers[other].destroy() end
		controllers[other] = nil
	end)
	if other.Character then added(other.Character) end
end
Players.PlayerAdded:Connect(track)
Players.PlayerRemoving:Connect(function(other) controllers[other] = nil end)
for _, other in ipairs(Players:GetPlayers()) do track(other) end

RunService.PreSimulation:Connect(function(dt)
	local now = workspace:GetServerTimeNow()
	for _, controller in pairs(controllers) do
		local character, humanoid = controller.character, controller.humanoid
		if character.Parent and humanoid.Health > 0 then
			local root = character:FindFirstChild("HumanoidRootPart")
			local velocity = root and root.AssemblyLinearVelocity or Vector3.zero
			local moving = Vector3.new(velocity.X, 0, velocity.Z).Magnitude > 1
			local mode = character:GetAttribute("PoseDebug") or (moving and "Correr" or "Guardia")
			controller.apply(mode, now, character:GetAttribute("Golpe"), now-(character:GetAttribute("GolpeInicio") or 0), dt)
		end
	end
end)

local function request(action)
	if not player:GetAttribute("AparienciaElegida") then return end
	local training = player.PlayerGui:FindFirstChild("TrainingHUD")
	-- Existing minigames own their inputs until Phase 3.
	if training then
		local panel = training:FindFirstChild("Round")
		if panel and panel.Visible then return end
	end
	Punch:FireServer(action)
end
Input.InputBegan:Connect(function(input, processed)
	if processed or Input:GetFocusedTextBox() then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then request("Primary") end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then request("Uppercut") end
end)

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.Parent = "BoxerControls", false, player:WaitForChild("PlayerGui")
local hint = Instance.new("TextLabel")
hint.Size, hint.Position, hint.AnchorPoint = UDim2.fromOffset(360, 36), UDim2.new(0.5, 0, 1, -12), Vector2.new(0.5, 1)
hint.BackgroundColor3, hint.TextColor3, hint.Font, hint.TextSize = Theme.Background, Theme.Text, Theme.Font, Theme.TextSize
hint.Text, hint.Parent = "Clic: jab / gancho · Clic derecho: uppercut", gui
hint.Visible = not Input.TouchEnabled
for index, definition in ipairs({ { "Golpear", "Primary" }, { "Uppercut", "Uppercut" } }) do
	local button = Instance.new("TextButton")
	button.Name, button.Text = definition[1], definition[1]
	button.Size, button.Position = UDim2.fromOffset(110, Theme.ButtonHeight), UDim2.new(1, -125, 0.45, (index-1)*60)
	button.BackgroundColor3, button.TextColor3, button.Font, button.TextSize = Theme.Background, Theme.Text, Theme.Font, Theme.TextSize
	button.Visible, button.Parent = Input.TouchEnabled, gui
	button.Activated:Connect(function() request(definition[2]) end)
end
