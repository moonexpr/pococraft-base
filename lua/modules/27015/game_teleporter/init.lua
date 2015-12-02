ModInfo.Name = "Server Teleporter"
ModInfo.Author = "Potatofactory"

Escape = false

EntsList = {} -- Blank for now!

include('server/sv_config.lua')
include('server/sv_hooks.lua')
include('server/sv_autoevents.lua')
include('server/sv_objects.lua')

function TestSuccess()
	return true
end