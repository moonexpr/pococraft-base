ModInfo.Name = "Map Executables"
ModInfo.Author = "Potatofactory"

util.AddNetworkString("TriggerEvent_SafeZone")

include("maps/" .. game.GetMap() .. ".lua")

hook.Add("PostCleanupMap", "ReloadMapEntsNShit", function() include("maps/" .. game.GetMap() .. ".lua") end)

function TestSuccess()
	return true
end