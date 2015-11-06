
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

	if not ply:IsSuperAdmin() or not tr.Hit then
		ply:SendLua( [[
			chat.AddText( ":information: You are not allowed to spawn this." )
		]] )
		return
	end
	
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel( Model("models/dav0r/hoverball.mdl") )
		self:PhysicsInitSphere( 20, "solidmetal" )
	
	end
	
end

function ENT:PortalPlayer( ply )
	ply:Freeze( true ) -- Prevent them from moving while teleporting away
	ply:GetPhysicsObject():EnableMotion( false ) -- Just for safety
    ply:SetPos( ply:GetPos() + Vector( 0, ply:GetVelocity().Y + 10, 0 ) ) -- Force them back to avoid firing the function again
	ply:PointAtEntity( self:GetAngles() )
	
	--[[
		Let's hide them from the world
	]]--
	
	ply:StripWeapons()
	ply:SetRenderMode( RENDERMODE_NONE ) -- Make them invisible
	ply:SetCollisionGroup( COLLISION_GROUP_NONE )
	
	ply:ScreenFade( SCREENFADE.OUT, color_black, 5, 6 )
	
	timer.Simple( 5, function()
		ply:EmitSound( "ambient/energy/whiteflash.wav", 150, 100, 1, CHAN_AUTO )
		ply:SendLua([[LocalPlayer():ConCommand("connect 72.14.181.134:27120")]])
	end)
end

--[[---------------------------------------------------------
   Name: Touch
-----------------------------------------------------------]]
function ENT:Touch( ent )

	if not ent:IsValid() or ent:IsWorld() then return end
	if ent:IsPlayer() then
		if ent:IsBot() then ent:Kick( "Ejected from our world" ) end
		self:PortalPlayer( ent )
	elseif ent:IsNPC() then
		ent:SetName(tostring(ent:GetCreationID()))
		local dissolve = ents.Create("env_entity_dissolver")
		dissolve:SetPos(ent:GetPos())
		dissolve:SetKeyValue("target", ent:GetName())
		dissolve:SetKeyValue("dissolvetype", "1")
		dissolve:Spawn()
		dissolve:Fire("Dissolve", "", 0)
		dissolve:Fire("kill", "", 1)
	end

end

--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( ent )

	if not ent:IsPlayer() or not ent:IsValid() or ent:IsWorld() then return end
	PortalPlayer( ent )

end
