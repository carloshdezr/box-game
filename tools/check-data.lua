-- Scheduler and services are fakes; this does not replace the owner's Studio test.
table.clone = function(t) local c = {} for k, v in pairs(t) do c[k] = v end return c end
table.find = function(t, v) for i, x in ipairs(t) do if x == v then return i end end end
math.clamp = function(v, lo, hi) return math.max(lo, math.min(v, hi)) end
warn = function() end
local function copy(t)
    if type(t) ~= "table" then return t end
    local c = {} for k,v in pairs(t) do c[k] = copy(v) end return c
end
local function signal()
    return { Connect = function(self, fn) self.fn = fn end }
end
local function setup()
    local now, queue, guid = 0, {}, 0
    local storage = { records = {}, writes = 0, fail = false, calls = {} }
    function storage:UpdateAsync(key, callback)
        table.insert(self.calls, now)
        if self.fail then error("simulated outage") end
        if self.delay then task.wait(self.delay) end
        callback(copy(self.records[key])) -- callbacks can run repeatedly
        local value = callback(copy(self.records[key]))
        if value then self.records[key] = copy(value) self.writes = self.writes + 1 end
        return copy(value)
    end
    task = {}
    function task.wait(seconds) return coroutine.yield(seconds) end
    function task.spawn(fn, ...)
        local co = coroutine.create(fn)
        local ok, delay = coroutine.resume(co, ...)
        assert(ok, delay)
        if coroutine.status(co) ~= "dead" then table.insert(queue, {co, now + delay}) end
    end
    local function advance(seconds)
        local target = now + seconds
        for _ = 1, 10000 do
            local index, earliest
            for i, item in ipairs(queue) do
                if item[2] <= target and (not earliest or item[2] < earliest) then
                    index, earliest = i, item[2]
                end
            end
            if not index then now = target return end
            now = earliest
            local item = table.remove(queue, index)
            local ok, delay = coroutine.resume(item[1])
            assert(ok, delay)
            if coroutine.status(item[1]) ~= "dead" then table.insert(queue, {item[1], now + delay}) end
        end
        error("scheduler exceeded limit")
    end
    os.time = function() return math.floor(now) end
    os.clock = function() return now end
    local players = { PlayerAdded = signal(), PlayerRemoving = signal() }
    function players:GetPlayers() return {} end
    local services = {
        Players = players,
        ReplicatedStorage = { Config = {Stats = "Stats", Persistence = "Persistence", Appearance = "Appearance"} },
        DataStoreService = {GetDataStore = function() return storage end},
        HttpService = {GenerateGUID = function() guid = guid + 1 return tostring(guid) end},
    }
    game = {GetService = function(_, name) return services[name] end,
        BindToClose = function(self, fn) self.close = fn end}
    script = {Parent = {PlayerDataSchema = "Schema"}}
    local modules = {Stats = assert(load(statsSource))(), Persistence = assert(load(configSource))()}
    modules.Appearance = assert(load(appearanceSource))()
    require = function(name) return assert(modules[name], name) end
    modules.Schema = assert(load(schemaSource))()
    local service = assert(load(serviceSource))()
    service.Start()
    local function join(id)
        local p = {UserId = id, Parent = players, attributes = {}}
        function p:SetAttribute(k,v) self.attributes[k] = v end
        function p:GetAttribute(k) return self.attributes[k] end
        task.spawn(players.PlayerAdded.fn, p)
        return p
    end
    local function leave(p) p.Parent = nil task.spawn(players.PlayerRemoving.fn, p) end
    return storage, service, join, leave, advance, modules
end

local db, service, join, leave, advance, modules = setup()
local p = join(1)
assert(p:GetAttribute("Fuerza") == 1 and p:GetAttribute("Rango") == "Novato")
assert(db.records.Player_1.PuntosRango == 0)
assert(service.SetStat(p, "Fuerza", 900) and p:GetAttribute("Fuerza") == 100)
assert(not service.SetStat(p, "Fuerza", 0/0))
assert(not service.SetStat(p, "Rango", 2))
p:SetAttribute("Fuerza", 99999)
advance(60)
assert(db.records.Player_1.Fuerza == 100, "attributes must not be authoritative")
db.fail = true
advance(64)
assert(p:GetAttribute("EstadoDatos") == "Error")
assert(not service.SetStat(p, "Defensa", 10))
db.fail = false
advance(56)
assert(p:GetAttribute("EstadoDatos") == "Listo")
leave(p)
assert(db.records.Player_1.Session == nil, "leave must release lock")
p = join(1)
assert(p:GetAttribute("Fuerza") == 100, "rejoin must load saved stats")
service.SetStat(p, "Defensa", 20)
task.spawn(game.close)
advance(1)
assert(db.records.Player_1.Defensa == 20 and db.records.Player_1.Session == nil)
print("PASS: defaults, caps, authority, autosave failure/recovery, rejoin, shutdown")

db, service, join, leave, advance, modules = setup()
db.fail = true
p = join(2)
advance(5)
assert(p:GetAttribute("EstadoDatos") == "Error" and service.GetSnapshot(p) == nil)
db.fail = false
advance(60)
leave(p)
assert(db.writes == 0, "failed load must never save defaults")
db.records.Player_3 = {Version = 999, Fuerza = 42}
p = join(3)
leave(p)
assert(db.writes == 0 and db.records.Player_3.Fuerza == 42)
local record = modules.Schema.New()
record.Session = {Id = "other", Expires = 9999}
db.records.Player_4 = record
p = join(4)
assert(p:GetAttribute("EstadoDatos") == "Cargando" and db.writes == 0)
advance(29)
assert(p:GetAttribute("EstadoDatos") == "Cargando" and db.writes == 0)
advance(1)
assert(p:GetAttribute("EstadoDatos") == "Error" and db.writes == 0)
leave(p)
print("PASS: failed load, invalid schema, foreign lock never overwritten")

db, service, join, leave, advance, modules = setup()
local locked = modules.Schema.New()
locked.Fuerza = 37
locked.Session = {Id = "previous", Expires = 9999}
db.records.Player_7 = locked
p = join(7)
advance(5)
assert(p:GetAttribute("EstadoDatos") == "Cargando" and #db.calls == 3)
assert(db.calls[1] == 0 and db.calls[2] == 2 and db.calls[3] == 4)
db.records.Player_7.Session = nil
advance(1)
assert(p:GetAttribute("EstadoDatos") == "Listo" and p:GetAttribute("Fuerza") == 37)
assert(#db.calls == 4 and db.calls[4] == 6)
leave(p)
print("PASS: lock release loads original data on the next 2-second retry")

db, service, join, leave, advance, modules = setup()
locked = modules.Schema.New()
locked.Session = {Id = "previous", Expires = 9999}
db.records.Player_8 = locked
p = join(8)
advance(29)
assert(p:GetAttribute("EstadoDatos") == "Cargando" and #db.calls == 15)
advance(1)
assert(p:GetAttribute("EstadoDatos") == "Error" and #db.calls == 15 and db.writes == 0)
advance(60)
assert(#db.calls == 15 and db.records.Player_8.Session.Id == "previous")
print("PASS: lock timeout at 30 seconds without extra requests or writes")

db, service, join, leave, advance, modules = setup()
locked = modules.Schema.New()
locked.Session = {Id = "previous", Expires = 5}
db.records.Player_9 = locked
p = join(9)
advance(6)
assert(p:GetAttribute("EstadoDatos") == "Listo" and db.writes == 1)
print("PASS: lock expiring during wait is acquired")

db, service, join, leave, advance, modules = setup()
locked = modules.Schema.New()
locked.Session = {Id = "previous", Expires = 9999}
db.records.Player_10 = locked
p = join(10)
leave(p)
task.spawn(game.close)
advance(3)
assert(#db.calls == 1 and db.writes == 0)
print("PASS: departure/shutdown cancels lock retries")

db, service, join, leave, advance, modules = setup()
local record2 = modules.Schema.New()
record2.Rango, record2.Fuerza = "Semi-pro", 500
record2.Session = {Id = "expired", Expires = -1}
db.records.Player_5 = record2
p = join(5)
assert(p:GetAttribute("Fuerza") == 500)
db.records.Player_5.Session.Id = "new-owner"
service.SetStat(p, "Defensa", 30)
advance(60)
assert(db.records.Player_5.Defensa == 1 and p:GetAttribute("EstadoDatos") == "Error")
leave(p)
assert(db.records.Player_5.Session.Id == "new-owner")
print("PASS: expired lease recovery, lost ownership blocks writes")

db, service, join, leave, advance = setup()
db.delay = 1
p = join(6)
leave(p)
task.spawn(game.close)
advance(4)
assert(db.records.Player_6 == nil or db.records.Player_6.Session == nil,
    "load/leave/close overlap must cancel acquisition or release")
print("PASS: load/leave/shutdown overlap; all game scripts parse")

db, service, join, leave, advance, modules = setup()
local legacy = modules.Schema.New()
legacy.Fuerza = 37
db.records.Player_7 = legacy
p = join(7)
assert(p:GetAttribute("Fuerza") == 37 and p:GetAttribute("AparienciaElegida") == false)
assert(not service.SetAppearance(p, { Piel = 99, Cabello = 1, Cara = 1, Shorts = 1 }))
assert(not service.SetAppearance(p, { Piel = 1, Cabello = 1, Cara = 1, Shorts = 1, Extra = 1 }))
local choice = { Piel = 3, Cabello = 2, Cara = 3, Shorts = 2 }
assert(service.SetAppearance(p, choice))
choice.Piel = 1
assert(db.records.Player_7.Appearance.Piel == 3 and db.records.Player_7.Fuerza == 37)
local snapshot = service.GetSnapshot(p)
snapshot.Appearance.Piel = 1
assert(service.GetSnapshot(p).Appearance.Piel == 3, "snapshot must not expose nested data")
assert(not service.SetAppearance(p, choice), "cannot replace first selection")
leave(p)
p = join(7)
assert(p:GetAttribute("AparienciaElegida") and p:GetAttribute("AparienciaPiel") == 3)
assert(service.GetSnapshot(p).Appearance.Cara == 3)
local corrupt = modules.Schema.New()
corrupt.Appearance = { Piel = 0, Cabello = 1, Cara = 1, Shorts = 1 }
db.records.Player_8 = corrupt
local writes = db.writes
local bad = join(8)
assert(bad:GetAttribute("EstadoDatos") == "Error" and db.writes == writes)
assert(not service.SetAppearance(bad, choice))
print("PASS: legacy migration, appearance validation, immediate save, immutable selection, nested snapshot, reconnect, corrupt data protected")

local physique = assert(load(physiqueSource))()
for index, threshold in ipairs({ 1, 25, 75, 150, 300 }) do
    local level = physique.Resolve({ Fuerza=threshold, Velocidad=threshold, Stamina=threshold, Defensa=threshold })
    assert(level == physique.Levels[index])
    if index > 1 then
        local previous = physique.Resolve({ Fuerza=threshold-1, Velocidad=threshold-1, Stamina=threshold-1, Defensa=threshold-1 })
        assert(previous == physique.Levels[index-1])
    end
end
local _, low = physique.Resolve({ Fuerza = 1 })
local _, high = physique.Resolve({ Fuerza = 500 })
assert(low == 0 and high == physique.StrengthWidthBonus)
print("PASS: five physique thresholds and strength bonus")
