include( "locations.lua" )

TownData = {
	loc_start = {},
	loc_end = {}
}

function CreateTriggerEntity( name )
	local minpos = TownData.loc_start[name]
	local maxpos = TownData.loc_end[name]
	local ox = ( minpos.X + maxpos.X ) / 2
	local oy = ( minpos.Y + maxpos.Y ) / 2
	local oz = ( minpos.Z + maxpos.Z ) / 2

	local area = ent.Create( "location_trigger" )
	area:SetName( name )
	area:SetPos( Vector( ox, oy, oz ) )
	area:SetCollisionBounds( minpos, maxpos )
	area:SetTrigger( true )
	area:SetCollisionGroup( COLLISION_GROUP_NONE )
	area:SetRenderMode( RENDERMODE_NONE )
	area:Spawn()
	area:Activate()

	ServerLog( "*** Location: Sucessfully created trigger entity for \"" .. name .. "\"\n" )
end