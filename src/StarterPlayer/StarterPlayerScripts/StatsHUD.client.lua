-- Punto de entrada del cliente. Solo muestra y pide; nunca decide resultados.
local Players = game:GetService("Players")
local Config = game:GetService("ReplicatedStorage"):WaitForChild("Config")
local Theme = require(Config:WaitForChild("Theme"))
local Stats = require(Config:WaitForChild("Stats"))
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "StatsHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "Stats"
panel.Position = UDim2.fromOffset(Theme.Margin, Theme.Margin)
panel.Size = UDim2.new(1, -Theme.Margin * 2, 0, 0)
panel.AutomaticSize = Enum.AutomaticSize.Y
panel.BackgroundColor3 = Theme.Background
panel.BorderSizePixel = 0
panel.Parent = gui
local limit = Instance.new("UISizeConstraint")
limit.MaxSize = Vector2.new(Theme.PanelWidth, math.huge)
limit.Parent = panel
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, Theme.CornerRadius)
corner.Parent = panel
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, Theme.Padding)
padding.PaddingBottom = UDim.new(0, Theme.Padding)
padding.PaddingLeft = UDim.new(0, Theme.Padding)
padding.PaddingRight = UDim.new(0, Theme.Padding)
padding.Parent = panel
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = panel

local function label(name, order, height)
	local item = Instance.new("TextLabel")
	item.Name = name
	item.LayoutOrder = order
	item.Size = UDim2.new(1, 0, 0, height or Theme.RowHeight)
	item.BackgroundTransparency = 1
	item.Font = Theme.Font
	item.TextSize = Theme.TextSize
	item.TextColor3 = Theme.Text
	item.TextXAlignment = Enum.TextXAlignment.Left
	item.TextWrapped = true
	item.Parent = panel
	return item
end

local rank = label("Rango", 0)
rank.Font = Theme.TitleFont
rank.TextSize = Theme.TitleSize
rank.TextColor3 = Theme.Accent
local rows = {}
for index, name in ipairs(Stats.Names) do
	rows[name] = label(name, index)
end
local notice = label("EstadoDatos", #Stats.Names + 1, Theme.WarningHeight)
notice.TextColor3 = Theme.Warning

local function refresh()
	rank.Text = "Rango: " .. (player:GetAttribute("Rango") or "—")
	for name, row in pairs(rows) do
		local value = player:GetAttribute(name)
		row.Text = name .. ": " .. (value and tostring(value) or "—")
	end
	local state = player:GetAttribute("EstadoDatos")
	notice.Visible = state ~= "Listo"
	notice.Text = state == "Error" and "Tu progreso no se está guardando" or "Cargando progreso…"
end

for _, name in ipairs(Stats.Names) do
	player:GetAttributeChangedSignal(name):Connect(refresh)
end
player:GetAttributeChangedSignal("Rango"):Connect(refresh)
player:GetAttributeChangedSignal("EstadoDatos"):Connect(refresh)
refresh()
