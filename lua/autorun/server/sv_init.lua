--if GAMEMODE_NAME == "sandbox" then
	include( "sv_info.lua" )
	include( "sv_modules.lua" )

	Logging.CreateLog()

	runtime = os.time()

	Logging.AddLog( "Pococraft Base [Version " .. ServerManager.Version .. "] (c) 2015 PocoCraft. All Rights Reserved." )
	Logging.AddLog( "Authors: " .. ServerManager.Contributors )

	_loadmodule( "modules/all/*" )
	_loadmodule( "modules/" .. tostring( GetConVar("hostport"):GetInt() ) .. "/*" )

	Logging.AddLog( "Pococraft Base Finished (Loaded in " .. os.time() - runtime .. " seconds!)")
--end