include( "locations.lua" )

TownData = {
	loc_start = {},
	loc_end = {}
}

function CreateTriggerEntity( name, startpos, endpos )
	local origin = Vector(
		(startpos.X + endpos.X) / 2,
		(startpos.Y + endpos.Y) / 2,
		(startpos.Z + endpos.Z) / 2,
	)
	local area = ent.Create( "location_trigger" )
	area:SetName( name )
	area:SetPos( origin )
	area:SetCollisionBounds( startpos, endpos )
	area:SetTrigger( true )
	area:SetCollisionGroup( COLLISION_GROUP_NONE )
	area:SetRenderMode( RENDERMODE_NONE )
	area:Spawn()
	area:Activate()

	ServerLog( "*** Location: Sucessfully created trigger entity for this location!" )
end