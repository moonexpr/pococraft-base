ModInfo.Name = "Extended Eject Policies"
ModInfo.Author = "Potatofactory"

function TestSuccess( result )
	return true
end


function PlayerUsernames()
	struct = {}
	for _, ply in pairs(player.GetAll()) do
		struct[ply:SteamID64()] = ply:Nick()
	end
	return struct
end

NetworkBannedAccounts = {
	
}

EEPConfig ={
	UnknownMessage = "                        Unknown Error (-1, 1E)                        --------------------------------------------------------------------   ♣ To fix this please visit us @ forums.pococraft.org ♣   ",
	BannedMessage = "                        You have been banished                        --------------------------------------------------------------------   ♣ To appeal to this visit us at forums.pococraft.org ♣   ",
	BadNameMessage = "                             Bad Username                             --------------------------------------------------------------------  ♣ Change your name as it interferes with our systems ♣  ",
	LockedMessage = "Sorry, This server is dedicated to the development of the Christmas Update.",
	FailedToJoinSFX = "buttons/button2.wav",
}

hook.Add("PostGamemodeLoaded", "", function()
	function GAMEMODE:CheckPassword( SteamID64, IP, ServerPass, ClientPass, ClientName )

		function PrintError( Message, ClientName, SteamID64, BanExtra )
			ServerLog( "[EVENT] " ..ClientName .. " (" .. util.SteamIDFrom64( SteamID64 ) .. ") attempted to join the game, but recieved the error code " .. Message .. ".\n" )
			PrintMessage( HUD_PRINTTALK, string.format( "<avatar=%s> <hsv>%s (%s)</hsv> failed to join the server: <c=200,0,50>%s</c>", util.SteamIDFrom64( SteamID64 ), ClientName, util.SteamIDFrom64( SteamID64 ), Message ) )
			BroadcastLua( "surface.PlaySound(\"buttons/button2.wav\")" )
		end
		if ServerPass != "" and ServerPass != ClientPass then
			PrintError( "SERVER_AUTH_FAIL", ClientName, SteamID64 )
			return false, EEPConfig.LockedMessage
		elseif ULib.bans[ util.SteamIDFrom64( SteamID64 ) ] ~= nil then
			local strReason = ULib.bans[ util.SteamIDFrom64( SteamID64 ) ].reason or "Unknown Reason"
			local strAdmin = ULib.bans[ util.SteamIDFrom64( SteamID64 ) ].admin or "pococraft.org"
			PrintMessage( HUD_PRINTTALK, string.format( ":information: \"%s\" - <c=200,0,0>%s</c>", strReason, strAdmin ) )
			PrintError( "SERVER_BANNED", ClientName, SteamID64 )
			return false, EEPConfig.BannedMessage
		elseif table.HasValue(PlayerUsernames(), ClientName) then
			PrintError( "CLIENT_BADNAME", ClientName, SteamID64 )
			return false, EEPConfig.BadNameMessage
		elseif table.HasValue(NetworkBannedAccounts, util.SteamIDFrom64(SteamID64)) then
			PrintError( "SERVER_NETWORK_FAIL", ClientName, SteamID64 )
			return false, EEPConfig.UnknownMessage
		else
			return true
		end

	end
end)