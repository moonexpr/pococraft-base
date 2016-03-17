ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Jump_Rope"
ENT.Author = "Coderz"
ENT.Contact = "Coderz"
ENT.Purpose = "Jumping Rope Is fun" 
ENT.Category = "Coderz_Entity"

--ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Initialize()

	self.Entity:SetModel("models/hunter/blocks/cube2x2x025.mdl")
	
end