local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Config = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("Training"))
local Theme = require(ReplicatedStorage.Config:WaitForChild("Theme"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local State = Remotes:WaitForChild("TrainingState")
local Result = Remotes:WaitForChild("TrainingResult")
local Cancel = Remotes:WaitForChild("TrainingCancel")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "TrainingHUD", false, 10
gui.Parent = player:WaitForChild("PlayerGui")

local function rounded(object)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, Theme.CornerRadius)
	corner.Parent = object
end
local function text(parent, name, position, size, content, button)
	local item = Instance.new(button and "TextButton" or "TextLabel")
	item.Name, item.Position, item.Size, item.Text = name, position, size, content
	item.Font, item.TextSize, item.TextColor3 = Theme.Font, Theme.TextSize, Theme.Text
	item.BackgroundColor3 = Theme.Muted
	item.BackgroundTransparency = button and 0 or 1
	item.TextWrapped = true
	item.Parent = parent
	if button then rounded(item) end
	return item
end
local panel = Instance.new("Frame")
panel.Name = "Round"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(Theme.TrainingScale, 0, 0, Theme.TrainingHeight)
panel.BackgroundColor3, panel.BorderSizePixel = Theme.Background, 0
panel.Visible = false
panel.Parent = gui
rounded(panel)
local constraint = Instance.new("UISizeConstraint")
constraint.MaxSize = Vector2.new(Theme.TrainingWidth, Theme.TrainingHeight)
constraint.Parent = panel
local title = text(panel, "Title", UDim2.fromOffset(Theme.Padding, 8), UDim2.new(1, -100, 0, 32), "")
title.Font, title.TextSize, title.TextColor3 = Theme.TitleFont, Theme.TitleSize, Theme.Accent
local close = text(panel, "Cancel", UDim2.new(1, -80, 0, 8), UDim2.fromOffset(66, 32), "Salir", true)
local instruction = text(panel, "Instruction", UDim2.new(0, Theme.Padding, 0, 46), UDim2.new(1, -Theme.Padding * 2, 0, 44), "")
local meter = Instance.new("Frame")
meter.Name, meter.Position, meter.Size = "Meter", UDim2.new(0.08, 0, 0, 108), UDim2.new(0.84, 0, 0, 36)
meter.BackgroundColor3, meter.BorderSizePixel, meter.Parent = Theme.Muted, 0, panel
rounded(meter)
local target = Instance.new("Frame")
target.Name, target.Size = "Target", UDim2.fromScale(0.2, 1)
target.BorderSizePixel, target.BackgroundColor3, target.Parent = 0, Theme.Success, meter
local cursor = Instance.new("Frame")
cursor.Name, cursor.AnchorPoint, cursor.Size = "Cursor", Vector2.new(0.5, 0), UDim2.new(0, 6, 1, 8)
cursor.BackgroundColor3, cursor.BorderSizePixel, cursor.Parent = Theme.Accent, 0, meter
local feedback = text(panel, "Feedback", UDim2.new(0, Theme.Padding, 0, 154), UDim2.new(1, -Theme.Padding * 2, 0, 40), "")
local action = text(panel, "Action", UDim2.new(0.08, 0, 1, -Theme.ButtonHeight - Theme.Padding), UDim2.new(0.84, 0, 0, Theme.ButtonHeight), "", true)
action.BackgroundColor3, action.TextColor3 = Theme.Accent, Theme.Background
local notice = text(gui, "Notice", UDim2.fromScale(0.5, 0.82), UDim2.new(0.9, 0, 0, 70), "")
notice.AnchorPoint = Vector2.new(0.5, 0)
notice.BackgroundColor3, notice.BackgroundTransparency = Theme.Background, 0
notice.Visible = false
rounded(notice)
local current, keyboardHeld, touchHeld, noticeVersion = nil, false, false, 0

local function toast(message)
	noticeVersion = noticeVersion + 1
	local version = noticeVersion
	notice.Text, notice.Visible = message, true
	task.delay(Config.NoticeSeconds, function() if version == noticeVersion then notice.Visible = false end end)
end
local function hudVisible(visible)
	local hud = player.PlayerGui:FindFirstChild("StatsHUD")
	if hud then hud.Enabled = visible end
end
local function stop()
	current, keyboardHeld, touchHeld = nil, false, false
	panel.Visible = false
	ContextActionService:UnbindAction("TrainingInput")
	hudVisible(true)
end
local function press()
	local round = current
	if not round or round.sent then return end
	local elapsed = workspace:GetServerTimeNow() - round.Started
	local cfg = round.cfg
	if round.Kind == "Saco" or round.Kind == "Pera" then
		local beat = math.floor(elapsed / cfg.BeatSeconds + 0.5)
		round.attempts = round.attempts + 1
		local errorSeconds = math.abs(elapsed - beat * cfg.BeatSeconds)
		if beat >= 1 and beat <= math.floor(cfg.Duration / cfg.BeatSeconds) and not round.hits[beat] and errorSeconds <= cfg.HitWindow then
			round.hits[beat] = true
			local quality = 1 - errorSeconds / cfg.HitWindow
			round.points = round.points + quality
			round.combo = round.combo + 1
			feedback.Text = "¡A tiempo!  Racha " .. round.combo
		else
			round.combo = 0
			feedback.Text = "Fuera de tiempo: espera el centro"
		end
	elseif round.Kind == "Pesas" then
		round.holdStarted = workspace:GetServerTimeNow()
	end
end
local function release()
	local round = current
	if not round or round.sent or round.Kind ~= "Pesas" or not round.holdStarted then return end
	local phase = math.clamp((workspace:GetServerTimeNow() - round.holdStarted) / round.repSeconds, 0, 1)
	local quality = math.clamp(1 - math.abs(phase - round.cfg.Target) / round.cfg.Window, 0, 1)
	round.points = round.points + quality * round.repSeconds
	round.reps = round.reps + 1
	round.repSeconds = math.max(round.cfg.MinRepSeconds, round.cfg.FirstRepSeconds - round.reps * round.cfg.RepAcceleration)
	round.holdStarted = nil
	feedback.Text = quality > 0 and "¡Buena repetición! La siguiente es más rápida" or "Suelta cuando la barra esté en verde"
end
local function held(source, value)
	local before = keyboardHeld or touchHeld
	if source == "Keyboard" then keyboardHeld = value else touchHeld = value end
	local after = keyboardHeld or touchHeld
	if not before and after then press() elseif before and not after then release() end
end
action.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then held("Touch", true) end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then held("Touch", false) end
end)
UserInputService.WindowFocusReleased:Connect(function() held("Keyboard", false) held("Touch", false) end)
close.Activated:Connect(function() Cancel:FireServer() stop() end)

State.OnClientEvent:Connect(function(kind, payload)
	if kind == "Notice" then toast(payload) return end
	if kind == "End" then stop() toast(payload or "Ronda terminada") return end
	if kind ~= "Start" then return end
	stop()
	local cfg = Config.Stations[payload.Kind]
	if not cfg then return end
	current = { Kind = payload.Kind, Started = payload.Started, Ends = payload.Ends, cfg = cfg,
		points = 0, attempts = 0, combo = 0, hits = {}, reps = 0, repSeconds = cfg.FirstRepSeconds,
		level = cfg.InitialLevel, last = workspace:GetServerTimeNow() }
	panel.Visible, notice.Visible = true, false
	hudVisible(false)
	feedback.Text = "¡Prepárate!"
	if payload.Kind == "Caminadora" then
		instruction.Text = "Mantén ESPACIO o el botón para subir; suelta para bajar. Quédate en verde."
		action.Text = "MANTENER / SOLTAR"
		target.Position, target.Size = UDim2.fromScale(cfg.ZoneMin, 0), UDim2.fromScale(cfg.ZoneMax - cfg.ZoneMin, 1)
	elseif payload.Kind == "Pesas" then
		instruction.Text = "Mantén ESPACIO o el botón; SUELTA en la zona verde. Cada repetición acelera."
		action.Text = "MANTÉN Y SUELTA"
		target.Position, target.Size = UDim2.fromScale(cfg.Target - cfg.Window / 2, 0), UDim2.fromScale(cfg.Window, 1)
	else
		instruction.Text = "Pulsa ESPACIO o GOLPE cuando el marcador cruce el centro verde."
		action.Text = "GOLPE"
		target.Position, target.Size = UDim2.fromScale(0.5 - cfg.HitWindow / cfg.BeatSeconds / 2, 0), UDim2.fromScale(cfg.HitWindow / cfg.BeatSeconds, 1)
	end
	ContextActionService:BindActionAtPriority("TrainingInput", function(_, state)
		if state == Enum.UserInputState.Begin then held("Keyboard", true)
		elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then held("Keyboard", false) end
		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Space)
end)

RunService.RenderStepped:Connect(function()
	local round = current
	if not round or round.sent then return end
	local now, cfg = workspace:GetServerTimeNow(), round.cfg
	local dt = math.max(0, math.min(now, round.Ends) - round.last)
	round.last = now
	local elapsed = now - round.Started
	title.Text = round.Kind .. "  •  " .. math.max(0, math.ceil(round.Ends - now)) .. " s"
	local position = 0
	if round.Kind == "Caminadora" then
		round.level = math.clamp(round.level + dt * ((keyboardHeld or touchHeld) and cfg.RisePerSecond or -cfg.FallPerSecond), 0, 1)
		position = round.level
		if position >= cfg.ZoneMin and position <= cfg.ZoneMax then round.points = round.points + dt end
		feedback.Text = position >= cfg.ZoneMin and position <= cfg.ZoneMax and "¡Sigue en verde!" or "Ajusta el ritmo"
	elseif round.Kind == "Pesas" then
		position = round.holdStarted and math.clamp((now - round.holdStarted) / round.repSeconds, 0, 1) or 0
		if position >= 1 then release() end
	else
		position = ((elapsed / cfg.BeatSeconds + 0.5) % 1)
		local beat = math.floor(elapsed / cfg.BeatSeconds + 0.5)
		local inWindow = beat >= 1 and math.abs(elapsed - beat * cfg.BeatSeconds) <= cfg.HitWindow
		action.Text = inWindow and "¡GOLPE! · ESPACIO / TOCA" or "ESPERA EL RITMO"
	end
	cursor.Position = UDim2.new(position, 0, 0, -4)
	if now >= round.Ends then
		round.sent = true
		local divisor = cfg.Duration
		if round.Kind == "Saco" or round.Kind == "Pera" then divisor = math.max(math.floor(cfg.Duration / cfg.BeatSeconds), round.attempts) end
		Result:FireServer(math.clamp(round.points / divisor, 0, 1))
		feedback.Text = "Guardando resultado…"
	end
end)
