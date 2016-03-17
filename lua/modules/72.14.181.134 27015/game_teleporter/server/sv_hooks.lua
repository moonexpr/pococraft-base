util.AddNetworkString( "ServerTeleporterHTTP" )
util.AddNetworkString( "ServerTeleporterSetServer" )
util.AddNetworkString( "ServerTeleporterSoundSync" )

AddCSLuaFile()

if SERVER then
	function StartGeneration()
		GenerateTeleporter()
		if not Escape then
			-- Spawning Props

			for _, Prop in pairs(EntsList) do
				Prop:Spawn()
				Prop:Activate()
				if IsValid(Prop:GetPhysicsObject()) then
					Prop:GetPhysicsObject():EnableMotion( false )
					Prop:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
				end
			end

			ParticleAdd(EntsList['TeleporterBall'])
			PlaySound(EntsList['TeleporterBall'])

			for _, ply in pairs(player.GetAll()) do
				net.Start( "ServerTeleporterSoundSync" )
					net.WriteTable(EntsList)
				net.Send( ply )
			end

			net.Receive("ServerTeleporterSetServer", function( len, ply )
				EntsList['NPC']:ShowPlayer()
				ply:SetPData("TeleporterAddress", net.ReadString())
				timer.Simple(3.5, function()
					ply:SetPos(EntsList['TeleporterBall']:GetPos())
				end)
			end)

			hook.Add( "PostCleanupMap", "RespawnTeleporter", function ()
				game.ConsoleCommand( "say The teleporter will respawn in 30 seconds.\n" )
				timer.Simple( 30, StartGeneration )
			end )

			hook.Add( "PlayerInitialSpawn", "BeginEmittingSounds", function( ply )
				net.Start( "ServerTeleporterSoundSync" )
					net.WriteTable(EntsList)
				net.Send( ply )
			end )

			hook.Add( "PhysgunPickup", "AttemptToMoveTeleporter", function ( ply, ent )
				if ent == EntsList.TeleporterBall then
					return false
				else		
					if table.HasValue( EntsList, ent ) then
						return false
					end
				end
			end )

			hook.Add("CanDrive", "AttemptToMoveTeleporter", function(ply, ent)
				if ent == EntsList.TeleporterBall then
					game.ConsoleCommand(string.format("say %s has attempted to upset the teleporter Gods, S/He shall be sacrificed!\n", ply:Nick()))
					PortalPlayer( ply )
					return false
				else		
					if table.HasValue( EntsList, ent ) then
						return false
					end
				end
			end )
			hook.Add("CanTool", "AttemptToMoveTeleporter", function(ply, tr)
				if tr.Entity == EntsList.TeleporterBall then
					game.ConsoleCommand(string.format("say %s has attempted to upset the teleporter Gods, S/He shall be sacrificed!\n", ply:Nick()))
					PortalPlayer( ply )
					return false
				else		
					if table.HasValue( EntsList, ent ) then
						return false
					end
				end
			end )

		else
			include('server_teleporter.lua') -- Backup!
			ServerLog( "Using backup teleporter !! :(\n")
		end
	end

	hook.Add( "InitPostEntity", "SpawnTeleporter", function ()
		timer.Simple( 10, StartGeneration )
	end )
end