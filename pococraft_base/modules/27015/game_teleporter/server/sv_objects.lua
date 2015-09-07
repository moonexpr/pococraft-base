function GenerateTeleporter()
	
	GeneralPosition = MapPositions[game.GetMap()]
	GeneralAngles = MapAngles[game.GetMap()]
	
	EntsList.CenterFrame = ents.Create("prop_physics")
	EntsList.CenterFrame:SetAngles( GeneralAngles )
	EntsList.CenterFrame:SetPos( GeneralPosition )
	EntsList.CenterFrame:SetModel( Model("models/props_lab/teleportframe.mdl") )
	
	EntsList.CenterBase = ents.Create("prop_physics")
	EntsList.CenterBase:SetAngles( GeneralAngles )
	EntsList.CenterBase:SetPos( GeneralPosition + Vector(0, 31.59375, 28) )
	EntsList.CenterBase:SetModel( Model("models/props_lab/teleplatform.mdl") )
	
	EntsList.TeleporterBall = ents.Create("prop_physics")
	EntsList.TeleporterBall:SetAngles( GeneralAngles )
	EntsList.TeleporterBall:SetPos( GeneralPosition + Vector(0, 31.59375, 78) )
	EntsList.TeleporterBall:SetModel(Model("models/dav0r/hoverball.mdl") )
	
	EntsList.CenterBack = ents.Create("prop_physics")
	EntsList.CenterBack:SetPos( GeneralPosition + Vector( 0.125, 30.37, -150.03125 ) )
	EntsList.CenterBack:SetAngles( GeneralAngles + Angle(0, 180, -90) )
	EntsList.CenterBack:SetModel( Model("models/props_c17/fence03a.mdl") )
	EntsList.CenterBack:SetRenderMode( RENDERMODE_NONE )
	
	EntsList.Server1 = ents.Create("prop_physics")
	EntsList.Server1:SetAngles( GeneralAngles + Angle(0, 10, 0) )
	EntsList.Server1:SetPos( GeneralPosition + Vector(225, 0, 0) )
	EntsList.Server1:SetModel( Model("models/props_lab/workspace003.mdl") )
	
	EntsList.Server2 = ents.Create("prop_physics")
	EntsList.Server2:SetAngles( GeneralAngles + Angle(0, math.random(0, -10), 0) )
	EntsList.Server2:SetPos( GeneralPosition + Vector(math.random(-225, -150), 0, 0) )
	EntsList.Server2:SetModel( Model("models/props_lab/servers.mdl") )
	
	for _, ent in pairs(EntsList) do
		ent:Activate()
		ent:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
		ent:Spawn()
		if IsValid(ent:GetPhysicsObject()) then
			ent:GetPhysicsObject():EnableMotion( false )
			ent:GetPhysicsObject():SetPersistent( true )
		end
	end
	
	PlaySound(EntsList.TeleporterBall)
	ParticleAdd(EntsList.TeleporterBall)
	
	function EntsList.TeleporterBall:Touch( ent )
		if not ent:IsValid() or ent:IsWorld() then return end
		if ent:IsPlayer() then
			if ent:IsBot() then ent:Kick( "Ejected from our world" ) end
			PortalPlayer( ent )
		elseif ent:IsNPC() then
			ent:SetName(tostring(ent:GetCreationID()))
			local dissolve = ents.Create("env_entity_dissolver")
			dissolve:SetPos(ent:GetPos())
			dissolve:SetKeyValue("target", ent:GetName())
			dissolve:SetKeyValue("dissolvetype", "1")
			dissolve:Spawn()
			dissolve:Fire("Dissolve", "", 0)
			dissolve:Fire("kill", "", 1)
		end
	end
end