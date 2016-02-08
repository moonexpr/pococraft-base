-- This script is copyright of !cake, STEAM_0:1:19269760, http://steamcommunity.com/profiles/76561197998805249
-- Undertale is copyright of Toby Fox
-- Undertale audio samples are copyright of Toby Fox

AddCSLuaFile ("psa_undertale.lua")
AddCSLuaFile ("psa_undertale_cl.lua")
AddCSLuaFile ("resources_00.lua")
AddCSLuaFile ("resources_01.lua")
AddCSLuaFile ("resources_02.lua")
AddCSLuaFile ("ulx.lua")

include ("aowl.lua")

util.AddNetworkString ("PSA.Undertale")

function PSA.Undertale.Message (text, textStyle)
	textStyle = textStyle or ""
	
	net.Start ("PSA.Undertale")
		net.WriteUInt (#textStyle, 8)
		net.WriteData (textStyle, #textStyle)
		net.WriteUInt (#text, 16)
		net.WriteData (text, #text)
	net.Broadcast ()
end
