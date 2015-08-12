ModInfo.Name = "Christmas Update"
ModInfo.Author = "Potatofactory"

Initialize = {} -- Initialization Stage

include( "server/convars.lua" )
include( "server/libraries/gamestate/core.lua" )

ServerState = GAME_STATE_NORMAL

if GetConVarString("gamemode") != "sandbox" then -- Safety First!
	ChangeServerState( GAME_STATE_MISMATCH )
end

ChangeServerState( GAME_STATE_DEVELOPMENT )

function TestSuccess()
	return true -- I dunno yet :|
end