for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end
for _, v in pairs(ents.FindByClass("ent_jumpgame")) do v:Remove() end
for _, v in pairs(ents.FindByClass("gmt_instrument_piano")) do v:Remove() end

local piano = ents.Create( "gmt_instrument_piano" )
piano:SetPos( Vector( 4.554400, 852.585510, -12287.968750 ) )
piano:Spawn()
piano:SetAngles( Angle( 0, -80, 0 ) )
piano:GetPhysicsObject():EnableMotion( false )

local jumpgame = ents.Create( "ent_jumpgame" )
jumpgame:SetPos( Vector( -131.569061, 908.930298, -12287.968750 ) )
jumpgame:SetAngles( Angle(0, 0, 0) )
jumpgame:Spawn()

local genloc1 = ents.Create("trigger_lua")
genloc1:Spawn()
genloc1:SetCollisionBoundsWS( Vector( -15359.968750, -15359.968750, -12799.968750 ), Vector( 15359.968750, 1025.757935, 15359.968750 ) )
genloc1.AreaData["Name"] = "Overworld"

local genloc2 = ents.Create("trigger_lua")
genloc2:Spawn()
genloc2:SetCollisionBoundsWS( Vector( 8191.968750, -8191.968750, -15871.968750 ), Vector( -8191.968750, 8191.968750, -13312.031250 ) )
genloc2.AreaData["Name"] = "Flattywood Skybox"
genloc2.AreaData["Announce"] = true

local overbldg1 = ents.Create("trigger_lua")
overbldg1:Spawn()
overbldg1:SetCollisionBoundsWS( Vector( -416.031250, -447.968750, -12767.968750 ), Vector( -991.968750, 447.968750, -12560.031250 ) )
overbldg1.AreaData["Name"] = "Dollroom"
overbldg1.AreaData["Announce"] = "Ooh, it seems as if you found the secret room where we kidnap people"

local spawn = ents.Create("trigger_lua")
spawn:Spawn()
spawn:SetCollisionBoundsWS( Vector( 1026.225952, -1026.783325, -12287.698242 ), Vector( -1025.982178, 1025.757935, -11991.053711 ) )
spawn.AreaData["Name"] = "Spawning Area"
spawn.AreaData["Building"] = false
spawn.AreaData["Parent"] = genloc1
spawn.AreaData["StartTouchCallback"] = function( ply )
	if ply:IsPlayer() then
		ply:Give("none")
		ply:SelectWeapon("none")
		--ply:RemoveSuit()
	end
end
spawn.AreaData["EndTouchCallback"] = function( ply )
	if ply:IsPlayer() and ply:IsValid() then
		if ply:GetActiveWeapon():GetClass() == "none" then
			ply:SelectWeapon("weapon_crowbar")
		end		
		--ply:EquipSuit()
	end
end