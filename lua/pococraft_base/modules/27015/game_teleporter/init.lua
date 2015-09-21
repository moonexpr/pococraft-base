ModInfo.Name = "Server Teleporter"
ModInfo.Author = "Potatofactory"

EntsList ={}

include 'server/sv_config.lua'
include 'server/sv_autoevents.lua'
include 'server/sv_objects.lua'

hook.Add( "InitPostEntity", "GenerateTheTeleporter", function()
	timer.Simple( 10, function ()
		GenerateTeleporter()
		include 'server/sv_hooks.lua'
	end )
end )

function TestSuccess()
	return true
end