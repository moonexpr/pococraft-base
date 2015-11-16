ModInfo.Name = "Spawn Manager"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

--[[
	Authenticating User
]]--

StaticRanks = {
	["STEAM_0:1:56987503"] = "superadmin",
}

function EPOELog(msg)
	parse = string.format("epoe.AddText(Color(200, 0, 50), [[Constant Rank: ]], Color(255, 255, 255), [[%s\n]])", msg)
	for _, ply in pairs(player.GetAll()) do
		ply:SendLua(parse)
	end
end

function CheckUser( ply )
	if StaticRanks[ply:SteamID()] ~= nil and ply:GetUserGroup() ~= StaticRanks[ply:SteamID()] then
		local chatstr = "say Rank Mismatch! {user} is suppose to be under {group}\n"
		local constr = "ulx adduserid {steamid} {group}\n"
		local constr_remove = "ulx removeuserid {steamid}\n"
		EPOELog(string.format("%s is in the incorrect usergroup! Moving...", ply:Nick()))
		game.ConsoleCommand(string.gsub(string.gsub(chatstr, "{user}", ply:Nick()), "{group}", StaticRanks[ply:SteamID()]))
		if StaticRanks[ply:SteamID()] == "user" then
			game.ConsoleCommand(string.gsub(constr_remove, "{steamid}", ply:SteamID()))
		else
			game.ConsoleCommand(string.gsub(string.gsub(constr, "{steamid}", ply:SteamID()), "{group}", StaticRanks[ply:SteamID()]))
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

function SpawnModels()
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
			v:SetAngles( v:GetAngles() + Angle(	0, 3, 0 ) )
		end
	end )
end

hook.Add( "InitPostEntity", "", SpawnModels)
hook.Add( "PostCleanupMap", "", SpawnModels)