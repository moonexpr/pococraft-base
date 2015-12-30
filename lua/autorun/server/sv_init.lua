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
include( "sv_modules.lua" )
include( "sv_security.lua" )

Logging.CreateLog()

runtime = os.time()

Logging.AddLog( "Pococraft Base [Version " .. ServerManager.Version .. "] (c) 2015 PocoCraft. All Rights Reserved." )
Logging.AddLog( "Authors: " .. ServerManager.Contributors )

_loadmodule( "modules/all/*" )
_loadmodule( "modules/" .. tostring( GetConVar("hostport"):GetInt() ) .. "/*" )

Logging.AddLog( "Pococraft Base Finished (Loaded in " .. os.time() - runtime .. " seconds!)")