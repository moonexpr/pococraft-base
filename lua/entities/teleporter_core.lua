
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Server Teleporter"
ENT.Author			= "Potatofactory"
ENT.Information		= "Touch this and teleporter somewhere else"
ENT.Category		= "Editors"

ENT.Spawnable		= false
ENT.AdminOnly		= true

-- This is the spawn function. It's called when a client calls the entity to be spawned.
-- If you want to make your SENT spawnable you need one of these functions to properly create the entity
--
-- ply is the name of the player that is spawning it
-- tr is the trace from the player's eyes 
--
function ENT:SpawnFunction( ply, tr, ClassName )
	
	return
	
end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel(Model("models/dav0r/hoverball.mdl"))
		self:SetMaterial("models/props_lab/warp_sheet")
		self:PhysicsInitSphere( 20, "solidmetal" )
	
	end
	
end

function ENT:PortalPlayer( ply )
	--[[if ply:SteamID() == "STEAM_0:1:56987503" then
		game.ConsoleCommand( "say Potatofactory Protected!\n")
		ply:SetPos(self:LocalToWorld(Vector(200, 0, 0)))
		ply:PointAtEntity(self)
		return
	end]]--
	ply:Freeze( true ) -- Prevent them from moving while teleporting away
	if IsValid(ply:GetPhysicsObject()) then
		ply:GetPhysicsObject():EnableMotion( false ) -- Just for safety
	end
    ply:SetPos(self:LocalToWorld(Vector(50, 0, 0))) -- Force them back to avoid firing the function again
	ply:PointAtEntity(self)
	
	--[[
		Let's hide them from the world
	]]--
	
	ply:StripWeapons()
	ply:GodEnable()
	ply:SetRenderMode( RENDERMODE_NONE ) -- Make them invisible
	ply:SetCollisionGroup( COLLISION_GROUP_NONE )
	
	ply:ScreenFade( SCREENFADE.OUT, color_black, 5, 6 )
	
	timer.Simple( 6, function()
		ply:EmitSound( "ambient/energy/whiteflash.wav", 150, 100, 1, CHAN_AUTO )
		ply:SendLua([[LocalPlayer():ConCommand("connect 99.100.134.152:27017")]])
	end )
end

--[[---------------------------------------------------------
   Name: Touch
-----------------------------------------------------------]]
function ENT:Touch( ent )
	if not ent:IsValid() or ent:IsWorld() then return end
	if ent:GetClass() == "prop_combine_ball" then
		ent:Fire("Kill")
		if math.random(0, 100) == 1 then
			for _, ent in pairs(ents.FindInSphere(self:GetPos(), 250)) do
				if ent:IsPlayer() then
					ent:Freeze( true )
					ent:StripWeapons()
					ent:SetRenderMode(RENDERMODE_NONE)
					ent:ScreenFade( SCREENFADE.IN, color_white, 1, 18 )
					self:EmitSound( "vo/Citadel/gman_exit01.wav", 150, 100, 1, CHAN_AUTO )
					timer.Simple(4.5, function()
						timer.Simple(.5, function()
							ent:SendLua("LocalPlayer():ConCommand(\"play vo/Citadel/gman_exit05.wav\")")
							timer.Simple(15, function()
								ent:Kick("npc_gman")
							end )
						end )
					end )
				elseif ent:IsNPC() then
					self:EmitSound("npc/overwatch/cityvoice/fcitadel_confiscating.wav", 150, 100, 1, CHAN_AUTO)
					ent:SetHealth( 999999 ) -- Impossible to kill
					timer.Simple(8, function()
						ent:SetName(tostring(ent:GetCreationID()))
						local dissolve = ents.Create("env_entity_dissolver")
						dissolve:SetPos(ent:GetPos())
						dissolve:SetKeyValue("target", ent:GetName())
						dissolve:SetKeyValue("dissolvetype", "1")
						dissolve:Spawn()
						dissolve:Fire("Dissolve", "", 0)
						dissolve:Fire("kill", "", 1)
					end )
				end
			end
		else
			local function GeneratePlayerlist(localplayer)
				meta = player.GetAll()
				table.RemoveByValue( meta, localplayer )
				for _, existing in pairs(meta) do
					if existing:GetMoveType() == MOVETYPE_NOCLIP then
						table.RemoveByValue( meta, existing )
					end
				end
				return meta
			end
			self:EmitSound( "ambient/energy/zap" .. math.random(1, 9) .. ".wav", 150, 100, 1, CHAN_AUTO )
			for _, ply in pairs(ents.FindInSphere(self:GetPos(), 200)) do
				if ply:IsPlayer() then
					newply = table.Random(GeneratePlayerlist(ply))

					-- WEAPON CONTROL

					ply:StripWeapons()
					ply:Give("weapon_physgun")
					ply:Give("gmod_tool")
					ply:Give("gmod_camera")

					-- TELEPORTING
					ply:SetPos(newply:GetPos())
					ply:SetLocalVelocity(Vector( 0, 0, 0 )) -- Stop!
					ply:ScreenFade( SCREENFADE.IN, color_white, 1, .5 )
					ply:SetCollisionGroup( 11 )
					if math.random(0, 100) <= 20 then
						death = ents.Create("prop_physics")
						death:SetModel("models/Gibs/HGIBS.mdl")
						death:SetPos(ply:LocalToWorld(Vector(20, 0, 0)))
						death:SetAngles(ply:GetAngles() * -1)
						death:Spawn()
						death:Activate()
						death:EmitSound( "vo/npc/male01/heydoc01.wav" )
						death:Fire( "Ignite" )
						timer.Simple( math.random(5, 20), function()
							if not IsValid(death) then return end
							if death:GetPos():Distance(ply:GetPos()) <= 1000 then
								game.ConsoleCommand( "ulx surl * \"https://gmodloadingurl.pococraft.org/onboard_snd/trigger_death.mp3\"\n" )
								ply:Kill()
							end
							death:Fire( "Kill" )
						end )
					end
				end
			end
			local runtime = 2
			local scale = math.random(1, 20)
			local timerset = CurTime() + runtime
			hook.Add( "Tick", "PulseCore", function ()
				local now = timerset - CurTime()
				local value = now / runtime
				if now <= 0 then
					hook.Remove( "Tick", "PulseCore" )
					self:SetModelScale(1, 0)
				else
					self:SetModelScale(1 + scale * value, 0)
				end
			end )
		end
	elseif ent:IsPlayer() then
		if ent:IsBot() then ent:Kick( "Ejected from our world" ) return end
		self:PortalPlayer( ent )
	elseif ent:IsNPC()
		or ent:GetClass() == "prop_ragdoll"
		or ent:GetClass() == "prop_effect"
		or ent:GetClass() == "sammyservers_textscreen" then
		if ent:GetModel() == "models/gman_high.mdl" or ent:GetModel() == "models/gman.mdl" then
			for _, ply in pairs(ents.FindInSphere(self:GetPos(), 1500)) do
				if ply:IsPlayer() then
					ply:ScreenFade( SCREENFADE.IN, color_red, .25, .5 )
				end
			end
			ent:Fire("Kill")
			local standley = ents.Create("prop_ragdoll")
			standley:SetModel("models/Humans/Group01/Male_04.mdl")
			standley:SetPos(self:GetPos() + Vector(0, 0, 100))
			standley:Spawn()
			standley:EmitSound("vo/coast/bugbait/sandy_help.wav", 120, 100, 1, CHAN_AUTO)
		end
		ent:SetName(tostring(ent:GetCreationID()))
		local dissolve = ents.Create("env_entity_dissolver")
		dissolve:SetPos(ent:GetPos())
		dissolve:SetKeyValue("target", ent:GetName())
		dissolve:SetKeyValue("dissolvetype", "1")
		dissolve:Spawn()
		dissolve:Fire("Dissolve", "", 0)
		dissolve:Fire("kill", "", 1)
	elseif IsValid(ent:GetPhysicsObject()) then
		self:EmitSound("ambient/levels/labs/electric_explosion" .. math.random(1, 5) .. ".wav")
		if math.random(1, 50) == 1 then
			self:Fire("Ignite")
		end
		if math.random(1, 100) == 1 then
			local standley = ents.Create("prop_ragdoll")
			standley:SetModel("models/Humans/Group01/Male_04.mdl")
			standley:SetPos(self:GetPos() + Vector(0, 0, 100))
			standley:Spawn()
			standley:EmitSound("vo/coast/bugbait/sandy_help.wav", 120, 100, 1, CHAN_AUTO)
		end
		ent:Fire("Kill")
	end
end

--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( ent )

	if not ent:IsPlayer() or not ent:IsValid() or ent:IsWorld() then return end
	PortalPlayer( ent )

end
