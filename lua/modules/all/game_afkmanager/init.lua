ModInfo.Name = "AFK Manager"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

AddCSLuaFile()

local afk_mark = CreateConVar( "afk_mark", "120", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )

if SERVER then
	local function SetAFK(ply, time)
		if time == (ply.AFK_Time or 0) then return end
		
		ply.AFK_Time = time
		
		local msg
		if time != 0 then
			msg = ply:Name() .. " is now AFK"
		else
			msg = ply:Name() .. " is no longer AFK"
		end
		for _,pl in pairs(player.GetAll()) do
			if pl != ply then
				pl:SendLua("notification.AddLegacy( [[" .. msg .. "]], NOTIFY_GENERIC, 5 )")
				pl:SendLua("surface.PlaySound(\"ambient/water/drip" .. math.random(1, 4)..".wav\")")
			end
		end
	end
	
	local function SetActivity(ply)
		ply.LastActivity = CurTime()
		SetAFK(ply, 0)
	end
	
	hook.Add("PlayerInitialSpawn", "Anti-AFK - Player Join", SetActivity)
	hook.Add("KeyPress", "Anti-AFK - Player Key Press", SetActivity)
	hook.Add("KeyRelease", "Anti-AFK - Player Key Release", SetActivity)
	hook.Add("PlayerSay", "Anti-AFK - Player Chat", SetActivity)
	
	hook.Add("Tick", "Anti-AFK Tick", function()
		local cur_time = CurTime()
		for _,ply in pairs(player.GetAll()) do		
			local angles = ply:GetAngles()
			if ply.LastAngles != angles then
				ply.LastAngles = angles
				SetActivity(ply)
			end
			
			if afk_mark:GetInt() > 0  then 
				if ply.LastActivity + afk_mark:GetInt() <= cur_time then
					SetAFK(ply, ply.LastActivity)
				elseif tobool(ply.AFK_Time) then
					SetAFK(ply, 0)
				end
			end
		end
	end)
end