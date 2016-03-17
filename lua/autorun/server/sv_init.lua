--[[
	  ______
	/   __  |                                                                          
	|  |  \_|                                                                          
	 \ \       ____       ___      _      __       __    _____     __         ________ 
	  \ \     / _  \    /  __|    | |    |  |     |  |  /  _  \   |  |____   /   ___  \
	   \ \   | | | |  __| |__   __| |__  |  |  _  |  |  | | | ||  |   __  \  |  |___| |
	 _  \ \  | | | | |__   __| |__   __| \  \_/ \_|  /  | | | ||  |  /  \__| |   _____|
	| \__| | | |_| |    | |       | |     \    _    /   | |_| ||  |  |       |  |_____ 
	|______/  \____/    |_|       |_|      \__/ \__/    \_____/\  |__|       \________|
		(c) 2015-2016 PocoCraft Gaming Network. All rights reserved.
]]--

include( "sv_info.lua" )
include( "sv_security.lua" )
include( "sv_modules.lua" )

--Logging.CreateLog()

runtime = os.time()
PococraftModules = {}

print( "Pococraft Base [Version " .. ServerManager.Version .. "] (c) 2015 PocoCraft. All Rights Reserved." )
print( "Authors: " .. ServerManager.Contributors )

_loadmodule( "modules/all/*" )
_loadmodule( "modules/" .. tostring( string.gsub(game.GetIPAddress(), ":", " ") ) .. "/*" )

print( "Pococraft Base Finished (Loaded in " .. os.time() - runtime .. " seconds!)")

function ReloadBaseModules()
	BroadcastLua([[
		notification.AddProgress( "PococraftLoad", "Reloading the Pococraft Base modules and plugins..." )
	]])

	PococraftModules = {}

	include( "sv_info.lua" )
	include( "sv_security.lua" )
	include( "sv_modules.lua" )

	_loadmodule( "modules/all/*" )
	_loadmodule( "modules/" .. tostring( string.gsub(game.GetIPAddress(), ":", " ") ) .. "/*" )

	timer.Simple(1, function()
	BroadcastLua([[
		notification.Kill( "PococraftLoad" )
	]])
	end)
end