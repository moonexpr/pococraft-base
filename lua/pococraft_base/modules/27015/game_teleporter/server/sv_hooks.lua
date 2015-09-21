hook.Add( "InitPostEntity", "SpawnTeleporter", function ()
	timer.Simple( 30, GenerateTeleporter )
end )
	
hook.Add( "PostCleanupMap", "RespawnTeleporter", function ()
	hook.Remove( "Tick", "CheckPlayerInRange" ) -- So no spam no moar
	game.ConsoleCommand( "say The teleporter will respawn in 30 seconds.\n" )
	timer.Simple( 30, GenerateTeleporter )
end )

hook.Add( "PlayerInitialSpawn", "BeginEmittingSounds", function( ply )
	ply:SendLua( string.format( "ents.GetByIndex(%d):EmitSound( \"ambient/levels/labs/equipment_printer_loop1.wav\", 75, 80, 1, CHAN_STATIC )", EntsList.Server1:GetEntIndex() ) )
	ply:SendLua( string.format( "ents.GetByIndex(%d):EmitSound( \"ambient/levels/labs/equipment_beep_loop1.wav\", 50, 100, 1, CHAN_STATIC )", EntsList.Server2:GetEntIndex() ) )
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