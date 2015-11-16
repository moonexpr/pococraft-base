ModInfo.Name = "Welcome Announcement"
ModInfo.Author = "Potatofactory, Mr. Floppy Disk"

function TestSuccess()
	return true
end

ServerName = {
	s27015 = "Club Random",
	s27120 = "Christmas Town (Developer Server)"
}

hook.Add( "PlayerInitialSpawn", "AnnouncePlayer", function( player_object )
	if player_object:IsAdmin() and player_object:IsValid() then
		PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <hsv>%s (Staff Member)</hsv> has entered <c=150,0,250>%s</c>", player_object:SteamID(), player_object:Nick(), ServerName["s" .. GetConVar("hostport"):GetInt()] ) )
	else
		PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <hsv>%s (%s)</hsv> has entered <c=150,0,250>%s</c>", player_object:SteamID(), player_object:Nick(), player_object:SteamID(), ServerName["s" .. GetConVar("hostport"):GetInt()] ) )
	end
	local sound = "surface.PlaySound(\"garrysmod/save_load" .. math.random(1, 4) .. ".wav\")"
	for _, ply in pairs(player.GetAll()) do
		ply:SendLua( sound )
	end
end )

hook.Add( "PlayerDisconnected", "AnnouncePlayer", function( player_object )
	if player_object:IsAdmin() and player_object:IsValid() then
		PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <c=0,200,200>%s</c> has left <c=150,0,250>%s</c>", player_object:SteamID(), player_object:Nick(), ServerName["s" .. GetConVar("hostport"):GetInt()] ) )
	else
		PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <c=0,150,150>%s</c> has left <c=150,0,250>%s</c>", player_object:SteamID(), player_object:Nick(), ServerName["s" .. GetConVar("hostport"):GetInt()] ) )
	end
end )