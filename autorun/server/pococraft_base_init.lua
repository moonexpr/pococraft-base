include( "/pococraft_base/__modules.lua" )
include( "/pococraft_base/__info.lua" )

game.ConsoleCommand( "log on\n" ) -- Force start

runtime = os.time()
BetterLogging( "Pococraft Base [Version " .. ServerManager.Version .. "] (c) 2015 PocoCraft. All Rights Reserved." )
BetterLogging( "Authors: " .. ServerManager.Contributors )

club_startloading()
BetterLogging( "Pococraft Base Finished (Loaded in " .. os.time() - runtime .. " seconds!)")