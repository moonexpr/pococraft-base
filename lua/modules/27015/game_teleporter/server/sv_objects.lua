function GenerateTeleporter()
	GeneralPosition = MapPositions[game.GetMap()]
	GeneralAngles = MapAngles[game.GetMap()]
		
	if GeneralPosition ~= nil then

		EntsList.CenterFrame = ents.Create("prop_physics")
		EntsList.CenterFrame:SetAngles( GeneralAngles )
		EntsList.CenterFrame:SetPos(GeneralPosition)
		EntsList.CenterFrame:SetModel(Model("models/props_lab/teleportframe.mdl"))
			
		EntsList.CenterBase = ents.Create("prop_physics")
		EntsList.CenterBase:SetAngles( GeneralAngles )
		EntsList.CenterBase:SetPos(GeneralPosition + Vector(0, 31.59375, 28))
		EntsList.CenterBase:SetModel(Model("models/props_lab/teleplatform.mdl"))
			
		EntsList.TeleporterBall = ents.Create("teleporter_core")
		EntsList.TeleporterBall:SetAngles( GeneralAngles )
		EntsList.TeleporterBall:SetPos( GeneralPosition + Vector(0, 31.59375, 78) )
			
		EntsList.CenterBack = ents.Create("prop_physics")
		EntsList.CenterBack:SetPos( GeneralPosition + Vector( 0.125, 30.37, 150.03125 ) )
		EntsList.CenterBack:SetAngles( GeneralAngles + Angle(0, 180, 90) )
		EntsList.CenterBack:SetModel(Model("models/props_c17/fence03a.mdl"))
		EntsList.CenterBack:SetRenderMode( RENDERMODE_NONE )
			
		EntsList.NPC = ents.Create("teleporter_assistance")
		EntsList.NPC:SetAngles( GeneralAngles + Angle(0, 0, 0) )
		EntsList.NPC:SetPos( GeneralPosition + Vector(90, 50, 0) )

		EntsList.Server1 = ents.Create("prop_physics")
		EntsList.Server1:SetAngles( GeneralAngles + Angle(0, 10, 0) )
		EntsList.Server1:SetPos( GeneralPosition + Vector(225, 0, 0) )
		EntsList.Server1:SetModel(Model("models/props_lab/workspace003.mdl"))
			
		EntsList.Server2 = ents.Create("prop_physics")
		EntsList.Server2:SetAngles( GeneralAngles + Angle(0, math.random(0, -10), 0) )
		EntsList.Server2:SetPos( GeneralPosition + Vector(-187.5, 0, 0) )
		EntsList.Server2:SetModel(Model("models/props_lab/servers.mdl"))

	else

		Escape = true

	end
end