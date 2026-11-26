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
    local storage = { records = {}, writes = 0, fail = false }
    function storage:UpdateAsync(key, callback)
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
        ReplicatedStorage = { Config = {Stats = "Stats", Persistence = "Persistence"} },
        DataStoreService = {GetDataStore = function() return storage end},
        HttpService = {GenerateGUID = function() guid = guid + 1 return tostring(guid) end},
    }
    game = {GetService = function(_, name) return services[name] end,
        BindToClose = function(self, fn) self.close = fn end}
    script = {Parent = {PlayerDataSchema = "Schema"}}
    local modules = {Stats = assert(load(statsSource))(), Persistence = assert(load(configSource))()}
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
assert(p:GetAttribute("EstadoDatos") == "Error" and db.writes == 0)
leave(p)
print("PASS: failed load, invalid schema, foreign lock never overwritten")

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
assert(db.records.Player_6.Session == nil, "load/leave/close overlap must release")
print("PASS: load/leave/shutdown overlap; all game scripts parse")
