for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end

local adminroom = ents.Create("trigger_lua")
adminroom:Spawn()
adminroom:SetCollisionBoundsWS( Vector( -1604.031250, -3231.330566, 2304.180908 ), Vector( -3003.968750, -2244.031250, 2805.867920 ) )
adminroom.AreaData["Name"] = "Staff Sanctuary"
adminroom.AreaData["Ambience"] = [[https://api.soundcloud.com/tracks/47052638/stream?client_id=02gUJC0hH2ct1EGOcYXQIzRFU91c72Ea]]
adminroom.AreaData["UserGroupRestricted"] = {"manager", "administrator", "Respected Member"}

local spawnarea = ents.Create("trigger_lua")
spawnarea:Spawn()
spawnarea:SetCollisionBoundsWS( Vector( 1025.102539, 788.915039, -143.968750 ), Vector( 657.049744, -895.744202, 1294.723633 ) )
spawnarea.AreaData["Name"] = "Spawning Area"
spawnarea.AreaData["Building"] = false

--[[
local ee1 = ents.Create("easter_egg1")
ee1:SetPos(Vector(-1415.738403, -943.111877, -508.923676))
ee1:SetAngles(Angle(0, 135, 0))
ee1:Spawn()
]]--

local jumpgame = ents.Create( "ent_jumpgame" )
jumpgame:SetPos( Vector( 1132.885376, -784.165771, 64.031250 ) )
jumpgame:SetAngles( Angle(0, 0, 0) )
jumpgame:Spawn()

hook.Add("PlayerSpawnObject", "SpawnEnforce", function( ply )
	return ply:GetLocation() ~= "Spawning Area"
end )

hook.Add("ScalePlayerDamage", "SpawnEnforce", function( ply, _, dmginfo )
	if not ply:IsPlayer() or not dmginfo:GetAttacker():IsPlayer() then return end
	if dmginfo:GetAttacker():GetLocation() == "Spawning Area" or ply:GetLocation() == "Spawning Area" then
		dmginfo:SetDamage(0)
	end
	return dmginfo
end )