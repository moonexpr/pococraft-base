-- This script is copyright of !cake, STEAM_0:1:19269760, http://steamcommunity.com/profiles/76561197998805249
-- Undertale is copyright of Toby Fox
-- Undertale audio samples are copyright of Toby Fox

function PSA.Undertale.RegisterAowlCommands ()
	for i = 1, #PSA.Undertale.Commands do
		local commandName = PSA.Undertale.Commands [i].CommandName
		local textStyle   = PSA.Undertale.Commands [i].TextStyle
		
		aowl.AddCommand (commandName,
			function (ply, command)
				command = command or ""
				command = string.gsub (command, "\\r", "\r")
				command = string.gsub (command, "\\n", "\n")
				command = string.gsub (command, "\\t", "\t")
				PSA.Undertale.Message (command, textStyle)
				
				print (ply:Nick () .. " " .. commandName .. "'d " .. string.format ("%q", command) .. ".")
			end,
			"developers"
		)
	end
end

if aowl then PSA.Undertale.RegisterAowlCommands () end
hook.Add ("AowlInitialized", "PSA.Undertale", PSA.Undertale.RegisterAowlCommands)
