include( "locations.lua" )

TownData = {
	loc_start = {},
	loc_end = {},
	loc_ambient = {},
}

util.AddNetworkString( "CHRISTMAS:SetupAmbient" )

function CreateTriggerEntity( name )
	local minpos = TownData.loc_start[name]
	local maxpos = TownData.loc_end[name]
	local ox = ( minpos.X + maxpos.X ) / 2
	local oy = ( minpos.Y + maxpos.Y ) / 2
	local oz = ( minpos.Z + maxpos.Z ) / 2

	local areasong = TownData[loc_ambient[name]]
	local area = ent.Create( "location_trigger" )
	area:SetName( name )
	area:SetPos( Vector( ox, oy, oz ) )
	area:SetCollisionBounds( minpos, maxpos )
	area:SetTrigger( true )
	area:SetCollisionGroup( COLLISION_GROUP_NONE )
	area:SetRenderMode( RENDERMODE_NONE )
	area:Spawn()
	area:Activate()

	
	function area:StartTouch( ply )
		if ply:IsPlayer() and ply:IsValid() and ply:Alive() then
			net.Start( "CHRISTMAS:SetupAmbient" )
				net.WriteBool( true )
				net.WriteString( areasong )
			net.Send( ply )
		end
	end

	function area:EndTouch( ply )
		if ply:IsPlayer() and ply:IsValid() and ply:Alive() then
			net.Start( "CHRISTMAS:SetupAmbient" )
				net.WriteBool( false )
				net.WriteString( areasong )
			net.Send( ply )
		end
	end
	ServerLog( "*** Location: Sucessfully created trigger entity for \"" .. name .. "\"\n" )
end