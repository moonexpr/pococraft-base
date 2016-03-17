--local overbldg1 = ents.Create("trigger_lua")
--overbldg1:Spawn()
--overbldg1:SetCollisionBoundsWS( Vector( -3920.130859, 6028.031250, -95.746925 ), Vector( -5008.002930, 4619.968750, 2464.030518 ) )
--overbldg1.AreaData["Name"] = "Lake Tower"

for _, v in pairs(ents.FindByClass("ent_jumpgame")) do v:Remove() end
for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end

local jumpgame = ents.Create( "ent_jumpgame" )
jumpgame:SetPos( Vector( -1091.037354, -11253.537109, -7.968750 ) )
jumpgame:SetAngles( Angle(0, 0, 0) )
jumpgame:Spawn()

local genloc1 = ents.Create("trigger_lua")
genloc1:Spawn()
genloc1:SetCollisionBoundsWS( Vector( 14847.484375, -14207.942383, -1279.968750 ), Vector( -15358.562500, 12415.968750, 5119.605957 )  )
genloc1.AreaData["Name"] = "Overworld"

local genloc2 = ents.Create("trigger_lua")
genloc2:Spawn()
genloc2:SetCollisionBoundsWS( Vector( 8192.031250, 7168.031250, -9471.968750 ), Vector(12287.968750 , 11263.968750, -8224.031250) )
genloc2.AreaData["Name"] = "Staff Sanctuary"
genloc2.AreaData["UserGroupRestricted"] = {"You may not enter sanctuary at your current state :(", "manager", "administrator", "Respected Member"}local genloc2 = ents.Create("trigger_lua")

local spawnarea = ents.Create("trigger_lua")
spawnarea:Spawn()
spawnarea:SetCollisionBoundsWS( Vector( 1344.031250, 3327.968750, 0 ), Vector( 2048.031250, 2048.031250, 208.031250 ) )
spawnarea.AreaData["Name"] = "Spawning Area"
spawnarea.AreaData["Building"] = false
spawnarea.AreaData["Parent"] = genloc1
spawnarea.AreaData["StartTouchCallback"] = function( ply )
	if not ply:IsPlayer() then return end
	ply:Give("none")
	ply:SelectWeapon("none")
	ply:SetNWString("trigOriginalMaterial", ply:GetMaterial())
	ply:SetMaterial("models/wireframe", true)
	ply:SetColor(arrUsergroupProperties[ply:GetUserGroup()][1] and arrUsergroupProperties[ply:GetUserGroup()][1] or Color(255, 255, 255))
end

spawnarea.AreaData["EndTouchCallback"] = function( ply )
	if not ply:IsPlayer() then return end
	if ply:GetActiveWeapon():GetClass() == "none" then
		ply:SelectWeapon("weapon_physgun")
	end
	ply:SetMaterial(ply:GetNWString("trigOriginalMaterial", "") == "models/wireframe" and "" or ply:GetNWString("trigOriginalMaterial", ""), true)
	ply:SetColor(Color(255, 255, 255))
end