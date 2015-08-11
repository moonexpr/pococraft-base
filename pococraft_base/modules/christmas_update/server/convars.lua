NaughtyList = {
	"hostname \"Pococraft Christmas 2015\"",
	"mp_flashlight 1",
	"sv_lan 0"
}

function AppendConvar( convar )
	ServerLog( "*** Appended ConVar: \"" .. convar .. "\"!\n")
	game.ConsoleCommand( string.format( "%s\n", convar ) )
end

for key, value in pairs( NaughtyList ) do
	AppendConvar( value	)
end