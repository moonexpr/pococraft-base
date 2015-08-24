if GetConVarString("gamemode") != "sandbox" then -- Safety First!
	ChangeServerState( GAME_STATE_MISMATCH )
end

if Config.DevelopmentMode then
	ChangeServerState( GAME_STATE_DEVELOPMENT )
end