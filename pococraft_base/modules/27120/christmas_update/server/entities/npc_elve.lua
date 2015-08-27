include( "extra_crap/elves_config.lua" )

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

function ENT:SpawnFunction()
	if #ents.FindByClass( "npc_elve" ) <= 8 then
		self:SetState( SANTA_EVENT_ACTIVE )
		self:SetPos( pos )
		self:Activate()
		self:Spawn()
	end
end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

end

--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )

end
