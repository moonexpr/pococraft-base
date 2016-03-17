ModInfo.Name = "Cheatcodes"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

Cheatcodes = {}

Cheatcodes.List = {
	{
		"Iknowallthehax",
		"Save the Viruses! They're People too!",
		function(ply)
			ply:Kill()
		end,
	},
	{
		"Virus.DOS.Pro-Alife",
		"More coming soon...",
		function(ply)
			ply:GodEnable()
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end,
	}
}

function Cheatcodes.FindCode( code )
	local success = false
	for num, tab in pairs(Cheatcodes.List) do
		if tab[1] == code then
			success = num
		end
	end
	return success
end

function Cheatcodes.Validate( ply, str )
	local cheat = Cheatcodes.FindCode(str)
	if cheat then
		Cheatcodes.List[cheat][3]( ply )
		PrintMessage(HUD_PRINTTALK, ply:Nick() .. " found cheatcode #" .. cheat)	
		ply:PrintMessage(HUD_PRINTTALK, "<c=200,0,100>" .. Cheatcodes.List[cheat][2] .. "</c>")
	else
		PrintMessage(HUD_PRINTTALK, ply:Nick() .. " tried cheatcode: " .. str)
	end
end