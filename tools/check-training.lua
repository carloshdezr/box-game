-- Real TrainingService with fake services and clock: no Roblox data is touched.
do
    local now, queue = 0, {}
    local function signal() return {Connect=function(self,fn) self.fn=fn end} end
    task = {}
    function task.wait(seconds) return coroutine.yield(seconds) end
    function task.spawn(fn,...)
        local co=coroutine.create(fn)
        local ok,delay=coroutine.resume(co,...); assert(ok,delay)
        if coroutine.status(co)~="dead" then table.insert(queue,{co,now+delay}) end
    end
    local function advance(seconds)
        local target=now+seconds
        while true do
            local index,earliest
            for i,item in ipairs(queue) do
                if item[2]<=target and (not earliest or item[2]<earliest) then index,earliest=i,item[2] end
            end
            if not index then now=target return end
            now=earliest
            local item=table.remove(queue,index)
            local ok,delay=coroutine.resume(item[1]); assert(ok,delay)
            if coroutine.status(item[1])~="dead" then table.insert(queue,{item[1],now+delay}) end
        end
    end
    local players={PlayerAdded=signal(),PlayerRemoving=signal(),GetPlayers=function() return {} end}
    local states={}
    local remotes={}
    for _,name in ipairs({"TrainingState","TrainingResult","TrainingCancel"}) do
        remotes[name]={OnServerEvent=signal(),FireClient=function(_,p,kind,value) states[p]={kind,value} end}
    end
    function remotes:WaitForChild(name) return self[name] end
    local rep={Config={Training="Training",Stats="Stats"},WaitForChild=function(_,name) assert(name=="Remotes") return remotes end}
    game={GetService=function(_,name) return ({Players=players,ReplicatedStorage=rep})[name] end}
    workspace={GetServerTimeNow=function() return now end}
    local config=assert(load(trainingConfigSource))()
    local stats=assert(load(statsSource))()
    require=function(name) return ({Training=config,Stats=stats})[name] end
    local service=assert(load(trainingSource))()
    local function attrs(o)
        o.attributes={}
        function o:SetAttribute(k,v) self.attributes[k]=v end
        function o:GetAttribute(k) return self.attributes[k] end
        return o
    end
    local function character()
        local humanoid={Health=100}
        local pos=setmetatable({distance=0},{__sub=function(a) return {Magnitude=a.distance} end})
        return {FindFirstChild=function() return {Position=pos} end,
            FindFirstChildOfClass=function() return humanoid end},pos,humanoid
    end
    local a=attrs({Parent=players,UserId=1})
    local b=attrs({Parent=players,UserId=2})
    local apos,health
    a.Character,apos,health=character()
    b.Character=character()
    a:SetAttribute("EstadoDatos","Listo"); b:SetAttribute("EstadoDatos","Listo")
    local data={}
    for _,p in ipairs({a,b}) do data[p]={Fuerza=1,Velocidad=1,Stamina=1,Defensa=1,Rango="Novato"} end
    data[a].Fuerza=99
    local pd={GetSnapshot=function(p) return table.clone(data[p]) end,
        SetStat=function(p,name,value) if p:GetAttribute("EstadoDatos")~="Listo" then return false end data[p][name]=math.min(value,100) return true end}
    local stations={}
    for _,kind in ipairs(config.StationOrder) do
        stations[kind]={Kind=kind,Model=attrs({}),Host={Position=0},Prompt={Enabled=true,Triggered=signal()},Label={}}
    end
    service.Start(pd,stations,{})
    a.CharacterAdded, a.CharacterRemoving = signal(), signal()
    local savedCharacter=a.Character
    a.Character=nil
    players.PlayerAdded.fn(a)
    a.Character=savedCharacter
    assert(not service.Begin(a,"Saco"), "new session must honor initial rest")
    advance(5)
    assert(service.Begin(a,"Saco"))
    assert(stations.Saco.Model:GetAttribute("Occupied") and not stations.Saco.Prompt.Enabled)
    assert(not service.Begin(b,"Saco") and not service.Begin(a,"Pesas"))
    assert(not service.Complete(a,1) and not service.Complete(a,0/0) and not service.Complete(a,math.huge))
    assert(not service.Complete(a,"1"))
    advance(20)
    assert(service.Complete(a,999))
    assert(data[a].Fuerza==100 and data[a].Velocidad==5, "reward clamp and rank cap")
    assert(states[a][2]:find(config.MaxMessage,1,true))
    assert(not service.Complete(a,1) and not service.Begin(a,"Pesas"))
    assert(not stations.Saco.Model:GetAttribute("Occupied") and stations.Saco.Prompt.Enabled)
    advance(5)
    assert(service.Begin(a,"Pesas")); service.Cancel(a)
    assert(not service.Begin(a,"Caminadora"), "cancel cannot bypass rate limit")
    advance(25)
    assert(service.Begin(a,"Caminadora"))
    apos.distance=100; advance(0.5)
    assert(not stations.Caminadora.Model:GetAttribute("Occupied"))
    assert(data[a].Stamina==1 and not service.Complete(a,1))
    apos.distance=0; advance(24.5)
    a:SetAttribute("EstadoDatos","Error")
    assert(not service.Begin(a,"Pera"))
    a:SetAttribute("EstadoDatos","Listo")
    assert(service.Begin(a,"Pera")); advance(20)
    assert(service.Complete(a,-10) and data[a].Defensa==1)
    advance(5)
    data[a].Velocidad=100; data[a].Defensa=100
    assert(not service.Begin(a,"Pera") and states[a][2]==config.MaxMessage)
    assert(service.Begin(b,"Pera")); advance(26)
    assert(not service.Complete(b,1) and not stations.Pera.Model:GetAttribute("Occupied"))
    assert(service.Begin(b,"Saco"))
    players.PlayerRemoving.fn(b)
    assert(not stations.Saco.Model:GetAttribute("Occupied"))
    print("PASS: training occupancy, duration, finite score, reward/rank caps, replay, join rest, cooldown, cancel, distance, data failure, timeout, departure")
end
