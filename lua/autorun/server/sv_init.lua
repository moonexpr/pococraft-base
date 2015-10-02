include( "pococraft_base/sv_info.lua" )
include( "pococraft_base/sv_modules.lua" )

Logging.CreateLog()

runtime = os.time()

Logging.AddLog( "Pococraft Base [Version " .. ServerManager.Version .. "] (c) 2015 PocoCraft. All Rights Reserved." )
Logging.AddLog( "Authors: " .. ServerManager.Contributors )

_loadmodule( "pococraft_base/modules/all/*" )
_loadmodule( "pococraft_base/modules/" .. tostring( GetConVar("hostport"):GetInt() ) .. "/*" )

Logging.AddLog( "Pococraft Base Finished (Loaded in " .. os.time() - runtime .. " seconds!)")