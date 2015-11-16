ModInfo.Name = "Extended Eject Policies"
ModInfo.Author = "Potatofactory"

function TestSuccess( result )
	return true
end


function CheckBan(SteamID)
	if ULib.bans[ SteamID ] != nil then
		return true
	else
		return false
	end	
end

EEPConfig ={
	BannedMessage = "                        You have been banished                        --------------------------------------------------------------------   ♣ To appeal to this visit us at forums.pococraft.org ♣   ",
	LockedMessage = "Sorry, This server is dedicated to the development of the Christmas Update.",
	FailedToJoinSFX = "buttons/button2.wav",
}

hook.Add("PostGamemodeLoaded", "", function()
	function GAMEMODE:CheckPassword( SteamID64, IP, ServerPass, ClientPass, ClientName )

		function PrintError( Message, ClientName, SteamID64 )
			ServerLog( "[EVENT] " ..ClientName .. " (" .. util.SteamIDFrom64( SteamID64 ) .. ") attempted to join the server but recieved error: " .. Message .. "!\n" )
			PrintMessage( HUD_PRINTTALK, string.format( "<avatar=%s> <hsv>%s (%s)</hsv> failed to join the server: <c=200,0,50>%s</c>", util.SteamIDFrom64( SteamID64 ), ClientName, util.SteamIDFrom64( SteamID64 ), Message ) )
			BroadcastLua( "surface.PlaySound(\"buttons/button2.wav\")" )
		end
		if ServerPass != "" and ServerPass != ClientPass then
			PrintError( "SERVER_AUTH_FAIL", ClientName, SteamID64 )
			return false, EEPConfig.LockedMessage
		elseif CheckBan( util.SteamIDFrom64( SteamID64 ) ) then
			PrintError( "SERVER_BANNED", ClientName, SteamID64 )
			return false, EEPConfig.BannedMessage
		else
			return true
		end

	end
end)