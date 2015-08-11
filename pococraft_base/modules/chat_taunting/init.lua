ModInfo.Name = "Chat Commands (Taunting)"
ModInfo.Author = "Potatofactory"

TauntsList = {
	cheer = true,
	laugh = "vo/ravenholm/madlaugh03.wav",
	muscle = true,
	zombie = true,
	robot = true,
	dance = true,
	agree = true,
	becon = true,
	disagree = true,
	salute = true,
	wave = true,
	forward = true,
	per = true,
}


function ChatFilter( ply, text, team )

	local function SendMessage( sender, ext )
		for _, ply in pairs( ents.FindInSphere(sender:GetPos(), 750) ) do
			if ply:IsPlayer() and ply:Alive() then
				ply:SendLua( string.format( "chat.AddText( Color( 200, 0, 100 ), \"%s\", Color( 255, 255, 255 ), \" %ss\" )", sender:Nick(), ext ) )
			end
		end
	end

	local function DoTaunt( taunt )
		if TauntsList[taunt] != nil then
			if taunt == "muscle" then
				SendMessage( ply, "sexy" )
			else
				SendMessage( ply, taunt )
			end
			ply:SendLua( string.format( "LocalPlayer():ConCommand( \"act %s\" )", taunt ) )
			if isstring(TauntsList[taunt]) then
				ply:EmitSound( TauntsList[taunt], 100, math.random(90, 110), 1, CHAN_AUTO )
			end
			return false
		else
			return taunt
		end
	end

	return DoTaunt( text )
end

hook.Add( "PlayerSay", "", ChatFilter )


function TestSuccess()
	return true
end