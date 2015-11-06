net.Receive( "PP:PlayerSpawnEffect", function()
	LocalPlayer():ConCommand( "pp_colormod 1")
	local runtime = 2
	local timerset = CurTime() + runtime
	hook.Add( "Tick", "ReturnColor", function ()
		local now = timerset - CurTime()
		if net.ReadBool() then
			if now <= 0 then hook.Remove( "Tick", "ReturnColor" ) LocalPlayer():ConCommand( "pp_colormod_contrast 12" ) end
			LocalPlayer():ConCommand( "pp_colormod_contrast " .. 12 - (math.Round( now, 2 ) / runtime * 12) )
		else
			if now <= 0 then hook.Remove( "Tick", "ReturnColor" ) LocalPlayer():ConCommand( "pp_colormod_contrast 1" ) end
			LocalPlayer():ConCommand( "pp_colormod_contrast " .. 1 + (math.Round( now, 2 ) / runtime * 11) )
		end
	end )
end)