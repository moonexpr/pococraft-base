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
					PortalPlayer( ply )
					return false
				else		
					if table.HasValue( EntsList, ent ) then
						return false
					end
				end
			end )

			hook.Add("CanDrive", "AttemptToMoveTeleporter", function(ply, ent)
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
			include('server_teleporter.lua') -- Backup!
			ServerLog( "Using backup teleporter !! :(\n")
		end
	end

	hook.Add( "InitPostEntity", "SpawnTeleporter", function ()
		timer.Simple( 10, StartGeneration )
	end )
end

if CLIENT then
	sound.Add( {
		name = "server_beep",
		channel = CHAN_STREAM,
		volume = 1.0,
		level = 50,
		pitch = 100,
		sound = "ambient/levels/labs/equipment_beep_loop1.wav"
	} )
	sound.Add( {
		name = "server_print",
		channel = CHAN_STREAM,
		volume = 1.0,
		level = 60,
		pitch = 100,
		sound = "ambient/levels/labs/equipment_printer_loop1.wav"
	} )

	net.Receive("ServerTeleporterHTTP", function()
		local url = net.ReadString()
		local pos = net.ReadVector()
		sound.PlayURL(url, "3d", function(media)
			media:SetPos( pos )
			media:SetVolume( 1 )
			media:Set3DFadeDistance( 500, 1000 )
			media:Play()
		end )
	end)

	net.Receive("ServerTeleporterSoundSync", function()
		local entslist = net.WriteTable()
		entslist['Server1']:EmitSound("server_beep")
		entslist['Server2']:EmitSound("server_print")
	end)
end