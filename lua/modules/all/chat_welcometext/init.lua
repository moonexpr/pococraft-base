ModInfo.Name = "Welcome Announcement"
ModInfo.Author = "Potatofactory, Mr. Floppy Disk"

function TestSuccess()
	return true
end


DisconnectReasons = {
	["Disconnect by user."] = "walked out of <c=150,0,250>Club Random</c>",
	["Client left game (Steam auth ticket has been canceled)"] = "left because of a Steam mishap.",
	["Too many warnings"] = "reached the warning limit!",
	["Connection closing"] = "lost connection to <c=150,0,250>Club Random</c>",
	["timed out"] = "has crashed and left <c=150,0,250>Club Random</c>",
	["(manager)"] = "was removed from the game by a Manager",
	["(Administrator)"] = "was removed from the game by an Administrator",
	["You are banished"] = "was banished from this realm",
	["Vote kick successful."] = "was voted out of <c=150,0,250>Club Random</c>",
	["Ejected from our world"] = "fell into a black hole",
	["#DisconnectUnknown"] = "left because of a Steam mishap.",
	["#DisconnectTeleporter"] = "has teleported away from <c=150,0,250>Club Random</c>"
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
				player_object.origin = util.JSONToTable(body)['country']
			end
		end,
		function()
			player_object.origin = "Earth"
		end)
	else
		player_object.origin = "the server"
	end
	if player_object.origin == nil then
		player_object.origin = "Earth"
	end
	local customurl = player_object:GetPData("CustomPlayerSFX", "null")
	if player_object:IsAdmin() and player_object:IsValid() then
		PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <hsv>%s (Staff Member)</hsv> has entered <c=150,0,250>Club Random</c> from %s", player_object:SteamID(), player_object:Nick(), player_object.origin ) )
	else
		if player_object:SteamID() == "BOT" then
			PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <hsv>%s (%s)</hsv> has entered <c=150,0,250>Club Random</c> from %s", "STEAM_0:1:18712009", player_object:Nick(), player_object:SteamID(), player_object.origin ) )
		else
			PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <hsv>%s (%s)</hsv> has entered <c=150,0,250>Club Random</c> from %s", player_object:SteamID(), player_object:Nick(), player_object:SteamID(), player_object.origin ) )
		end
	end
	local defaultsound = string.format("surface.PlaySound(\"garrysmod/save_load%i.wav\")", math.random(1, 4))
	local customsound = string.format("sound.PlayURL(\"%s\", \"3D\", function(channel) channel:SetPos(%i, %i, %i) channel:Play() end)", customurl, player_object:GetPos().X, player_object:GetPos().Y, player_object:GetPos().Z )
	for _, ply in pairs(player.GetAll()) do
		if customurl == "null" then
			ply:SendLua( defaultsound )
		else
			ply:SendLua( customsound )
		end
	end
end )

gameevent.Listen("player_disconnect")

hook.Add("player_disconnect", "atlaschat.DisconnectMessage", function(data)
	local function LookupReason( reason )
		local strReason = nil
		for seed, string in pairs(DisconnectReasons) do
			if string.find(reason, seed) then
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
			PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <c=0,150,150>%s</c> %s", data.networkid, data.name, DisconnectReasons["#DisconnectTeleporter"]) )
		else
			PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <c=0,150,150>%s</c> %s", data.networkid, data.name, strReason) )
		end
	else
		PrintMessage( HUD_PRINTTALK, string.format("<avatar=%s> <c=0,150,150>%s</c> %s", data.networkid, data.name, DisconnectReasons["#DisconnectUnknown"]) )
	end
end)