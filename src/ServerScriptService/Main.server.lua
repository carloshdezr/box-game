-- Punto de entrada del servidor. Aquí solo se arrancan los servicios.
local Services = script.Parent.Services
local PlayerData = require(Services.PlayerDataService)
PlayerData.Start()
require(Services.StudioDebug).Start(PlayerData)
