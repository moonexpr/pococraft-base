function BetterLogging( text )
	ServerLog( text .. "\n" )
end

function _loadmodule( location )
	files, directories = file.Find( location, "LUA" )
	for _, module in pairs( directories ) do
		ModInfo = {
			Name,
			Author,
		}
		include( string.format( "%s%s/init.lua", string.gsub(location, "*", ""), module ) )
		
		if ModInfo.Name == nil then ModInfo.Name = string.format("%s (No ModInfo Table)", module) end
		if ModInfo.Author == nil then ModInfo.Author = "Unknown (No ModInfo Table)" end

		if TestSuccess() then
			BetterLogging( "| + Pococraft Base: Sucessfully loaded module \"" .. module .. "\"!" )
			BetterLogging( "| ? Name: " .. ModInfo.Name )
			BetterLogging( "| ? Author: " .. ModInfo.Author )
		else
			BetterLogging( "| + Pococraft Base: Failed to load module \"" .. module .. "\"!" )
		end
	end
end

function _startloading()
	_loadmodule( "pococraft_base/modules/all/*" )
	_loadmodule( "pococraft_base/modules/" .. tostring( GetConVar("hostport"):GetInt() ) .. "/*" )
end