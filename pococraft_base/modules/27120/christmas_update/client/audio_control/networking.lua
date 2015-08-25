-- need a table with a persistent scope, doesn't need to be global
-- just don't make it local unless you will never modify the containing file while the server is running
channels = channels or {}

net.Receive( "SetupAmbient", function( length )
	local START = net.ReadBool()
    local URL = net.ReadString() -- make sure you localize your variables unless you are using them elsewhere in your code
    
    if START then
        sound.PlayURL( URL, "mono", function( audio_obj )
            if not IsValid( audio_obj ) then return end -- bad URL, audio format, etc
            
            -- if you try to play the sound again, but it's already playing, stop it
            if IsValid( channels[URL] ) ) then 
                channels[URL]:Stop()
            end
            
            channels[URL]:Play()

            -- store the channel so we can access it later
            channels[URL] = audio_obj
        end )
    else
    	timer = 2
        future = CurTime() + timer
        hook.Add( "Tick", "DropVolume", function()
        	local now = CurTime() / future
        	if now <= 0 then
        		hook.Remove( "Tick", "DropVolume" )
        		channels[URL]:Stop()
        	else
        		channels[URL]:SetVolume( 1 * (now / timer) )
        	end
        end )
    end
end )