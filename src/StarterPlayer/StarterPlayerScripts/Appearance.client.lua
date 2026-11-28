local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Config = require(ReplicatedStorage:WaitForChild("Config").Appearance)
local Theme = require(ReplicatedStorage.Config.Theme)
local Settings = require(ReplicatedStorage.Config.Boxer)
local Rig = require(ReplicatedStorage:WaitForChild("BoxerRig"))
local Choose = ReplicatedStorage.Remotes.ChooseAppearance
local choice = table.clone(Config.Default)
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "AppearanceCreator", false, 20
gui.Parent = player:WaitForChild("PlayerGui")
local panel = Instance.new("Frame")
panel.Name, panel.Size = "Panel", UDim2.fromOffset(Theme.CreatorWidth, Theme.CreatorHeight)
panel.AnchorPoint, panel.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)
panel.BackgroundColor3, panel.Parent = Theme.Background, gui
local scale = Instance.new("UIScale")
scale.Parent = panel
local function resize()
	local size = workspace.CurrentCamera.ViewportSize
	scale.Scale = math.min(1, (size.X-24)/Theme.CreatorWidth, (size.Y-30)/Theme.CreatorHeight)
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
resize()
local function text(class, name, value, position, size)
	local item = Instance.new(class)
	item.Name, item.Text, item.Position, item.Size = name, value, position, size
	item.BackgroundColor3, item.TextColor3, item.Font, item.TextSize = Theme.Muted, Theme.Text, Theme.Font, Theme.TextSize
	item.Parent = panel
	local corner = Instance.new("UICorner")
	corner.CornerRadius, corner.Parent = UDim.new(0, Theme.CornerRadius), item
	return item
end
text("TextLabel", "Title", "CREA TU BOXEADOR", UDim2.fromOffset(14, 12), UDim2.fromOffset(592, 36)).Font = Theme.TitleFont
local viewport = Instance.new("ViewportFrame")
viewport.Name, viewport.Position, viewport.Size = "Preview", UDim2.fromOffset(14, 60), UDim2.fromOffset(250, 310)
viewport.BackgroundColor3, viewport.Ambient, viewport.LightColor = Theme.Background, Color3.new(0.8,0.8,0.8), Color3.new(1,1,1)
viewport.Parent = panel
local world = Instance.new("WorldModel")
world.Parent = viewport
local camera = Instance.new("Camera")
camera.CFrame, camera.Parent = CFrame.lookAt(Vector3.new(4, 2, -9), Vector3.new(0, 0.4, 0)), viewport
viewport.CurrentCamera = camera
local preview
local previewRevision = 0
local function updatePreview()
	previewRevision = previewRevision + 1
	local revision, selected = previewRevision, table.clone(choice)
	if player:GetAttribute("AparienciaElegida") then return end
	task.spawn(function()
		local ok, model = pcall(Rig.Create, { Appearance = selected })
		if not ok then warn("Vista previa no disponible", model) return end
		if revision ~= previewRevision or player:GetAttribute("AparienciaElegida") then model:Destroy() return end
		if preview then preview:Destroy() end
		preview = model
		Rig.AssemblePreview(preview)
		preview.HumanoidRootPart.Anchored = true
		preview.Parent = world
	end)
end
updatePreview()
for index, field in ipairs(Config.Fields) do
	local button = text("TextButton", field, "", UDim2.fromOffset(280, 65+(index-1)*52), UDim2.fromOffset(322, 44))
	local function label() button.Text = field .. ": " .. Config[field][choice[field]].Name .. "  ›" end
	label()
	button.Activated:Connect(function()
		choice[field] = choice[field] % #Config[field] + 1
		label()
		updatePreview()
	end)
end
local save = text("TextButton", "Confirmar", "Listo, entrar al gym", UDim2.fromOffset(280, 285), UDim2.fromOffset(322, 44))
save.BackgroundColor3, save.TextColor3 = Theme.Accent, Theme.Background
local message = text("TextLabel", "Message", "Elige con los botones. Se guardará tu elección.", UDim2.fromOffset(280, 337), UDim2.fromOffset(322, 40))
message.BackgroundTransparency, message.TextWrapped = 1, true
local pending = false
save.Activated:Connect(function()
	if pending or player:GetAttribute("EstadoDatos") ~= "Listo" then return end
	pending = true
	save.Text = "Guardando…"
	Choose:FireServer(choice)
	task.delay(Settings.AppearanceRetrySeconds, function()
		pending = false
		save.Text = "Listo, entrar al gym"
	end)
end)
Choose.OnClientEvent:Connect(function(ok)
	pending = false
	if not ok then message.Text = "No se pudo elegir. Revisa el estado de tus datos." end
end)
local function refresh()
	gui.Enabled = player:GetAttribute("EstadoDatos") == "Listo" and not player:GetAttribute("AparienciaElegida")
end
player:GetAttributeChangedSignal("EstadoDatos"):Connect(refresh)
player:GetAttributeChangedSignal("AparienciaElegida"):Connect(refresh)
refresh()
