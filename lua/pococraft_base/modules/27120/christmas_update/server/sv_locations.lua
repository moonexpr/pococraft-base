for _, location in pairs(LocationsData[game.GetMap()]) do

	-------------------
	-- For Later Use --
	-------------------
	AddSystemLog( "STAT", "Started to format \"" .. location[1] .. "\"!" )
	TownData.loc_start[string.gsub(location[1], " ", "_")] = location[2]
	TownData.loc_end[string.gsub(location[1], " ", "_")] = location[3]
	TownData.loc_ambient[string.gsub(location[1], " ", "_")] = location[4]
	AddSystemLog( "STAT", "Successfully added location to tables!" )

	------------------------------
	-- Added the trigger entity --
	------------------------------

	ents.Create("ent_areatrigger"):SpawnArea( string.gsub(location[1], " ", "_") )
end