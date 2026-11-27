-- Balance inicial aprobado el 2026-11-26. No hay ascensos ni combate en Fase 2.
return {
	StationOrder = { "Saco", "Caminadora", "Pesas", "Pera" },
	Copies = 2,
	CooldownSeconds = 5,
	ResultGraceSeconds = 5,
	PromptDistance = 9,
	MaxRoundDistance = 14,
	CheckSeconds = 0.5,
	PromptHoldSeconds = 0.25,
	NoticeSeconds = 4,
	Stations = {
		Saco = { Duration = 20, Rewards = { Fuerza = 4, Velocidad = 4 },
			BeatSeconds = 1.2, HitWindow = 0.28 },
		Caminadora = { Duration = 20, Rewards = { Stamina = 4 },
			RisePerSecond = 0.65, FallPerSecond = 0.4, ZoneMin = 0.4, ZoneMax = 0.65, InitialLevel = 0.3 },
		Pesas = { Duration = 20, Rewards = { Fuerza = 4, Defensa = 4 },
			FirstRepSeconds = 2.4, RepAcceleration = 0.12, MinRepSeconds = 1, Target = 0.75, Window = 0.2 },
		Pera = { Duration = 20, Rewards = { Velocidad = 4, Defensa = 4 },
			BeatSeconds = 0.65, HitWindow = 0.18 },
	},
	MaxMessage = "Llegaste al máximo de tu rango, pelea para subir",
}
