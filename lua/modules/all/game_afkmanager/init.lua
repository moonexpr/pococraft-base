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
			if ply:HasGodMode() then
				ply:SetNWBool("a_AlreadyHasGod", true)
			else
				ply:SetNWBool("a_AlreadyHasGod", false)
			end
			ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
			--ply:SetRenderFX(kRenderFxFadeSlow)

			if IsValid(ply:GetActiveWeapon()) then
				ply:GetActiveWeapon():SetColor( Color(255, 255, 255, 0) )
			end

			ply:GodEnable()
		else

			for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 1)) do
				if ent:IsPlayer() and ent ~= ply then
					ent:Spawn() -- Player trapped, respawn
				end
			end

			if not ply:GetNWBool("a_AlreadyHasGod", false) then
				ply:GodDisable()
			end
			ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			--ply:SetRenderFX(kRenderFxSolidFast)

			if IsValid(ply:GetActiveWeapon()) == nil then
				ply:GetActiveWeapon():SetColor( Color(255, 255, 255, 255) )
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
	
	hook.Add("Tick", "Anti-AFK Tick", function()
		local cur_time = CurTime()
		for _,ply in pairs(player.GetAll()) do
			--if ply:IsTimingOut() then
			--	if not ply.TimeoutTime then
			--		ply.TimeoutTime = CurTime()
			--	end
			--	if CurTime() - ply.TimeoutTime > 10 then
			--		ulx.kick(game.GetWorld(), ply, "Timed Out")
			--	end
			--elseif ply.TimeoutTime then
			--	ply.TimeoutTime = nil
			--end

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