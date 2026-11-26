local Config = require(game:GetService("ReplicatedStorage").Config.Stats)
local Persistence = require(game:GetService("ReplicatedStorage").Config.Persistence)
local Schema = {}

local function validNumber(value)
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end

function Schema.New()
	local data = { Version = Persistence.SchemaVersion, Rango = Config.InitialRank,
		PuntosRango = Config.InitialRankPoints }
	for _, name in ipairs(Config.Names) do
		data[name] = Config.InitialStat
	end
	return data
end

-- Invalid or newer records are rejected, never replaced with defaults.
function Schema.Validate(data)
	if type(data) ~= "table" or data.Version ~= Persistence.SchemaVersion
		or not Config.RankCaps[data.Rango] or not validNumber(data.PuntosRango)
		or data.PuntosRango < 0 or data.PuntosRango % 1 ~= 0 then
		return false
	end
	for _, name in ipairs(Config.Names) do
		if not validNumber(data[name]) or data[name] < Config.InitialStat
			or data[name] > Config.RankCaps[data.Rango] then
			return false
		end
	end
	return true
end

return Schema
