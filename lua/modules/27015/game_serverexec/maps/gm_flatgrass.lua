for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end

local spawn = ents.Create("trigger_lua")
spawn:Spawn()
spawn:SetCollisionBoundsWS( Vector( 1026.225952, -1026.783325, -12287.698242 ), Vector( -1025.982178, 1025.757935, -9000 ) )
spawn.AreaData["Name"] = "Spawning Area"
spawn.AreaData["Building"] = false
spawn.AreaData["StartTouchCallback"] = function( ply )
	if not ply:IsPlayer() then return end
	local hasNone = function()
		for num, w in pairs(LocalPlayer():GetWeapons()) do
			if w:GetClass() == "none" then
				return w
			elseif num == #LocalPlayer():GetWeapons() then
				return false
			end
		end
	end
	if hasNone then
		ply:SetActiveWeapon(hasNone)
	else
		local spawnweapon = ents.Create("none")
		spawnweapon:Spawn()
		ply:SetActiveWeapon(spawnweapon)
	end
end

hook.Add("PlayerSpawnObject", "SpawnEnforce", function( ply )
	ply:Notify(3, "error", "You can't build at spawn :(")
	ply:Notify(5, "error", "Try hopping off and trying again")
	return ply:GetLocation() ~= "Spawning Area"
end )

hook.Add("ScalePlayerDamage", "SpawnEnforce", function( _, _, dmginfo )
	if dmginfo:GetAttacker():GetLocation() == "Spawning Area" then
		dmginfo:SetDamage(0)
	end
	return dmginfo
end )