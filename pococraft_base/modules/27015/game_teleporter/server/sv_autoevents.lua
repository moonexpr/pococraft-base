function PlaySound( ent )
	local function PickSong()
		if tobool(math.random( 0, 1 )) then
			ent:EmitSound( "coaster_sonic_the_carthog.mp3" )
		else
			for _, ply in pairs(player.GetAll()) do 
				ply:SendLua([[
					sound.PlayURL( "]] .. table.Random( URLList ) .. [[", "3d", function (media)
						media:SetPos(]], ent:GetPos(), [[) )
						media:SetVolume( 1 )
						media:Set3DFadeDistance( 800, 8000 )
						media:Play()
					end )
				]])
			end
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
	
	timer.Simple( 5, function()
		ply:EmitSound( "ambient/energy/whiteflash.wav", 150, 100, 1, CHAN_AUTO )
		ply:SendLua([[LocalPlayer():ConCommand("connect 72.14.181.134:27120")]])
	end)
end