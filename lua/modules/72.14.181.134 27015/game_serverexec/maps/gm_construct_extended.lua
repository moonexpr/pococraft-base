for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end

-- SPECIAL AREAS

local theater = ents.Create("trigger_lua")
theater:Spawn()
theater:SetCollisionBoundsWS( Vector( 4512.780273, -731.968750, -1824.031250 ), Vector( 5565.356445, 39.968754, -2079.036133 ) )
theater.AreaData["Name"] = "Theater"
theater.AreaData["Building"] = false
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

-- Generic: Upper Level

local genloc1 = ents.Create("trigger_lua")
genloc1:Spawn()
genloc1:SetCollisionBoundsWS( Vector( -7295.968750, 7391.968750, -2754.335693 ), Vector( 6463.968750, -7455.968750, 3711.968994 ) )
genloc1.AreaData["Name"] = "Overworld"

local genloc2 = ents.Create("trigger_lua")
genloc2:Spawn()
genloc2:SetCollisionBoundsWS( Vector( -303.968750, -3584.031250, -2431.968750 ), Vector( 4367.968750, -5847.968750, -2112.031250 ) )
genloc2.AreaData["Name"] = "Underground"
genloc2.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}

local genloc3 = ents.Create("trigger_lua")
genloc3:Spawn()
genloc3:SetCollisionBoundsWS( Vector( 6463.968750, 3552.581055, -2415.968750 ), Vector( -7295.968750, 7391.968750, 3245.382080 ) )
genloc3.AreaData["Name"] = "OctoLand"
genloc3.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}


local upperroom1 = ents.Create("trigger_lua")
upperroom1:Spawn()
upperroom1:SetCollisionBoundsWS( Vector( 3330.200684, -4689.508301, -623.968750 ), Vector( 4415.581055, -5823.613281, -2063.968750 ) )
upperroom1.AreaData["Name"] = "Garry's Tower"

-- Generic: Lower Level

local lowerroom1 = ents.Create("trigger_lua")
lowerroom1:Spawn()
lowerroom1:SetCollisionBoundsWS( Vector( 3280.216797, -5847.968750, -2328.792480 ), Vector( 4367.968750, -2664.647217, -2112.341797 ) )
lowerroom1.AreaData["Name"] = "Garry's Tower Basement"
lowerroom1.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}
lowerroom1.AreaData["Parent"] = genloc2

local lowerhall1 = ents.Create("trigger_lua")
lowerhall1:Spawn()
lowerhall1:SetCollisionBoundsWS( Vector( 4423.683105, -5207.461426, -1928.031250 ), Vector( 4908.353027, -2729.805420, -2335.968750 ) )
lowerhall1.AreaData["Name"] = "Garry's Tower Hallway"
lowerhall1.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}
lowerhall1.AreaData["Parent"] = genloc2

local lowerhall2 = ents.Create("trigger_lua")
lowerhall2:Spawn()
lowerhall2:SetCollisionBoundsWS( Vector( 1480.031250, -4255.939453, -2430.851807 ), Vector( 3223.917236, -3744.352295, -2112.028564 ) )
lowerhall2.AreaData["Name"] = "Underground Hallway"
lowerhall2.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}
lowerhall2.AreaData["Parent"] = genloc2

local lowerroom2 = ents.Create("trigger_lua")
lowerroom2:Spawn()
lowerroom2:SetCollisionBoundsWS( Vector( 1424.031250, -3576.971191, -2387.053467 ), Vector( -303.968750, -5743.825684, -2096.191895 ) )
lowerroom2.AreaData["Name"] = "Mirror Room"
lowerroom2.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}
lowerroom2.AreaData["Parent"] = genloc2

local lowerroom3 = ents.Create("trigger_lua")
lowerroom3:Spawn()
lowerroom3:SetCollisionBoundsWS( Vector( 1815.770264, -8247.968750, -1768.153442 ), Vector( -663.751282, -6312.031250, -2175.466553 ) )
lowerroom3.AreaData["Name"] = "Chromaroom"
lowerroom3.AreaData["UserGroupRestricted"] = {"We're working on this part of the map! We'll unlock it as soon as it's done baking! - The Devs (Potatofactory)", "manager"}
lowerroom3.AreaData["Parent"] = genloc2

--local ee1 = ents.Create("easter_egg1")
--ee1:SetPos(Vector(1215.746826, -4630.137695, -2430))
--ee1:SetAngles(Angle(0, 135, 0))
--ee1:Spawn()

hook.Add("PlayerSwitchWeapon", "Donotspawnintheaterplz", function( ply, _, wep )
	if ply:GetLocation() == "Theater" and not wep:GetClass() == "none" then
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
