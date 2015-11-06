ModInfo.Name = "Server Teleporter"
ModInfo.Author = "Potatofactory"

Escape = false

EntsList = {} -- Blank for now!

include 'modules/27015/game_teleporter/server/sv_config.lua'
include 'modules/27015/game_teleporter/server/sv_hooks.lua'


function TestSuccess()
	return true
end