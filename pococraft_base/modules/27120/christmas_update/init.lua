ModInfo.Name = "Christmas Update"
ModInfo.Author = "Potatofactory"

include( "server/libraries/gamestate/core.lua" )
include( "server/libraries/locations/core.lua" )
include( "server/libraries/logging/core.lua" )

include( "server/sv_config.lua" )
include( "server/sv_states.lua" )

AddCSLuaFile( "cl_init.lua" ) -- Load client-side scripts

for key, value in pairs( Config.NaughtyList ) do
	ServerLog( "*** Appended ConVar: \"" .. convar .. "\"!\n")
	game.ConsoleCommand( string.format( "%s\n", convar ) )
end

function TestSuccess()
	return true -- I dunno yet :|
end