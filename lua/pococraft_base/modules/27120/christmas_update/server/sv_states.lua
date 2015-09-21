if GetConVarString("gamemode") != "sandbox" then -- Safety First!
	ChangeServerState( GAME_STATE_MISMATCH )
	AddSystemLog( "INFO", "Changing server state to MISMATCH" )
end

if Config.DevelopmentMode then
	ChangeServerState( GAME_STATE_DEVELOPMENT )
	AddSystemLog( "INFO", "Changing server state to DEVELOPMENT" )
end