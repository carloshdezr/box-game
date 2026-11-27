local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Config.Training)
local Stats = require(ReplicatedStorage.Config.Stats)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local State = Remotes:WaitForChild("TrainingState")
local Result = Remotes:WaitForChild("TrainingResult")
local Cancel = Remotes:WaitForChild("TrainingCancel")
local Training = {}
local active, cooldown, notices = {}, {}, {}
local stations, playerData

local function notify(player, message)
	if player.Parent == Players then State:FireClient(player, "Notice", message) end
end

local function near(player, station, distance)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	return root and humanoid and humanoid.Health > 0 and (root.Position - station.Host.Position).Magnitude <= distance
end

local function allCapped(data, definition)
	for stat in pairs(definition.Rewards) do
		if data[stat] < Stats.RankCaps[data.Rango] then return false end
	end
	return true
end

local function release(player, message)
	local round = active[player]
	if not round then return end
	active[player] = nil
	round.station.Owner = nil
	round.station.Model:SetAttribute("Occupied", false)
	round.station.Model:SetAttribute("OccupiedBy", nil)
	round.station.Prompt.Enabled = true
	round.station.Label.Text = round.station.Kind .. "\nLIBRE"
	player:SetAttribute("TrainingStation", nil)
	if player.Parent == Players then State:FireClient(player, "End", message) end
end

function Training.Begin(player, stationId)
	local station = stations[stationId]
	if not station or active[player] or station.Owner then return false end
	local now = workspace:GetServerTimeNow()
	if now < (cooldown[player] or 0) then
		if now >= (notices[player] or 0) then
			notices[player] = now + Config.NoticeSeconds
			notify(player, "Descansa antes de otra ronda")
		end
		return false
	end
	if not near(player, station, Config.PromptDistance) then return false end
	local data = playerData.GetSnapshot(player)
	if not data or player:GetAttribute("EstadoDatos") ~= "Listo" then
		notify(player, "Tu progreso no se está guardando")
		return false
	end
	local definition = Config.Stations[station.Kind]
	if allCapped(data, definition) then notify(player, Config.MaxMessage) return false end
	-- Reserve synchronously before sending anything; one round per player and station.
	local round = { station = station, started = now, ends = now + definition.Duration, definition = definition }
	active[player], station.Owner = round, player
	cooldown[player] = round.ends + Config.CooldownSeconds
	station.Model:SetAttribute("Occupied", true)
	station.Model:SetAttribute("OccupiedBy", player.UserId)
	station.Prompt.Enabled = false
	station.Label.Text = station.Kind .. "\nOCUPADA"
	player:SetAttribute("TrainingStation", stationId)
	State:FireClient(player, "Start", { Kind = station.Kind, Started = now, Ends = round.ends })
	return true
end

function Training.Complete(player, score)
	local round = active[player]
	if not round then return false end
	local now = workspace:GetServerTimeNow()
	-- The client supplies only a score. Never accept its times, stats or rewards.
	if type(score) ~= "number" or score ~= score or math.abs(score) == math.huge then return false end
	if now < round.ends then return false end
	if now > round.ends + Config.ResultGraceSeconds or not near(player, round.station, Config.MaxRoundDistance) then
		release(player, "Ronda cancelada")
		return false
	end
	local data = playerData.GetSnapshot(player)
	if not data or player:GetAttribute("EstadoDatos") ~= "Listo" then
		release(player, "Tu progreso no se está guardando")
		return false
	end
	local rewards, reachedCap = {}, false
	local adjusted = math.clamp(score, 0, 1)
	for stat, maximum in pairs(round.definition.Rewards) do
		local amount = math.floor(adjusted * maximum + 0.5)
		local target = math.min(data[stat] + amount, Stats.RankCaps[data.Rango])
		if not playerData.SetStat(player, stat, target) then
			release(player, "Tu progreso no se está guardando")
			return false
		end
		table.insert(rewards, stat .. " +" .. tostring(target - data[stat]))
		if target == Stats.RankCaps[data.Rango] then reachedCap = true end
	end
	release(player, table.concat(rewards, " · ") .. (reachedCap and ("\n" .. Config.MaxMessage) or ""))
	return true
end

function Training.Cancel(player)
	release(player, "Ronda cancelada")
end

function Training.Start(dataService, gymStations, spawnCFrame)
	playerData, stations = dataService, gymStations
	for id, station in pairs(stations) do
		station.Prompt.Triggered:Connect(function(player) Training.Begin(player, id) end)
	end
	Result.OnServerEvent:Connect(function(player, score) Training.Complete(player, score) end)
	Cancel.OnServerEvent:Connect(Training.Cancel)
	local function track(player)
		-- A new server also requires the configured rest before the first round;
		-- reconnecting cannot earn faster than Duration + CooldownSeconds.
		cooldown[player] = workspace:GetServerTimeNow() + Config.CooldownSeconds
		local function place(character)
			local root = character:WaitForChild("HumanoidRootPart", 10)
			if root and character.Parent then character:PivotTo(spawnCFrame) end
		end
		player.CharacterAdded:Connect(place)
		player.CharacterRemoving:Connect(function() release(player, "Ronda cancelada") end)
		if player.Character then task.spawn(place, player.Character) end
	end
	Players.PlayerAdded:Connect(track)
	for _, player in ipairs(Players:GetPlayers()) do track(player) end
	Players.PlayerRemoving:Connect(function(player)
		release(player)
		cooldown[player], notices[player] = nil, nil
	end)
	task.spawn(function()
		while true do
			task.wait(Config.CheckSeconds)
			local now = workspace:GetServerTimeNow()
			for player, round in pairs(active) do
				if now > round.ends + Config.ResultGraceSeconds or not near(player, round.station, Config.MaxRoundDistance)
					or player:GetAttribute("EstadoDatos") ~= "Listo" then
					release(player, "Ronda cancelada")
				end
			end
		end
	end)
end

return Training
