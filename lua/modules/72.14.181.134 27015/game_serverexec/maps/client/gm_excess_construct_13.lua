CreateClientConVar( "cl_sanctuary_spawn", "1", true )

hook.Add( "PopulateToolMenu", "PopulatePococraftProperties", function()
	spawnmenu.AddToolMenuOption( "Options", "Player", "PococraftPreferences", "Preferences", "", "", function(CPanel)
		CPanel:AddControl( "CheckBox", { Label = "Spawn in Sanctuary (Restricted)", Command = "cl_sanctuary_spawn" } )
	end )
end )