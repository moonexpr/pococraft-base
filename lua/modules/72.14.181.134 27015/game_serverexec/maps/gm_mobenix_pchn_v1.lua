for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end
for _, v in pairs(ents.FindByClass("ent_jumpgame")) do v:Remove() end
--for _, v in pairs(ents.FindByClass("gmt_instrument_piano")) do v:Remove() end


local spawn = ents.Create("trigger_lua")
spawn:Spawn()
spawn:SetCollisionBoundsWS( Vector( -8908.031250, -1071.031250, 10373.031250 ), Vector( -9899.968750, -2779.968750, 10756.968750 ) )
spawn.AreaData["Name"] = "Mobenix Central"
spawn.AreaData["Building"] = false
spawn.AreaData["StartTouchCallback"] = function( ply )
	if not ply:IsPlayer() then return end
	ply:Give("none")
	ply:SelectWeapon("none")
end
spawn.AreaData["EndTouchCallback"] = function( ply )
	if not ply:IsPlayer() or not ply:Alive() or not ply:IsValid() then return end
	if ply:GetActiveWeapon():GetClass() == "none" then
		ply:SelectWeapon("weapon_physgun")
	end
end