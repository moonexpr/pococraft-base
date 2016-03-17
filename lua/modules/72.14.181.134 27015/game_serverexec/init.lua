ModInfo.Name = "Map Executables"
ModInfo.Author = "Potatofactory"

util.AddNetworkString("TriggerEvent:AmbientToggle")

function ExecuteMapEntities()
	local rules = {
		["npc_combinegunship"] = 1,
		["npc_helicopter"] = 2,
		["npc_strider"] = 2,
	}
	include("modules/72.14.181.134 27015/game_serverexec/maps/" .. game.GetMap() .. ".lua")
	if file.Exists("modules/72.14.181.134 27015/game_serverexec/maps/client/" .. game.GetMap() .. ".lua", "LUA") then
		AddCSLuaFile("modules/72.14.181.134 27015/game_serverexec/maps/client/" .. game.GetMap() .. ".lua")
	end

	hook.Add("PlayerSpawnObject", "TriggerBuildEnforce", function( ply )
		local name, trigger = ply:GetLocation()
		if name == "--not registered--" then return true end
		if ply:IsAdmin() then return true end
		if isstring(trigger) or not trigger or name == "--not registered--" or name == "The Void" then
			for _, trig in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if IsValid(trig) and trig:GetClass() == "trigger_lua" then
					return true
				end
			end
			return false
		end
		return trigger.AreaData["Building"] and trigger.AreaData["Building"] or true
	end )

	hook.Add("PlayerSpawnProp", "TriggerBuildEnforce", function( ply )
		local name, trigger = ply:GetLocation()
		if name == "--not registered--" then return true end
		if ply:IsAdmin() then return true end
		if isstring(trigger) or not trigger or name == "--not registered--" or name == "The Void" then
			for _, trig in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if IsValid(trig) and trig:GetClass() == "trigger_lua" then
					return true
				end
			end
			return false
		end
		return trigger.AreaData["Building"] and trigger.AreaData["Building"] or true
	end )

	hook.Add("PlayerSpawnNPC", "TriggerBuildEnforce", function( ply, class )
		if rules[class] and rules[class] <= #ents.FindByClass(class) then
			ply:ChatAddText("There may only be " .. rules[class] .. " of these NPCs because they cause too much sound and annoyance.")
			ply:ChatAddText("Sorry :(")
			return false
		end
		local name, trigger = ply:GetLocation()
		if name == "--not registered--" then return true end
		if ply:IsAdmin() then return true end
		if isstring(trigger) or not trigger or name == "--not registered--" or name == "The Void" then
			for _, trig in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if IsValid(trig) and trig:GetClass() == "trigger_lua" then
					return true
				end
			end
			return false
		end
		return trigger.AreaData["Building"] and name ~= "Spawning Area" -- Spawning NPCs at spawn is legal
	end )

	hook.Add("PlayerSpawnSENT", "TriggerBuildEnforce", function( ply )
		local name, trigger = ply:GetLocation()
		if name == "--not registered--" then return true end
		if ply:IsAdmin() then return true end
		if isstring(trigger) or not trigger or name == "--not registered--" or name == "The Void" then
			for _, trig in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if IsValid(trig) and trig:GetClass() == "trigger_lua" then
					return true
				end
			end
			return false
		end
		return trigger.AreaData["Building"] and trigger.AreaData["Building"] or true
	end )

	hook.Add("PlayerSpawnSWEP", "TriggerBuildEnforce", function( ply )
		local name, trigger = ply:GetLocation()
		if name == "--not registered--" then return true end
		if ply:IsAdmin() then return true end
		if isstring(trigger) or not trigger or name == "--not registered--" or name == "The Void" then
			for _, trig in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if IsValid(trig) and trig:GetClass() == "trigger_lua" then
					return true
				end
			end
			return false
		end
		return trigger.AreaData["Building"] and trigger.AreaData["Building"] or true
	end )

	hook.Add("PlayerSpawnVehicle", "TriggerBuildEnforce", function( ply )		
		local name, trigger = ply:GetLocation()
		if name == "--not registered--" then return true end
		if ply:IsAdmin() then return true end
		if isstring(trigger) or not trigger or name == "--not registered--" or name == "The Void" then
			for _, trig in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if IsValid(trig) and trig:GetClass() == "trigger_lua" then
					return true
				end
			end
			return false
		end
		return trigger.AreaData["Building"] and trigger.AreaData["Building"] or true
	end )

	hook.Add("EntityTakeDamage", "TriggerBuildEnforce", function( ent, dmginfo )
		if ent:IsPlayer() then
			if dmginfo:GetAttacker():IsPlayer() then
				attackerLocation = dmginfo:GetAttacker():GetLocation()
			else
				attackerLocation = "NPC"
			end
			
			if attackerLocation ~= "NPC" and ent:GetLocation() == "Spawning Area" or attackerLocation == "Spawning Area" then
				if dmginfo:GetAttacker() == ent then
					return dmginfo -- Self-harm is kool
				end
				dmginfo:GetAttacker():TakeDamage(dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor())
				dmginfo:SetDamage(0)
			elseif attackerLocation == "NPC" and ent:GetLocation() == "Spawning Area" then
				if not dmginfo:GetAttacker():CPPIGetOwner() then return dmginfo end
				--print(tostring(dmginfo:GetAttacker():CPPIGetOwner()))
				local _, trig = dmginfo:GetAttacker():CPPIGetOwner():GetLocation()
				if trig.AreaData["Building"] then
					dmginfo:GetAttacker():CPPIGetOwner():TakeDamage(dmginfo:GetDamage() * 2, dmginfo:GetAttacker(), dmginfo:GetInflictor()) -- Attack spawner
				else
					dmginfo:GetAttacker():CPPIGetOwner():TakeDamage(dmginfo:GetDamage() * 2, dmginfo:GetAttacker():CPPIGetOwner(), dmginfo:GetInflictor()) -- Attack spawner
				end
				if dmginfo:GetAttacker():IsNPC() and util.IsValidRagdoll(dmginfo:GetAttacker():GetModel()) then
					dmginfo:GetAttacker():Fire("BecomeRagdoll") -- Death Animations are neat
				else
					dmginfo:GetAttacker():Fire("Kill")
				end
				dmginfo:SetDamage(0)
			end
			
			return dmginfo
		end
	end )
	hook.Add("PlayerDeath", "TriggerBuildEnforce", function( ply, _, attacker )
		if ply:GetLocation() == "Spawning Area" and attacker:IsPlayer() and ply ~= attacker then
			attacker:Kill()
			if ply:IsAdmin() then
				ulx.warn(ply, attacker, "Spawnkilling")
			else
				game.ConsoleCommand(string.format("ulx warn \"%s\" \"Spawnkilling\"\n", attacker:Nick()))
			end
		end
	end )
end

hook.Add("PostCleanupMap", "ReloadMapEntsNShit", ExecuteMapEntities)
hook.Add("InitPostEntity", "MapEntsNShit", function() timer.Simple(1, ExecuteMapEntities) end)

function TestSuccess()
	return true
end