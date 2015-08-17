function BetterLogging( text )
	ServerLog( text .. "\n" )
end

function _loadmodule( module )
	ModInfo = {
		Name,
		Author,
	}
	include( "pococraft_base/modules/" .. module .. "/init.lua" )
	
	if ModInfo.Name == nil then ModInfo.Name = "??" end
	if ModInfo.Author == nil then ModInfo.Author = "??" end

	if TestSuccess() then
		BetterLogging( "| + Pococraft Base: Sucessfully loaded module \"" .. module .. "\"!\n" )
		BetterLogging( "| ? Name: " .. ModInfo.Name )
		BetterLogging( "| ? Author: " .. ModInfo.Author )
	else
		BetterLogging( "| + Pococraft Base: Failed to load module \"" .. module .. "\"!" )
	end
end

function _startloading()
	local function ProcessFiles( folders )
		for key, row in pairs( folders ) do
			_loadmodule( row )
		end
	end

	global_files, global_folders = file.Find( "pococraft_base/modules/ALL/*", "LUA" ) )
	port_files, port_folders = file.Find( "pococraft_base/modules/" .. tostring( GetConVar("hostport"):GetInt() ) .. "/*", "LUA" ) )
	ProcessFiles( global_folders )
	ProcessFiles( port_folders )
end