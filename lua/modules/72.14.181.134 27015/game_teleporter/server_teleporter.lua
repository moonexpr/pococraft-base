include 'modules/27015/game_teleporter/server/sv_config.lua'

AddCSLuaFile("modules/27015/game_teleporter/cl_networking.lua")

EntsList = {}

function PlaySound( ent )
	local function PickSong()
		if tobool(math.random( 0, 1 )) then
			net.Start("ServerTeleporterHTTP")
				net.WriteString(table.Random(URLList))
				net.WriteEntity(ent)
			net.Broadcast()
		else
			ent:EmitSound( "coaster_sonic_the_carthog.mp3" )
		end
	end
	PickSong()
	timer.Create( "Teleporer_Emitsound", 2 * 60, 0, function ()
		PickSong()
		timer.Start("Teleporer_Emitsound")
	end )
end

function ParticleAdd( ent )
	timer.Create( "Teleporter_Tesla", .25, 0, function ()
		local fx = EffectData()
		fx:SetEntity( ent )
		fx:SetOrigin( ent:GetPos() )
		fx:SetStart( ent:GetPos() )
		fx:SetScale( math.random(2, 5) )
		fx:SetMagnitude( 15 )
		
		util.Effect( "TeslaHitBoxes", fx )
		timer.Start( "Teleporter_Tesla" )
	end )
end

function PortalPlayer( ply )
	ply:Freeze( true ) -- Prevent them from moving while teleporting away
	ply:GetPhysicsObject():EnableMotion( false ) -- Just for safety
    ply:SetPos( ply:GetPos() + Vector( 0, 130, 0 ) ) -- Force them back to avoid firing the function again
	ply:SetEyeAngles( Angle( -15, -90, 0) )
	
	--[[
		Let's hide them from the world
	]]--
	
	ply:StripWeapons()
	ply:SetRenderMode( RENDERMODE_NONE ) -- Make them invisible
	ply:SetCollisionGroup( COLLISION_GROUP_NONE )
	
	ply:ScreenFade( SCREENFADE.OUT, color_black, 5, 6 )
	
	timer.Simple(5, function()
		local cl_lua = string.format("LocalPlayer():ConCommand(\"connect %s\")", ply:GetPData("TeleporterAddress", "72.14.181.134:27120"))
		ply:EmitSound( "ambient/energy/whiteflash.wav", 150, 100, 1, CHAN_AUTO )
		ply:SendLua(cl_lua)
	end)
end

function GenerateTeleporter()
	GeneralPosition = MapPositions[game.GetMap()]
	GeneralAngles = MapAngles[game.GetMap()]
		
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
	EntsList.CenterBack:SetPos( GeneralPosition + Vector( 0.125, 30.37, -150.03125 ) )
	EntsList.CenterBack:SetAngles( GeneralAngles + Angle(0, 180, 90) )
	EntsList.CenterBack:SetModel(Model("models/props_c17/fence03a.mdl"))
	EntsList.CenterBack:SetRenderMode( RENDERMODE_NONE )
		
	EntsList.NPC = ents.Create("teleporter_assistance")
	EntsList.NPC:SetAngles( GeneralAngles + Angle(0, 0, 0) )
	EntsList.NPC:SetPos( GeneralPosition + Vector(225, -20, 0) )

	EntsList.Server1 = ents.Create("prop_physics")
	EntsList.Server1:SetAngles( GeneralAngles + Angle(0, 10, 0) )
	EntsList.Server1:SetPos( GeneralPosition + Vector(225, 0, 0) )
	EntsList.Server1:SetModel(Model("models/props_lab/workspace003.mdl"))
		
	EntsList.Server2 = ents.Create("prop_physics")
	EntsList.Server2:SetAngles( GeneralAngles + Angle(0, math.random(0, -10), 0) )
	EntsList.Server2:SetPos( GeneralPosition + Vector(-187.5, 0, 0) )
	EntsList.Server2:SetModel(Model("models/props_lab/servers.mdl"))

	for _, Prop in pairs(EntsList) do
		Prop:Spawn()
		Prop:Activate()
		Prop:GetPhysicsObject():EnableMotion( false )
		Prop:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	end

	PlaySound(EntsList['TeleporterBall'])
	ParticleAdd(EntsList['TeleporterBall'])

	for _, ply in pairs(player.GetAll()) do
		net.Start( "ServerTeleporterSoundSync" )
			net.WriteTable(EntsList)
		net.Send( ply )
	end

	net.Receive("ServerTeleporterSetServer", function( len, ply )
		EntsList['NPC']:EmitSound("combined/k_lab/k_lab_kl_excellent_cc.wav")
		ply:SetPData("TeleporterAddress", net.ReadString())
		timer.Simple(3, function()
			PortalPlayer(ply)
		end)
	end)

	hook.Add( "PostCleanupMap", "RespawnTeleporter", function ()
		hook.Remove( "Tick", "CheckPlayerInRange" ) -- So no spam no moar
		game.ConsoleCommand( "say The teleporter will respawn in 30 seconds.\n" )
		timer.Simple( 30, GenerateTeleporter )
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
end 