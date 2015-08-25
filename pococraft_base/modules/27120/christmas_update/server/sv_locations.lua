for _, location in pairs(LocationsData[game.GetMap()]) do

	-------------------
	-- For Later Use --
	-------------------
	AddSystemLog( "STAT", "Started to format \"" .. location[1] .. "\"!" )
	TownData.loc_start[location[1]] = location[2]
	TownData.loc_end[location[1]] = location[3]
	TownData.loc_ambient[location[1]] = location[4]
	AddSystemLog( "STAT", "Successfully added location to tables!" )

	------------------------------
	-- Added the trigger entity --
	------------------------------

	CreateTriggerEntity( string.format("LOC_%s", string.gsub(location[1], " ", "_") ) )
end