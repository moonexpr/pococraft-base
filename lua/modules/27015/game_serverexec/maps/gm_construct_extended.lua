for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end

local theater = ents.Create("trigger_lua")
theater:Spawn()
theater:SetCollisionBoundsWS( Vector( 4512.780273, -731.968750, -1824.031250 ), Vector( 5565.356445, 39.968754, -2079.036133 ) )
theater.AreaData["Name"] = "Theater"
theater.AreaData["StartTouchCallback"] = function( ply )
	if ply:IsPlayer() then
		ply:SetLocation("Theater")
		ply:StripWeapons()
		ply:Give("none")
		ply:SendLua([[PSA.Undertale.Message("Welcome to the theater!")]])
		ply:SendLua([[PSA.Undertale.Message("The following has been temporarily disabled:\nProp Spawning\nWeapon Usage")]])
	elseif ply:CPPIGetOwner() and not ply:CPPIGetOwner():IsAdmin() then
		ply:Remove()
	end
end

local spawnarea = ents.Create("trigger_lua")
spawnarea:Spawn()
spawnarea:SetCollisionBoundsWS( Vector( 2910.262695, -2831.849609, -2070.634033 ), Vector( 3645.227051, -4570.919434, -1563.968750 ) )
spawnarea.AreaData["Name"] = "Spawning Area"
spawnarea.AreaData["Building"] = false

local ee1 = ents.Create("easter_egg1")
ee1:SetPos(Vector(1215.746826, -4630.137695, -2430))
ee1:SetAngles(Angle(0, 135, 0))
ee1:Spawn()

hook.Add("ScalePlayerDamage", "SpawnEnforce", function( ply, _, dmginfo )
	if dmginfo:GetAttacker():GetLocation() == "Spawning Area" or ply:GetLocation() == "Spawning Area" then
		dmginfo:SetDamage(0)
	end
	return dmginfo
end )

hook.Add("PlayerSpawnObject", "SpawnEnforce", function( ply )
	return ply.Location ~= "Theater"
end )

hook.Add("PlayerSwitchWeapon", "Donotspawnintheaterplz", function( ply, _, wep )
	if ply.Location == "Theater" and not wep:GetClass() == "none" then
		ply:StripWeapons()
		ply:Give("none")
		return true
	else
		return false
	end
end )

hook.Add("AcceptInput", "Donotspawnintheaterplz", function( ent, _, _, ply )
	if ent:EntIndex() == 220 or ent:EntIndex() == 178 then
		return not ply:IsAdmin()
	end
end )
