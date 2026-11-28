local Appearance = {
	Fields = { "Piel", "Cabello", "Cara", "Shorts" },
	Piel = {
		{ Name = "Clara", Color = { 244, 201, 163 } },
		{ Name = "Media", Color = { 190, 128, 85 } },
		{ Name = "Oscura", Color = { 105, 66, 48 } },
	},
	Cabello = { { Name = "Rapado" }, { Name = "Corto" }, { Name = "Cresta" } },
	Cara = { { Name = "Sonrisa" }, { Name = "Seria" }, { Name = "Decidida" } },
	Shorts = {
		{ Name = "Rojo", Color = { 232, 66, 76 } },
		{ Name = "Azul", Color = { 52, 121, 232 } },
		{ Name = "Verde", Color = { 49, 174, 126 } },
	},
	Default = { Piel = 2, Cabello = 2, Cara = 1, Shorts = 1 },
}

function Appearance.Validate(value)
	if type(value) ~= "table" then return false end
	local count = 0
	for key, index in pairs(value) do
		count = count + 1
		if not table.find(Appearance.Fields, key) or type(index) ~= "number"
			or index % 1 ~= 0 or not Appearance[key][index] then return false end
	end
	return count == #Appearance.Fields
end

return Appearance
