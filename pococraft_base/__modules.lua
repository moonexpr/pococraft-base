function BetterLogging( text )
	ServerLog( text .. "\n" )
end

function _loadmodule( module, firstrow, lastrow )
	ModInfo = {
		Name,
		Author,
	}
	include( "pococraft_base/modules/" .. module .. "/init.lua" )
	
	if ModInfo.Name == nil then ModInfo.Name = "--blank" end
	if ModInfo.Author == nil then ModInfo.Author = "--blank" end

	if firstrow or lastrow then
		if TestSuccess() then
			BetterLogging( "| + Pococraft Base: Sucessfully loaded module \"" .. module .. "\"!" )
			BetterLogging( "| ? Name: " .. ModInfo.Name )
			BetterLogging( "| ? Author: " .. ModInfo.Author )
			BetterLogging( "" ) -- 1 new line
		else
			BetterLogging( "|   Pococraft Base: Failed to load module \"" .. module .. "\"!" )
		end
	else
		if TestSuccess() then
			BetterLogging( "| + Pococraft Base: Sucessfully loaded module \"" .. module .. "\"!\n" )
			BetterLogging( "| ? Name: " .. ModInfo.Name )
			BetterLogging( "| ? Author: " .. ModInfo.Author )
			BetterLogging( "" ) -- 1 new line
		else
			BetterLogging( "| + Pococraft Base: Failed to load module \"" .. module .. "\"!" )
		end
	end
end

function _startloading()
	local files, dirctories = file.Find( "pococraft_base/modules/*", "LUA" )
	for key, row in pairs( dirctories ) do
		if key == table.GetFirstKey( dirctories ) then
			_loadmodule( row, true, false )
		elseif key == table.GetLastKey( dirctories ) then
			_loadmodule( row, false, true )
		else
			_loadmodule( row, false, false )
		end
	end
end