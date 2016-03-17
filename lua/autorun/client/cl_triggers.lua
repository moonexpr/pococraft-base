TriggerAmbience = {}
net.Receive("TriggerEvent:AmbientToggle", function(len, ply)
	local url = net.ReadString()
	local stop = net.ReadBool()
	if stop then
		hook.Remove("Tick", "FadeAway:" .. url)
		if TriggerAmbience[url] and TriggerAmbience[url]:GetTime() ~= TriggerAmbience[url]:GetLength() then -- Be resourseful
			TriggerAmbience[url]:SetVolume(1)
		else
			sound.PlayURL( url, "noblock", function(channel)
				TriggerAmbience[url] = channel
				channel:EnableLooping( true )
				channel:Play()
				channel:EnableLooping( true )
			end)
		end
	else
	    local runtime = 3
	    local timerset = CurTime() + runtime
	    if not TriggerAmbience[url] then
	    	TriggerAmbience = {}
	    	return
	    end
		hook.Add("Tick", "FadeAway:" .. url, function()
	        local now = timerset - CurTime()
	        local value = math.Round( now, 2 ) / runtime
	        if now < .1 then
				hook.Remove("Tick", "FadeAway:" .. url)
				TriggerAmbience[url]:Stop()
				TriggerAmbience[url] = nil -- Nullify
			else
				TriggerAmbience[url]:SetVolume(value)
			end
		end)
	end
end)