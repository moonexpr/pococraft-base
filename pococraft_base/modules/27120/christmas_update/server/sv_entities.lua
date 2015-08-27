Files, Directories = file.Find( "entities/*.lua" )

for _, ent in pairs(Files) do
	include( ent )
end