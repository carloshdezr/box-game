-- Solo en Studio: deja que las pruebas (MCP o barra de comandos) usen los servicios
-- que ya arrancó Main. Un require desde la barra de comandos o el MCP carga una copia
-- nueva del módulo, sin las sesiones de los jugadores, y por eso SetStat devolvía false.
-- Fuera de Studio no se crea nada.
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local StudioDebug = {}

function StudioDebug.Start(playerData, training, boxer)
	if not RunService:IsStudio() then
		return
	end
	local bridge = Instance.new("BindableFunction")
	bridge.Name = "StudioDebug"
	bridge.OnInvoke = function(action, userId, name, value)
		local player = Players:GetPlayerByUserId(userId or 0) or Players:GetPlayers()[1]
		if not player then
			return false, "SinJugador"
		end
		if action == "SetStat" then
			return playerData.SetStat(player, name, value)
		elseif action == "Snapshot" then
			return playerData.GetSnapshot(player)
		elseif action == "ChooseAppearance" then
			return playerData.SetAppearance(player, value)
		elseif action == "Punch" and boxer then
			return boxer.Punch(player, name)
		elseif action == "Pose" and player.Character then
			if name ~= nil and name ~= "Cansado" and name ~= "Correr" then return false end
			player.Character:SetAttribute("PoseDebug", name)
			return true
		elseif action == "TrainingStart" and training then
			return training.Begin(player, name)
		elseif action == "TrainingFinish" and training then
			return training.Complete(player, value)
		elseif action == "TrainingCancel" and training then
			training.Cancel(player)
			return true
		end
		return false, "AccionDesconocida"
	end
	bridge.Parent = game:GetService("ServerScriptService")
end

return StudioDebug
