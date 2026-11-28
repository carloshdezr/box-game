local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rig = require(ReplicatedStorage.BoxerRig)
local Config = require(ReplicatedStorage.Config.Boxer)
local Stats = require(ReplicatedStorage.Config.Stats)
local Punch = ReplicatedStorage.Remotes.BoxerPunch
local Choose = ReplicatedStorage.Remotes.ChooseAppearance
local Boxer = {}
local dataService
local sessions = {}

function Boxer.Punch(player, request)
	local state, character = sessions[player], player.Character
	if not state or not character or not character:GetAttribute("Boxeador")
		or player:GetAttribute("EstadoDatos") ~= "Listo" or not player:GetAttribute("AparienciaElegida")
		or character.Humanoid.Health <= 0 or (request ~= "Primary" and request ~= "Uppercut") then return false end
	local now = workspace:GetServerTimeNow()
	if now < state.nextPunch then return false end
	local name = request == "Uppercut" and "Uppercut" or (state.hook and "Gancho" or "Jab")
	if request == "Primary" then state.hook = not state.hook end
	state.nextPunch = now + Config.PunchSeconds[name]
	character:SetAttribute("Golpe", name)
	character:SetAttribute("GolpeInicio", now)
	return true
end

function Boxer.Start(service, spawnCFrame)
	dataService = service
	Players.CharacterAutoLoads = false
	local function track(player)
		if sessions[player] then return end
		local state = { nextPunch = 0, connections = {} }
		sessions[player] = state
		local function spawn()
			if player.Parent ~= Players then return end
			local old = player.Character
			local character = Rig.Create(dataService.GetSnapshot(player) or {})
			character.Name = player.Name
			character:PivotTo(spawnCFrame)
			character.Parent = workspace
			player.Character = character
			if old then old:Destroy() end
			character.Humanoid.Died:Once(function() task.delay(Config.RespawnSeconds, spawn) end)
		end
		local function refresh()
			local character, snapshot = player.Character, dataService.GetSnapshot(player)
			if character and character:GetAttribute("Boxeador") and snapshot then
				Rig.Scale(character, snapshot)
				Rig.Dress(character, snapshot.Appearance or require(ReplicatedStorage.Config.Appearance).Default)
			end
		end
		for _, name in ipairs(Stats.Names) do
			table.insert(state.connections, player:GetAttributeChangedSignal(name):Connect(refresh))
		end
		for _, name in ipairs({ "EstadoDatos", "AparienciaElegida" }) do
			table.insert(state.connections, player:GetAttributeChangedSignal(name):Connect(refresh))
		end
		spawn()
	end
	Players.PlayerAdded:Connect(track)
	Players.PlayerRemoving:Connect(function(player)
		local state = sessions[player]
		if state then for _, connection in ipairs(state.connections) do connection:Disconnect() end end
		sessions[player] = nil
	end)
	for _, player in ipairs(Players:GetPlayers()) do track(player) end
	Choose.OnServerEvent:Connect(function(player, choice)
		if dataService.SetAppearance(player, choice) then
			Choose:FireClient(player, true)
		else
			Choose:FireClient(player, false)
		end
	end)
	Punch.OnServerEvent:Connect(Boxer.Punch)
end

return Boxer
