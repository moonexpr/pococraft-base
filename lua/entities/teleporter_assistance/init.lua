AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.Timer = 0
ENT.PainSoundT = 0
MenuPlayer = nil
GuidePlayer = false

util.AddNetworkString("teleporter_menu")
util.AddNetworkString("ServerTeleporterNPCMenu")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/Kleiner.mdl")
	self.loco:SetMaxYawRate(10)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	net.Receive("ServerTeleporterNPCMenu", function(len, ply)
		self:EmitSound("combined/k_lab/k_lab_kl_fewmoments01_cc.wav")
		if MenuPlayer == ply then
			MenuPlayer = nil
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ShowPlayer()
	self:EmitSound("combined/k_lab/k_lab_kl_excellent_cc.wav")
	GuidePlayer = true
	timer.Simple(1, function()
		GuidePlayer = false
	end )	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInjured( CTakeDamageInfo )
	self:SetHealth(1000)
	local attacker = CTakeDamageInfo:GetAttacker()
	CTakeDamageInfo:ScaleDamage(0)
	CTakeDamageInfo:SetDamage(0)
	if attacker:IsPlayer() then
		attacker:Fire("Ignite")
		attacker:SetVelocity(Vector(0, 0, 500))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:RunBehaviour()
	while true do
		if GuidePlayer then
			self:PlaySequenceAndWait("kgesture11", 1)
		end
		self:PlaySequenceAndWait("LineIdle01", 1)
		
		coroutine.yield()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller, key)
	if caller:IsPlayer() and caller:IsValid() and caller:Alive() and self.Timer <= CurTime() then
		if MenuPlayer == nil then
			self.Timer = CurTime() + 5
			MenuPlayer = caller
			self:PointAtEntity(caller)
			self:EmitSound("combined/k_lab/k_lab_kl_mygoodness02_cc.wav")
			umsg.Start("teleporter_menu", caller)
			umsg.End()
		else
			caller:SendLua("chat.AddText(\"Rude! Someone's already talking to Kleiner!\")")
		end	
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
