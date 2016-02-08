ENT.Author					= "Potatofactory"
ENT.PrintName 				= "Easter Egg 1"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

if SERVER then
	function ENT:Initialize()
		self:SetSolid( SOLID_BBOX )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:PhysWake()
		self:SetModel( "models/Gibs/HGIBS.mdl" )
		self:SetUseType( SIMPLE_USE )
	end

	function ENT:AcceptInput( _, _, ply )
		if not ply:IsPlayer() then return end
		ply:SendLua([[LocalPlayer():ConCommand("easter_egg1 15614ad4aw9d4a89wd45a6d4awd98aw4daw4daw6da4w")]])		
	end
end