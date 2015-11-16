sound.Add( {
	name = "server_beep",
	channel = CHAN_STREAM,
	volume = 1.0,
	level = 50,
	pitch = 100,
	sound = "ambient/levels/labs/equipment_beep_loop1.wav"
} )
sound.Add( {
	name = "server_print",
	channel = CHAN_STREAM,
	volume = 1.0,
	level = 60,
	pitch = 100,
	sound = "ambient/levels/labs/equipment_printer_loop1.wav"
} )

net.Receive("ServerTeleporterHTTP", function()
	local url =  net.ReadString()
	local ent = net.ReadEntity()
	sound.PlayURL(url, "3d", function(media)
		media:SetPos( ent:GetPos() )
		media:SetVolume( 1 )
		media:Set3DFadeDistance( 500, 1000 )
		media:Play()
	end )
end)

net.Receive("ServerTeleporterSoundSync", function()
	local entslist = net.WriteTable()
	entslist['Server1']:EmitSound("server_beep")
	entslist['Server2']:EmitSound("server_print")
end)