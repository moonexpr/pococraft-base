function AnnounceSanta()
	-- Will design later
end

include( "entities/area_trigger.lua" ) -- Just this for now

--[[
Files, Directories = file.Find( "entities/*.lua" )

for _, ent in pairs(Files) do
	include( ent )
end
]]--