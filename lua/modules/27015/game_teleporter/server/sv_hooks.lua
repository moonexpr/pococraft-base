function StartGeneration()
	
	include 'modules/27015/game_teleporter/server/sv_objects.lua'

	if not Escape then

		include 'modules/27015/game_teleporter/server/sv_autoevents.lua'

		for _, ent in pairs(EntsList) do
			ent:Activate()
			ent:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
			ent:Spawn()
			if IsValid(ent:GetPhysicsObject()) then
				ent:GetPhysicsObject():EnableMotion( false )
			end
		end
		PlaySound(EntsList.TeleporterBall)
		ParticleAdd(EntsList.TeleporterBall)
			
		hook.Add( "PostCleanupMap", "RespawnTeleporter", function ()
			hook.Remove( "Tick", "CheckPlayerInRange" ) -- So no spam no moar
			game.ConsoleCommand( "say The teleporter will respawn in 30 seconds.\n" )
			timer.Simple( 10, StartGeneration )
		end )

		hook.Add( "PlayerInitialSpawn", "BeginEmittingSounds", function( ply )
			ply:SendLua( string.format( "ents.GetByIndex(%d):EmitSound( \"ambient/levels/labs/equipment_printer_loop1.wav\", 75, 80, 1, CHAN_STATIC )", EntsList.Server1:EntIndex() ) )
			ply:SendLua( string.format( "ents.GetByIndex(%d):EmitSound( \"ambient/levels/labs/equipment_beep_loop1.wav\", 50, 100, 1, CHAN_STATIC )", EntsList.Server2:EntIndex() ) )
		end )

		hook.Add( "PhysgunPickup", "AttemptToMoveTeleporter", function ( ply, ent )
			if ent == EntsList.TeleporterBall then
				PortalPlayer( ply )
				return false
			else		
				if table.HasValue( EntsList, ent ) then
					return false
				end
			end
		end )

	else

		include 'modules/27015/game_teleporter/server_teleporter.lua' -- Backup!
		ServerLog( "Using backup teleporter !! :(\n")

	end
end

hook.Add( "InitPostEntity", "SpawnTeleporter", function ()
	timer.Simple( 10, StartGeneration )
end )