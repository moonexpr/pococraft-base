include 'config.lua'

local function SpawnNPC()
	timer.Simple(5, function()
		local npc = ents.Create("npc_master")
		npc:SetPos( GeneralPosition + Vector(-58, 136, 0) )
		npc:SetAngles( Angle(0, 68.599, 0) )
		npc:Spawn()
	end)

end
hook.Add("InitPostEntity", "SpawnGangNPC", SpawnNPC)


function ENT:Initialize( )
	self:SetModel( "models/kleiner.mdl" )
 	self:SetHullType( HULL_HUMAN )
	self:SetUseType( SIMPLE_USE )
	self:SetHullSizeNormal( )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_USE_SHOT_REGULATOR || CAP_TURN_HEAD || CAP_AIM_GUN )
	self:SetMaxYawSpeed( 5000 )
	local PhysAwake = self.Entity:GetPhysicsObject( )
	if PhysAwake:IsValid( ) then
		PhysAwake:Wake( )
	end 
end

function ENT:OnTakeDamage( dmg ) 
	return false
end