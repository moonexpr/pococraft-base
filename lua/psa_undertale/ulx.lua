-- This script is copyright of !cake, STEAM_0:1:19269760, http://steamcommunity.com/profiles/76561197998805249
-- Undertale is copyright of Toby Fox
-- Undertale audio samples are copyright of Toby Fox

function PSA.Undertale.RegisterULXCommands ()
	for i = 1, #PSA.Undertale.Commands do
		local commandName = PSA.Undertale.Commands [i].CommandName
		local textStyle   = PSA.Undertale.Commands [i].TextStyle
		
		local command = ulx.command ("Fun", "ulx " .. commandName,
			function (ply, message)
				message = message or ""
				message = string.gsub (message, "\\r", "\r")
				message = string.gsub (message, "\\n", "\n")
				message = string.gsub (message, "\\t", "\t")
				PSA.Undertale.Message (message, textStyle)
				
				print (ply:Nick () .. " " .. commandName .. "'d " .. string.format ("%q", message) .. ".")
			end,
			"!" .. commandName
		)
		command:addParam ({ type = ULib.cmds.StringArg, hint = "message", ULib.cmds.takeRestOfLine })
		command:defaultAccess (ULib.ACCESS_ADMIN)
		command:help ("* (You are filled with determination.)")
	end
end

if ulx then PSA.Undertale.RegisterULXCommands () end
