Logging = {
	File = nil
}

function Logging.CreateLog()
	Logging.File = string.format( "%s/%s.txt", ServerManager.LoggingDirectory, #file.Find( ServerManager.LoggingDirectory, "DATA" ) + 1)
	file.Write( Logging.File, "*** Logging Started on " .. os.date("%m/%d/%y @ " .. game.GetMap()) .. " ***\n" )
end

function Logging.AddLog( message, closing )
	
	if Logging.File == nil then
		Logging.CreateLog()
		Logging.AddLog( message, closing )
		return
	end

	if closing != nil and closing then
		file.Append( Logging.File, 
			string.format( "%s*** Logging Terminated! Reason: %s ***", file.Read( Logging.File, "DATA" ), message )
		)
		Logging.CreateLog() -- Close the current logging method and start a new file
	else
		file.Append( Logging.File, 
			string.format( "%s[%s] $ %s\n", file.Read( Logging.File, "DATA" ), os.date("%H:%M | %m/%d/%y @ " .. game.GetMap()), message )
		)
	end
end

--hook.Add( "ShutDown", "EndLogging", Logging.AddLog( "Changing Maps", true ) ) -- Fires when changing maps

function _include( ModInfo, location )
	local path = string.gsub(ModInfo.location, "/init.lua", "")
	include(string.format("%s/%s", path, location))
end

function _loadmodule( location )
	files, directories = file.Find( location, "LUA" )
	for _, module in pairs( directories ) do
		ModInfo = {
			Name = string.format("%s (No ModInfo Table)", module),
			Author = "Unknown (No ModInfo Table)",
			location = string.gsub(location, "*", module)
		}

		include( string.format( "%s%s/init.lua", string.gsub(location, "*", ""), module ) )

		if TestSuccess() then
			print( "| + Pococraft Base: Sucessfully loaded module \"" .. module .. "\"!" )
			print( "| ? Name: " .. ModInfo.Name )
			print( "| ? Author: " .. ModInfo.Author )
		else
			print( "| + Pococraft Base: Failed to load module \"" .. module .. "\"!" )
		end

		PococraftModules = {
			[#PococraftModules + 1] = {
				Name = ModInfo.Name and ModInfo.Name or string.format("%s (No ModInfo Table)", module),
				Author = ModInfo.Author and  ModInfo.Author or "Unknown (No ModInfo Table)",
				location = ModInfo.location
			}
		}
	end
end