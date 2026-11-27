-- Punto de entrada del servidor. Aquí solo se arrancan los servicios.
local Services = script.Parent.Services
local PlayerData = require(Services.PlayerDataService)
PlayerData.Start()
local stations, spawnCFrame = require(Services.GymService).Build()
local Training = require(Services.TrainingService)
Training.Start(PlayerData, stations, spawnCFrame)
require(Services.StudioDebug).Start(PlayerData, Training)
