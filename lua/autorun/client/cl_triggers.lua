TriggerAmbience = {}
net.Receive("TriggerEvent_SafeZone", function(len, ply)
	local url = net.ReadString()
	local stop = net.ReadBool()
	if stop then
		hook.Remove("Tick", "FadeAway:" .. url)
		if TriggerAmbience[url] then -- Be resourseful
			TriggerAmbience[url]:SetVolume(1)
		else
			sound.PlayURL( url, "mono", function(channel)
				TriggerAmbience[url] = channel
				channel:Play()
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