function AddSystemLog( type, text )
	L = {
		INFO = { "INFORMATION", false },
		FAILURE = { "FAILURE", true },
		EVENT = { "EVENT", false },
		STAT = { "STATISTICAL", false }
	}
	ServerLog( string.format( "[ CHRISTMAS BACKEND | %s ]:  %s\n", L[type][1], text ) )
	if L[type][2] then
		chat.AddText( string.format( "[ SERVER | %s ]:  %s\n", L[type][1], text ) )
		BroadcastLua( [[ surface.PlaySound( "UI/buttonclickrelease.wav" ) ]] )
	end
end