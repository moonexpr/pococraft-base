ModInfo.Name = "Spawn Manager"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

--include("config.lua")

--[[
	Used for a awesome spawn/death effect
]]--

hook.Add("PlayerDeath", "TeleportDeathEffect", function(ply, weapon, attacker)

	if not tobool(ply:GetInfoNum("mp_teleport_death", 1)) then return end

	local ent = ply:GetRagdollEntity()
	local dissolve = ents.Create("env_entity_dissolver")
	
	if ply == attacker then
		ent:SetName(tostring(ent:GetCreationID()))
		dissolve:SetPos(ent:GetPos())
		dissolve:SetKeyValue("target", ent:GetName())
		dissolve:SetKeyValue("dissolvetype", "1")
		dissolve:Spawn()
		dissolve:Fire("Dissolve", "", 0)
		dissolve:Fire("kill", "", 1)
		
		ply:EmitSound("ambient/machines/teleport4.wav")
	else
		ent:SetName(tostring(ent:GetCreationID()))
		dissolve:SetPos(ent:GetPos())
		dissolve:SetKeyValue("target", ent:GetName())
		dissolve:SetKeyValue("dissolvetype", "0")
		dissolve:Spawn()
		dissolve:Fire("Dissolve", "", 0)
		dissolve:Fire("kill", "", 1)
		
		ply:EmitSound("ambient/machines/teleport3.wav")
	end
	
	ply:ScreenFade( SCREENFADE.OUT, color_white, .45, .7 )
	timer.Simple( .7, function ()
		ply:Spawn()
		ply:ScreenFade( SCREENFADE.IN, color_white, .25, .25 )
	end )
end)

--[[
	Warning Clearing
]]--

local function WarnEPOELog(msg)
	parse = string.format("epoe.AddText(Color(200, 0, 0), [[Warn Bot (INGAME): ]], Color(255, 255, 255), [[%s\n]])", msg)
	for _, ply in pairs(player.GetAll()) do
		if ply:IsAdmin() then
			ply:SendLua(parse)
		end
	end
end

hook.Add("PlayerSpawn", "CheckWarnings", function(ply)
	local month = ply:GetPData( 'warnings_month', 99 )
	if ply:GetPData("warnings", 0) == 0 then return end
	if month == 99 then
		ply:RemovePData( 'warnings_month' )
		ply:RemovePData( 'warnings' )
		ply:RemovePData( 'Warnings' )
		WarnEPOELog("Running cleanup on " ..  ply:Nick() .. "'s warnings. Reason (\"No past month data is available\").")
	elseif month ~= os.date( "%m", os.time() ) then
		ply:RemovePData( 'warnings_month' )
		ply:RemovePData( 'warnings' )
		WarnEPOELog("Running cleanup on " ..  ply:Nick() .. "'s warnings. Reason (\"Month Expired\").")
	end
end )

--[[
	Admin Room
]]--
--if AdminRooms[game.GetMap()] ~= nil then
--	local safe = math.abs(AdminRooms[game.GetMap()][2])
--	hook.Add("PlayerSpawn", "AdminSpawn", function(ply)
--		ply:SetNWInt("Warnings", ply:GetPData("Warnings", 0))
--		local safepos = AdminRooms[game.GetMap()][1] + Vector(math.random(0 - safe, safe), math.random(0 - safe, safe), 0)
--		local realpos = util.TraceLine( {
--			start = safepos,
--			endpos = safepos - Vector(0, 0, 10000),
--			mask = MASK_BLOCKLOS,
--		} )
--		if ply:IsAdmin() and tobool(ply:GetInfo("cl_sanctuary_spawn")) then
--			ply:SetPos(realpos.HitPos + Vector(0, 0, 5))
--		end
--	end )
--end

--[[
	Authenticating User
]]--

local function EPOELog(msg)
	parse = string.format("epoe.AddText(Color(200, 0, 50), [[Constant Rank: ]], Color(255, 255, 255), [[%s\n]])", msg)
	for _, ply in pairs(player.GetAll()) do
		if ply:IsAdmin() then
			ply:SendLua(parse)
		end
	end
end

local function CheckUser( ply )
	if StaticRanks[ply:SteamID()] ~= nil and ply:GetUserGroup() ~= StaticRanks[ply:SteamID()] then
		local chatstr = "say Rank Mismatch! {user} is suppose to be under {group}\n"
		local constr = "ulx adduserid {steamid} {group}\n"
		local constr_remove = "ulx removeuserid {steamid}\n"
		EPOELog(string.format("%s is in the incorrect usergroup! Moving...", ply:Nick()))
		game.ConsoleCommand(string.gsub(string.gsub(chatstr, "{user}", ply:Nick()), "{group}", StaticRanks[ply:SteamID()] .. " " .. SecurityKey.User))
		if StaticRanks[ply:SteamID()] == "user" then
			game.ConsoleCommand(string.gsub(constr_remove, "{steamid}", ply:SteamID()) .. " " .. SecurityKey.User)
		else
			game.ConsoleCommand(string.gsub(string.gsub(constr, "{steamid}", ply:SteamID()), "{group}", StaticRanks[ply:SteamID()]) .. " " .. SecurityKey.User)
		end
	else
		EPOELog(string.format("%s is in the correct usergroup! :)", ply:Nick()))
	end
end

--hook.Add("PlayerAuthed", "CheckUsergroup", CheckUser)

--[[
	Used for pointing where exactly 'spawn' is
]]--

--local function SpawnModels()
--	for k, v in pairs(ents.FindByModel( "models/editor/playerstart.mdl" )) do
--		v:Remove()
--	end
--
--	Ents = {}
--
--	for k, v in pairs(ents.FindByClass( "info_player_start" )) do
--		local trace = {
--			start = v:GetPos(),
--			endpos = v:GetPos() - Vector( 0, 0, 32768 ),
--			mask = MASK_BLOCKLOS,
--		}
--		
--		e = ents.Create( "prop_dynamic" )
--		table.insert(Ents, e)
--		e:SetModel( "models/editor/playerstart.mdl" )
--		e:SetPos(util.TraceLine(trace).HitPos)
--		e:SetAngles( v:GetAngles() )
--		e:Spawn()
--		
--	end
--
--	hook.Add( "Tick", "Rotate", function()
--		for k, v in pairs(Ents) do
--			if IsValid(v) then
--				v:SetAngles( v:GetAngles() + Angle(	0, 3, 0 ) )
--			end
--		end
--	end )
--end
--
--hook.Add( "InitPostEntity", "", SpawnModels)
--hook.Add( "PostCleanupMap", "", SpawnModels)