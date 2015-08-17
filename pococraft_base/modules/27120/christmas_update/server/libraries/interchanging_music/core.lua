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
end

for _, location in pairs(rp_christmastown) do

	-------------------
	-- For Later Use --
	-------------------
	ServerLog( "*** Location: Started to format \"" .. location[1] .. "\"!" )
	TownData.loc_start[name] = location[2]
	TownData.loc_end[name] = location[3]
	ServerLog( "*** Location: Sucessfully added location to table!" )

	------------------------------
	-- Added the trigger entity --
	------------------------------

	if CreateTriggerEntity( string.format("LOC_%s", location[1] ), location[2], location[3]) then
		ServerLog( "*** Location: Sucessfully created trigger entity for this location!" )
	else
		ServerLog( "*** Location: Failed to create trigger entity :(" )
	end
end