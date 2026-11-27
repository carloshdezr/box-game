local Config = require(game:GetService("ReplicatedStorage").Config.Training)
local Theme = require(game:GetService("ReplicatedStorage").Config.Theme)
local Gym = {}

function Gym.Build()
	local previous = workspace:FindFirstChild("GymFromRepo")
	if previous then previous:Destroy() end
	local root = Instance.new("Model")
	root.Name = "GymFromRepo"
	local palette = Theme.Gym
	local origin = Vector3.new(0, 20, 0)
	local function part(parent, name, size, pos, color)
		local p = Instance.new("Part")
		p.Name, p.Size, p.Position = name, size, origin + pos
		p.Anchored = true
		p.Material = Enum.Material.SmoothPlastic
		p.Color = color
		p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
		p.Parent = parent
		return p
	end
	local function sign(parent, name, pos, text, color, width)
		local board = part(parent, name, Vector3.new(width or 10, 3, 0.4), pos, color)
		local surface = Instance.new("SurfaceGui")
		surface.Face = Enum.NormalId.Back
		surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		surface.PixelsPerStud = 40
		surface.Parent = board
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Text, label.Font, label.TextColor3 = text, Theme.TitleFont, Theme.Text
		label.TextScaled, label.TextWrapped = true, true
		label.Parent = surface
		return label
	end
	part(root, "Piso", Vector3.new(92, 1, 88), Vector3.new(0, 0, 0), palette.Floor)
	part(root, "ParedFondo", Vector3.new(92, 15, 1), Vector3.new(0, 8, -44), palette.Wall)
	for _, x in ipairs({-46, 46}) do
		part(root, "ParedLateral", Vector3.new(1, 15, 88), Vector3.new(x, 8, 0), palette.Wall)
		part(root, "Franja", Vector3.new(1.1, 1, 88), Vector3.new(x, 5, 0), palette.Trim)
	end
	for _, x in ipairs({-29, 29}) do
		part(root, "EntradaLateral", Vector3.new(34, 15, 1), Vector3.new(x, 8, 44), palette.Wall)
	end
	part(root, "Dintel", Vector3.new(24, 3, 1), Vector3.new(0, 14, 44), palette.Trim)
	sign(root, "Titulo", Vector3.new(0, 11, -43), "BOX • ENTRENA Y CRECE", palette.Dark, 42)
	sign(root, "Entrada", Vector3.new(0, 14, 44.5), "GYM", palette.Dark, 16)
	-- Empty reservation only: no combat ring in Fase 2.
	for _, z in ipairs({-8, 8}) do
		part(root, "MarcaRing", Vector3.new(20, 0.08, 0.3), Vector3.new(0, 0.56, z), palette.Trim)
	end
	for _, x in ipairs({-10, 10}) do
		part(root, "MarcaRing", Vector3.new(0.3, 0.08, 16), Vector3.new(x, 0.56, 0), palette.Trim)
	end
	sign(root, "RingFuturo", Vector3.new(0, 3, -9), "ESPACIO PARA EL RING\nPróximamente", palette.Dark, 18)
	local stations = {}
	for kindIndex, kind in ipairs(Config.StationOrder) do
		local col = kindIndex <= 2 and -28 or 28
		local row = kindIndex % 2 == 1 and -25 or 12
		for copy = 1, Config.Copies do
			local center = Vector3.new(col + (copy == 1 and -7 or 7), 0, row)
			local model = Instance.new("Model")
			model.Name = kind .. "_" .. copy
			model:SetAttribute("StationType", kind)
			model:SetAttribute("Occupied", false)
			model.Parent = root
			local color = palette[kind]
			part(model, "Tapete", Vector3.new(12, 0.2, 15), center + Vector3.new(0, 0.65, 0), color)
			local host = part(model, "Uso", Vector3.new(1, 1, 1), center + Vector3.new(0, 3, 5), color)
			host.Transparency, host.CanCollide = 1, false
			local label = sign(model, "Letrero", center + Vector3.new(0, 11, -4), kind .. "\nLIBRE", palette.Dark)
			if kind == "Saco" then
				part(model, "Soporte", Vector3.new(1, 8, 1), center + Vector3.new(0, 4, -3), palette.Dark)
				part(model, "Brazo", Vector3.new(1, 1, 5), center + Vector3.new(0, 8, -1), palette.Dark)
				part(model, "Cadena", Vector3.new(0.3, 1, 0.3), center + Vector3.new(0, 7.2, 1), palette.Trim)
				part(model, "Saco", Vector3.new(3, 4.5, 3), center + Vector3.new(0, 4.5, 1), color)
			elseif kind == "Caminadora" then
				part(model, "Cinta", Vector3.new(5, 0.6, 8), center + Vector3.new(0, 1.1, 0), palette.Dark)
				for _, x in ipairs({-3, 3}) do
					part(model, "Barandal", Vector3.new(0.4, 3, 0.4), center + Vector3.new(x, 2, -3), color)
				end
				part(model, "Consola", Vector3.new(6, 1, 1), center + Vector3.new(0, 3.8, -3), palette.Trim)
				for z = -2, 3, 2 do part(model, "Raya", Vector3.new(4.7, 0.05, 0.2), center + Vector3.new(0, 1.43, z), color) end
			elseif kind == "Pesas" then
				part(model, "Banco", Vector3.new(3, 1, 6), center + Vector3.new(0, 2, 1), color)
				for _, x in ipairs({-4, 4}) do
					part(model, "Soporte", Vector3.new(0.5, 4, 0.5), center + Vector3.new(x, 2.5, -2), palette.Dark)
					part(model, "Disco", Vector3.new(1.2, 3, 3), center + Vector3.new(x, 5, -2), color)
				end
				part(model, "Barra", Vector3.new(10, 0.4, 0.4), center + Vector3.new(0, 5, -2), palette.Trim)
			else
				part(model, "Poste", Vector3.new(0.7, 6, 0.7), center + Vector3.new(0, 3.6, 0), palette.Dark)
				local ball = part(model, "Pera", Vector3.new(2.3, 3, 2.3), center + Vector3.new(0, 6, 0), color)
				ball.Shape = Enum.PartType.Ball
				part(model, "Base", Vector3.new(4, 0.5, 4), center + Vector3.new(0, 1, 0), palette.Trim)
			end
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name, prompt.ActionText, prompt.ObjectText = "Entrenar", "Entrenar", kind
			prompt.KeyboardKeyCode = Enum.KeyCode.E
			prompt.HoldDuration, prompt.MaxActivationDistance = Config.PromptHoldSeconds, Config.PromptDistance
			prompt.RequiresLineOfSight = false
			prompt.Parent = host
			stations[model.Name] = { Model = model, Host = host, Prompt = prompt, Label = label, Kind = kind }
		end
	end
	root.Parent = workspace
	return stations, CFrame.new(origin + Vector3.new(0, 4, 35))
end

return Gym
