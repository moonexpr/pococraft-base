if GetConVarString("gamemode") != "sandbox" then -- Safety First!
	ChangeServerState( GAME_STATE_MISMATCH )
else

if Config.DevelopmentMode then
	ChangeServerState( GAME_STATE_DEVELOPMENT )
end