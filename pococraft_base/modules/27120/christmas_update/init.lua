ModInfo.Name = "Christmas Update"
ModInfo.Author = "Potatofactory"

include( "server/libraries/gamestate/core.lua" )
include( "server/libraries/locations/core.lua" )

include( "server/sv_convars.lua" )
include( "server/sv_states.lua" )

AddCSLuaFile( "cl_init.lua" ) -- Load client-side scripts

function TestSuccess()
	return true -- I dunno yet :|
end