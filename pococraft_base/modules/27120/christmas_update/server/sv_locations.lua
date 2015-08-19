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

	CreateTriggerEntity( string.format("LOC_%s", location[1] ), location[2], location[3])
end