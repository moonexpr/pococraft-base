ModInfo.Name = "Spawn Manager"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

include("config.lua")

--[[
	Admin Room
]]--
if AdminRooms[game.GetMap()] ~= nil then
	local safe = math.abs(AdminRooms[game.GetMap()][2])
	for _, ent in pairs(ents.FindInSphere(AdminRooms[game.GetMap()][1], 1)) do
		if ent:GetClass() == "trigger_teleport" then
			ent:Fire("Disable")	
		end
		if ent:GetClass() == "func_brush" then
			ent:Fire("Kill")
		end
	end
	hook.Add("PlayerSpawn", "AdminSpawn", function(ply)
		local safepos = AdminRooms[game.GetMap()][1] + Vector(math.random(0 - safe, safe), math.random(0 - safe, safe), 0)
		local realpos = util.TraceLine( {
			start = safepos,
			endpos = safepos - Vector(0, 0, 10000),
			mask = MASK_BLOCKLOS,
		} )
		if ply:IsAdmin() or ply:GetUserGroup() == "Respected Member" or ply:GetUserGroup() == "Senior Member" then
			ply:SetPos(realpos.HitPos + Vector(0, 0, 5))
		end
	end )
end

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
		game.ConsoleCommand(string.gsub(string.gsub(chatstr, "{user}", ply:Nick()), "{group}", StaticRanks[ply:SteamID()]) .. " \"" .. WeekdayCodes[today] .. " commit 77\"")
		if StaticRanks[ply:SteamID()] == "user" then
			game.ConsoleCommand(string.gsub(constr_remove, "{steamid}", ply:SteamID()) .. " \"" .. WeekdayCodes[today] .. " commit 77\"")
		else
			game.ConsoleCommand(string.gsub(string.gsub(constr, "{steamid}", ply:SteamID()), "{group}", StaticRanks[ply:SteamID()]) .. " \"" .. WeekdayCodes[today] .. " commit 77\"")
		end
	else
		EPOELog(string.format("%s is in the correct usergroup! :)", ply:Nick()))
	end
end

hook.Add("PlayerAuthed", "CheckUsergroup", CheckUser)

--[[
	Used for a awesome spawn/death effect
]]--

hook.Add("PlayerDeath", "", function(ply, weapon, attacker)
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
	Used for pointing where exactly 'spawn' is
]]--

local function SpawnModels()
	for k, v in pairs(ents.FindByModel( "models/editor/playerstart.mdl" )) do
		v:Remove()
	end

	Ents = {}

	for k, v in pairs(ents.FindByClass( "info_player_start" )) do
		local trace = {
			start = v:GetPos(),
			endpos = v:GetPos() - Vector( 0, 0, 32768 ),
			mask = MASK_BLOCKLOS,
		}
		
		e = ents.Create( "prop_dynamic" )
		table.insert(Ents, e)
		e:SetModel( "models/editor/playerstart.mdl" )
		e:SetPos(util.TraceLine(trace).HitPos)
		e:SetAngles( v:GetAngles() )
		e:Spawn()
		
	end

	hook.Add( "Tick", "Rotate", function()
		for k, v in pairs(Ents) do
			if IsValid(v) then
				v:SetAngles( v:GetAngles() + Angle(	0, 3, 0 ) )
			end
		end
	end )
end

hook.Add( "InitPostEntity", "", SpawnModels)
hook.Add( "PostCleanupMap", "", SpawnModels)