local Physique = {
	Stats = { "Fuerza", "Velocidad", "Stamina", "Defensa" },
	StrengthMaximum = 500,
	StrengthWidthBonus = 0.2,
	Levels = {
		{ Name = "Flaco", Minimum = 1, Torso = 0.85, Arms = 0.75, Legs = 0.85, Height = 1 },
		{ Name = "Atlético", Minimum = 25, Torso = 1, Arms = 1, Legs = 1, Height = 1.03 },
		{ Name = "Marcado", Minimum = 75, Torso = 1.15, Arms = 1.2, Legs = 1.1, Height = 1.06 },
		{ Name = "Musculoso", Minimum = 150, Torso = 1.35, Arms = 1.45, Legs = 1.25, Height = 1.1 },
		{ Name = "Bestia", Minimum = 300, Torso = 1.6, Arms = 1.8, Legs = 1.45, Height = 1.15 },
	},
}

function Physique.Resolve(data)
	local total = 0
	for _, name in ipairs(Physique.Stats) do total = total + (data[name] or 1) end
	local level = Physique.Levels[1]
	for _, candidate in ipairs(Physique.Levels) do
		if total / #Physique.Stats >= candidate.Minimum then level = candidate end
	end
	return level, math.clamp(((data.Fuerza or 1) - 1) / (Physique.StrengthMaximum - 1), 0, 1)
		* Physique.StrengthWidthBonus
end

return Physique
