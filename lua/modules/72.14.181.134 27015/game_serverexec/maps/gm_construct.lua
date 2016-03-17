--@luadev please don't broadcast, thx

for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end
for _, v in pairs(ents.FindByClass("ent_jumpgame")) do v:Remove() end
for _, v in pairs(ents.FindByClass("ent_fallingplatform")) do v:Remove() end

local genloc1 = ents.Create("trigger_lua")
local genloc2 = ents.Create("trigger_lua")

genloc1:Spawn()
genloc1:SetCollisionBoundsWS( Vector( 1855.968750, -3711.818848, -159.580368 ), Vector( -5247.968750, 6463.949219, 8664.894531 ) )
genloc1.AreaData["Name"] = "Overworld"
--genloc1.AreaData["Ambience"] = "https://imagescdn.pococraft.org/temp/ambient_overworld.mp3"

genloc2:Spawn()
genloc2:SetCollisionBoundsWS( Vector( -2927.827637, 95.968750, -511.592377 ), Vector( 1855.968750, -3711.818848, -160.580368 ) )
genloc2.AreaData["Name"] = "Underground"
genloc2.AreaData["Announce"] = "Welcome to the underground chambers! Almost anything goes on here. anything."

local genloc3 = ents.Create("trigger_lua")
genloc3:Spawn()
genloc3:SetCollisionBoundsWS( Vector( -15103.968750, -15103.968750, 10367.232422 ), Vector( 15615.968750, 15103.968750, 15231.169922 ) )
genloc3.AreaData["Name"] = "Skybox"

-- Above Ground
local lake = ents.Create("trigger_lua")
lake:Spawn()
lake:SetCollisionBoundsWS( Vector( 1855.652588, 6462.933105, -834.187378 ), Vector( -2397.638672, 2100.035156, -125.964203 ) )
lake.AreaData["Name"] = "Lake"
lake.AreaData["Parent"] = genloc1

--local adminroom = ents.Create("trigger_lua")
--adminroom:Spawn()
--adminroom:SetCollisionBoundsWS( Vector( -1604.031250, -3231.330566, 2304.180908 ), Vector( -3003.968750, -2244.031250, 2805.867920 ) )
--adminroom.AreaData["Name"] = "Staff Sanctuary"
--adminroom.AreaData["Ambience"] = [[https://api.soundcloud.com/tracks/47052638/stream?client_id=02gUJC0hH2ct1EGOcYXQIzRFU91c72Ea]]
--adminroom.AreaData["UserGroupRestricted"] = {"manager", "administrator", "Respected Member"}
--adminroom.AreaData["Parent"] = genloc1

local spawnarea = ents.Create("trigger_lua")
spawnarea:Spawn()
spawnarea:SetCollisionBoundsWS( Vector( 1025.102539, 788.915039, -143.968750 ), Vector( 657.049744, -895.744202, 1294.723633 ) )
spawnarea.AreaData["Name"] = "Spawning Area"
spawnarea.AreaData["Building"] = false
spawnarea.AreaData["Parent"] = genloc1
--spawnarea.AreaData["Ambience"] = [[https://imagescdn.pococraft.org/temp/ambient_spawn.mp3]]
spawnarea.AreaData["StartTouchCallback"] = function( ply )
	if not ply:IsPlayer() then return end
	ply:SetNWString("trigOriginalMaterial", ply:GetMaterial())
	ply:SetMaterial("models/wireframe", true)
	ply:SetColor(arrUsergroupProperties[ply:GetUserGroup()][1] and arrUsergroupProperties[ply:GetUserGroup()][1] or Color(255, 255, 255))
end

spawnarea.AreaData["EndTouchCallback"] = function( ply )
	if not ply:IsPlayer() then return end
	ply:SetMaterial(ply:GetNWString("trigOriginalMaterial", "") == "models/wireframe" and "" or ply:GetNWString("trigOriginalMaterial", ""), true)
	ply:SetColor(Color(255, 255, 255))
end

local easteregg = ents.Create("trigger_lua")
easteregg:Spawn()
easteregg:SetCollisionBoundsWS( Vector( -2896.305176, -1407.968750, -95.713333 ), Vector( -3103.405029, -1037.306519, 31.968754 ) )
easteregg.AreaData["Name"] = "Easter Egg"
easteregg.AreaData["Parent"] = genloc1
easteregg.AreaData["Announce"] = "Shh..."

local overbldg1 = ents.Create("trigger_lua")
overbldg1:Spawn()
overbldg1:SetCollisionBoundsWS( Vector( -3920.130859, 6028.031250, -95.746925 ), Vector( -5008.002930, 4619.968750, 2464.030518 ) )
overbldg1.AreaData["Name"] = "Lake Tower"
overbldg1.AreaData["Parent"] = genloc1

local overbldg2 = ents.Create("trigger_lua")
overbldg2:Spawn()
overbldg2:SetCollisionBoundsWS( Vector( -1599.969482, -2239.968750, 256.275177 ), Vector( -3007.904053, -3327.959473, 2816.031250 ) )
overbldg2.AreaData["Name"] = "Administration Tower"
overbldg2.AreaData["Parent"] = genloc1

local overbldg3 = ents.Create("trigger_lua")
overbldg3:Spawn()
overbldg3:SetCollisionBoundsWS( Vector( 1791.932251, -2143.968750, -143.821930 ), Vector( 898.651123, -1056.031250, 1263.968750 ) )
overbldg3.AreaData["Name"] = "PCC Administration HQ"
overbldg3.AreaData["Parent"] = genloc1
overbldg3.AreaData["UserGroupRestricted"] = {"manager", "administrator"}
overbldg3.AreaData["Building"] = false

local overbldg4 = ents.Create("trigger_lua")
overbldg4:Spawn()
overbldg4:SetCollisionBoundsWS( Vector( 1168.038208, 847.975342, -143.968750 ), Vector( 1791.921509, -879.968750, 31.510780 ) )
overbldg4.AreaData["Name"] = "Fort Garry"
overbldg4.AreaData["Parent"] = genloc1

local overhallway1 = ents.Create("trigger_lua")
overhallway1:Spawn()
overhallway1:SetCollisionBoundsWS( Vector( 2167.958750, -648.031250, -143.968750 ), Vector( 1791.968750, -1287.968750, -8.031258 ) )
overhallway1.AreaData["Name"] = "Dank Hallway"
overhallway1.AreaData["Parent"] = genloc1

local overhallway2 = ents.Create("trigger_lua")
overhallway2:Spawn()
overhallway2:SetCollisionBoundsWS( Vector( -5280.088379, -3431.968750, 383.754211), Vector( -5639.959961, -2320.106689, -143.968750 ) )
overhallway2.AreaData["Name"] = "Spooky Stairway"
overhallway2.AreaData["Ambience"] = [[https://api.soundcloud.com/tracks/33883277/stream?client_id=02gUJC0hH2ct1EGOcYXQIzRFU91c72Ea]]
overhallway2.AreaData["Parent"] = genloc1
--overhallway2.AreaData["StartTouchCallback"] = function( ply )
--	if ply:IsPlayer() then
--		ply:SetHealth(1)
--	end
--	if ply:IsNPC() then
--		ply:Remove()
--	end
--end

-- Underground

local underroom1 = ents.Create("trigger_lua")
underroom1:Spawn()
underroom1:SetCollisionBoundsWS( Vector( -808.031250, -2632.198975, -255.569839 ), Vector( -3295.877686, -4575.962891, 159.968750 ) )
underroom1.AreaData["Name"] = "Chromaroom"
underroom1.AreaData["Parent"] = genloc2

local underroom2 = ents.Create("trigger_lua")
underroom2:Spawn()
underroom2:SetCollisionBoundsWS( Vector( -2927.827637, 95.968750, -511.592377 ), Vector( -1200.236450, -2063.864014, -176.031250 ) )
underroom2.AreaData["Name"] = "Mirror Room"
underroom2.AreaData["Parent"] = genloc2

local underroom3 = ents.Create("trigger_lua")
underroom3:Spawn()
underroom3:SetCollisionBoundsWS( Vector( -5247.968750,-2559.968750, -143.880432 ), Vector( -3248.616699, -1056.031250, 159.906403) )
underroom3.AreaData["Name"] = "Dark Room"
underroom3.AreaData["Building"] = false
--underroom3.AreaData["Ambience"] = [[https://api.soundcloud.com/tracks/33883277/stream?client_id=02gUJC0hH2ct1EGOcYXQIzRFU91c72Ea]]
underroom3.AreaData["Parent"] = genloc2
underroom3.AreaData["Announce"] = true
underroom3.AreaData["StartTouchCallback"] = function( ent )
	if ent:GetClass() == "lua_npc_wander" then
		ent:Remove()
	end
end

--[[
local ee1 = ents.Create("easter_egg1")
ee1:SetPos(Vector(-1415.738403, -943.111877, -508.923676))
ee1:SetAngles(Angle(0, 135, 0))
ee1:Spawn()
]]--
local fallingplatforms = ents.Create("ent_fallingplatform")
fallingplatforms:SetPos(Vector( 1390.749268, -1730.504028, 1296.031250 ))
fallingplatforms:Spawn()

local jumpgame = ents.Create( "ent_jumpgame" )
jumpgame:SetPos( Vector( 1132.885376, -784.165771, 64.031250 ) )
jumpgame:SetAngles( Angle(0, 0, 0) )
jumpgame:Spawn()