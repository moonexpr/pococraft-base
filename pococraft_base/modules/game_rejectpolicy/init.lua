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

hook.Add("PostGamemodeLoaded", "", function()
	function GAMEMODE:CheckPassword( SteamID64, IP, ServerPass, ClientPass, ClientName )

		if ServerPass != "" and ServerPass != ClientPass then
			ServerLog( "[ALERT] " ..ClientName .. " (" .. util.SteamIDFrom64( SteamID64 ) .. ") attempted to enter the server with the wrong password!\n" )
			return false, "Sorry, This server is dedicated to the development of the Christmas Update."
		elseif CheckBan( util.SteamIDFrom64( SteamID64 ) ) then
			ServerLog( "[ALERT] " .. ClientName .. " (" .. util.SteamIDFrom64( SteamID64 ) .. ") attempted to enter the server while banned!\n" )
			return false, "                        You have been banished                        --------------------------------------------------------------------   ♣ To appeal to this visit us at forums.pococraft.org ♣   "
		else
			return true
		end

	end
end)
