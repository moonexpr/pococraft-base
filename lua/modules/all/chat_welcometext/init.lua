ModInfo.Name = "Welcome Announcement"
ModInfo.Author = "Potatofactory, Mr. Floppy Disk"

function TestSuccess()
	return true
end


DisconnectReasons = {
	["Disconnect by user."] = "walked out of <color=150,0,250>Club Random",
	["Client left game (Steam auth ticket has been canceled)"] = "left because of a Steam mishap.",
	["Too many warnings"] = "reached the warning limit!",
	["Connection closing"] = "lost connection to <color=150,0,250>Club Random",
	["timed out"] = "has crashed and left <color=150,0,250>Club Random",
	["(manager)"] = "was removed from the game by a Manager",
	["(Administrator)"] = "was removed from the game by an Administrator",
	["You are banished"] = "was banished from this realm",
	["Vote kick successful."] = "was voted out of <color=150,0,250>Club Random",
	["Ejected from our world"] = "fell into a black hole",
	["#DisconnectUnknown"] = "left because of a Steam mishap.",
	["#DisconnectTeleporter"] = "has teleported away from <color=150,0,250>Club Random"
}

hook.Add( "PlayerInitialSpawn", "AnnouncePlayer", function( player_object )
	if player_object:SteamID() ~= "BOT" then
		local function noport(ipad)
			local nipad = ""
			nipad = ipad
			for i=1,string.len(nipad),1 do
				if (nipad[i] == ":") then
					nipad = string.sub(nipad,1,(i - 1))
				end
			end
			return nipad
		end
		http.Fetch("http://ip-api.com/json/" .. noport(player_object:IPAddress()),
		function(body)
			if player_object.origin == nil then
				local tab = util.JSONToTable(body)
				player_object.origin = tab['country']
				player_object.flag = "flags16/" .. string.lower(tab['countryCode']) .. ".png"
			end
		end,
		function()
			player_object.origin = "Unknown"
			player_object.flag = "icon16/vcard.png"
		end)
	else
		player_object.origin = "Server Farm"
		player_object.flag = "icon16/server.png"
	end
	timer.Simple( 1, function()
		if player_object.origin == nil then
			player_object.origin = "Unknown"
		end
		if not file.Exists("materials/" .. player_object.flag, "GAME") then
			player_object.flag = "icon16/vcard.png"
		end
		local customurl = player_object:GetPData("CustomPlayerSFX", "null")
		if player_object:IsAdmin() and player_object:IsValid() then
			ChatAddText( "<texture=" .. player_object.flag .."> <hsv=[t()*100]>" .. player_object:Nick() ..  " (Staff Member)", Color(255, 255, 255), " has entered ", Color(150, 0, 250), "Club Random" )
		else
			if player_object:SteamID() == "BOT" then
				ChatAddText( "<texture=" .. player_object.flag .."> <hsv=[t()*100]>" .. player_object:Nick(), Color(255, 255, 255), " has entered ", Color(150, 0, 250), "Club Random" )
			else
				ChatAddText( "<texture=" .. player_object.flag .."> <hsv=[t()*100]>" .. player_object:Nick() ..  " (" .. player_object:SteamID() .. ")", Color(255, 255, 255), " has entered ", Color(150, 0, 250), "Club Random" )
			end
		end
		local defaultsound = string.format("surface.PlaySound(\"garrysmod/save_load%i.wav\")", math.random(1, 4))
		local customsound = string.format("sound.PlayURL(\"%s\", \"3D\", function(channel) channel:SetPos(Vector(%i, %i, %i)) channel:Play() end)", customurl, player_object:GetPos().X, player_object:GetPos().Y, player_object:GetPos().Z )
		for _, ply in pairs(player.GetAll()) do
			if customurl == "null" then
				ply:SendLua( defaultsound )
			else
				ply:SendLua( customsound )
			end
		end
	end )
end )

gameevent.Listen("player_disconnect")

hook.Add("player_disconnect", "atlaschat.DisconnectMessage", function(data)
	local function LookupReason( reason )
		local strReason = nil
		for seed, string in pairs(DisconnectReasons) do
			if string.find(string.lower(reason), string.lower(seed)) then
				strReason = string
				break
			end
		end
		return strReason
	end
	local strReason = LookupReason(data.reason)
	if data.networkid == "BOT" then
		data.networkid = "STEAM_0:1:18712009"
	end
	if table.HasValue(DisconnectReasons, data.reason) or strReason ~= nil then
		if TeleporteredPlayers ~= nil and TeleporteredPlayers[data.networkid] then
			TeleporteredPlayers[data.networkid] = false
			ChatAddText( Color(0, 150, 150), data.name, Color(255, 255, 255), " " .. DisconnectReasons["#DisconnectTeleporter"] )
		else
			ChatAddText( Color(0, 150, 150), data.name, Color(255, 255, 255), " " .. strReason )
		end
	else
		ChatAddText( Color(0, 150, 150), data.name, Color(255, 255, 255), " " .. DisconnectReasons["#DisconnectUnknown"] )		
	end
end)