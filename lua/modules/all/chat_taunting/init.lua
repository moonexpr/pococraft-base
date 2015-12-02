ModInfo.Name = "Chat Commands (Taunting)"
ModInfo.Author = "Potatofactory"

TauntsList = {
	cheer = "vo/coast/odessa/male01/nlo_cheer01.wav",
	laugh = "vo/ravenholm/madlaugh03.wav",
	muscle = true,
	zombie = "npc/fast_zombie/fz_frenzy1.wav",
	robot = true,
	dance = true,
	agree = "vo/npc/male01/yeah02.wav",
	becon = "vo/Citadel/al_comegordon.wav",
	disagree = "vo/Citadel/br_no.wav",
	salute = true,
	wave = "vo/npc/male01/hellodrfm0" .. math.random(1, 2) .. ".wav",
	forward = true,
	group = true,
	halt = true,
}


function ChatFilter( ply, text, team )

	local function SendMessage( sender, ext )
		for _, ply in pairs( ents.FindInSphere(sender:GetPos(), 750) ) do
			if ply:IsPlayer() and ply:Alive() then
				ply:SendLua( string.format( "chat.AddText( Color( 150, 0, 250 ), \"%s\", Color( 255, 255, 255 ), \" %ss\" )", sender:Nick(), ext ) )
			end
		end
	end

	local function DoTaunt( taunt )
		local female = tobool(math.random(0, 1))
		if TauntsList[taunt] != nil then
			if taunt == "muscle" then
				SendMessage( ply, "sexy" )
			else
				SendMessage( ply, taunt )
			end
			ply:SendLua( string.format( "LocalPlayer():ConCommand( \"act %s\" )", taunt ) )
			if isstring(TauntsList[taunt]) then
				if female then
					ply:EmitSound( string.gsub(TauntsList[taunt], "male", "female"), 100, math.random(90, 110), 1, CHAN_AUTO )
				else
					ply:EmitSound( TauntsList[taunt], 100, math.random(90, 110), 1, CHAN_AUTO )
				end
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