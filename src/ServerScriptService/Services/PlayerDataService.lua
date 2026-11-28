local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Config = require(game:GetService("ReplicatedStorage").Config.Persistence)
local Stats = require(game:GetService("ReplicatedStorage").Config.Stats)
local Appearance = require(game:GetService("ReplicatedStorage").Config.Appearance)
local Schema = require(script.Parent.PlayerDataSchema)

local Service = {}
local sessions = {}
local closing = false
local started = false
local store

local function status(player, value)
	player:SetAttribute("EstadoDatos", value)
end

local function publish(player, data)
	for _, name in ipairs(Stats.Names) do
		player:SetAttribute(name, data[name])
	end
	player:SetAttribute("Rango", data.Rango)
	player:SetAttribute("PuntosRango", data.PuntosRango)
	for _, field in ipairs(Appearance.Fields) do
		player:SetAttribute("Apariencia" .. field, data.Appearance and data.Appearance[field])
	end
	player:SetAttribute("AparienciaElegida", data.Appearance ~= nil)
end

local function update(key, callback, deadline)
	for attempt = 1, Config.Attempts do
		if deadline and os.clock() >= deadline then
			return nil, false
		end
		local ok, result = pcall(function()
			return store:UpdateAsync(key, callback)
		end)
		if ok then
			return result, true
		end
		warn("[PlayerData] DataStore falló (intento " .. attempt .. "): " .. tostring(result))
		if attempt < Config.Attempts then
			local remaining = deadline and (deadline - os.clock()) or Config.RetrySeconds
			if remaining <= 0 then break end
			task.wait(math.min(Config.RetrySeconds, remaining))
		end
	end
	return nil, false
end

local function validLock(lock)
	return type(lock) == "table" and type(lock.Id) == "string"
		and type(lock.Expires) == "number" and lock.Expires == lock.Expires
		and math.abs(lock.Expires) < math.huge
end

local function save(player, session, release)
	while session.busy do
		task.wait(Config.PollSeconds)
	end
	if not session.loaded or session.released then
		return
	end
	session.busy = true
	local snapshot = table.clone(session.data)
	local result = update(session.key, function(old)
		if not Schema.Validate(old) or not validLock(old.Session)
			or old.Session.Id ~= session.id then
			return nil
		end
		local record = table.clone(snapshot)
		if not release then
			record.Session = { Id = session.id, Expires = os.time() + Config.SessionLeaseSeconds }
		end
		return record
	end)
	session.busy = false
	if result then
		session.released = release
		status(player, "Listo")
	else
		-- A failed save may be temporary. The next autosave still verifies ownership.
		status(player, "Error")
	end
end

local function finish(player, session)
	if session.finishing then
		return
	end
	session.finishing = true
	while session.loading do
		task.wait(Config.PollSeconds)
	end
	save(player, session, true)
	if sessions[player] == session then
		sessions[player] = nil
	end
end

local function load(player)
	if closing or sessions[player] then
		return
	end
	local session = { id = HttpService:GenerateGUID(false), key = "Player_" .. player.UserId,
		loading = true, loaded = false, data = Schema.New() }
	sessions[player] = session
	status(player, "Cargando")
	local deadline = os.clock() + Config.LockWaitSeconds
	local blockedBySession = false
	local function acquire(old)
		-- UpdateAsync may invoke the callback multiple times; only its last result counts.
		blockedBySession = false
		if closing or player.Parent ~= Players or os.clock() >= deadline then
			return nil
		end
		if old == nil then
			old = Schema.New()
		elseif not Schema.Validate(old) then
			return nil
		end
		if old.Session ~= nil then
			if not validLock(old.Session) then
				return nil
			end
			if old.Session.Id ~= session.id and old.Session.Expires > os.time() then
				blockedBySession = true
				return nil
			end
		end
		local nextRecord = table.clone(old)
		nextRecord.Session = { Id = session.id, Expires = os.time() + Config.SessionLeaseSeconds }
		return nextRecord
	end
	local record
	while not closing and player.Parent == Players and os.clock() < deadline do
		local requestOk
		record, requestOk = update(session.key, acquire, deadline)
		if record or not requestOk or not blockedBySession then break end
		local remaining = deadline - os.clock()
		if remaining <= 0 then break end
		task.wait(math.min(Config.LockRetrySeconds, remaining))
	end
	if record then
		session.data = table.clone(record)
		session.data.Session = nil
		session.loaded = true
	end
	session.loading = false
	publish(player, session.data)
	status(player, session.loaded and "Listo" or "Error")
	if closing or player.Parent ~= Players then
		finish(player, session)
	end
end

-- Server-only API. Attributes are a view, never the persistence source.
function Service.GetSnapshot(player)
	local session = sessions[player]
	if not session or not session.loaded or session.finishing then
		return nil
	end
	local snapshot = table.clone(session.data)
	if snapshot.Appearance then snapshot.Appearance = table.clone(snapshot.Appearance) end
	return snapshot
end

function Service.SetAppearance(player, choice)
	local session = sessions[player]
	if not session or not session.loaded or session.finishing or closing
		or player:GetAttribute("EstadoDatos") ~= "Listo" or session.data.Appearance
		or not Appearance.Validate(choice) then return false end
	-- Copy input before yielding; selection is immutable and cannot race a second request.
	session.data.Appearance = table.clone(choice)
	publish(player, session.data)
	save(player, session, false)
	return true
end

function Service.SetStat(player, name, value)
	local session = sessions[player]
	if not session or not session.loaded or session.finishing or closing
		or player:GetAttribute("EstadoDatos") ~= "Listo" then
		return false
	end
	if not table.find(Stats.Names, name) or type(value) ~= "number"
		or value ~= value or math.abs(value) == math.huge then
		return false
	end
	session.data[name] = math.clamp(value, Stats.InitialStat, Stats.RankCaps[session.data.Rango])
	publish(player, session.data)
	return true
end

function Service.Start()
	if started then return end
	started = true
	-- GetDataStore can fail in an unpublished place; load then fails safely too.
	local ok, result = pcall(function() return DataStoreService:GetDataStore(Config.StoreName) end)
	if ok then store = result else warn("[PlayerData] " .. tostring(result)) end
	Players.PlayerAdded:Connect(load)
	Players.PlayerRemoving:Connect(function(player)
		local session = sessions[player]
		if session then finish(player, session) end
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(load, player)
	end
	task.spawn(function()
		while not closing do
			task.wait(Config.AutosaveSeconds)
			if closing then break end
			for player, session in pairs(sessions) do
				if session.loaded and not session.finishing and not session.busy then
					task.spawn(save, player, session, false)
				end
			end
		end
	end)
	game:BindToClose(function()
		closing = true
		local deadline = os.clock() + Config.CloseWaitSeconds
		for player, session in pairs(sessions) do
			task.spawn(finish, player, session)
		end
		while next(sessions) and os.clock() < deadline do
			task.wait(Config.PollSeconds)
		end
		if next(sessions) then warn("[PlayerData] Cierre con guardados pendientes") end
	end)
end

return Service
