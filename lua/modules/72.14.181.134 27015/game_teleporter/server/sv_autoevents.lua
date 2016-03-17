function PlaySound(ent)
	if tobool(math.random(0, 1)) then
		local SelectedSong = table.Random(URLList)
		net.Start("ServerTeleporterHTTP")
			net.WriteString(SelectedSong)
			net.WriteVector(ent:GetPos())
		net.Broadcast()
	else
		ent:EmitSound( "coaster_sonic_the_carthog.mp3" )
	end
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