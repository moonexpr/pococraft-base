include( "extra_crap/santa_config.lua" )

--[[
	For reference
	=================================
	SANTA_EVENT_IDLE = 0
	SANTA_EVENT_ACTIVE = 1
	SANTA_EVENT_EVENT1 = 2
	SANTA_EVENT_EVENT2 = 3
	SANTA_EVENT_EVENT3 = 4
	SANTA_EVENT_EVENT4 = 5
	SANTA_EVENT_EVENT5 = 6
	SANTA_EVENT_EVENTSPECIAL = 9999
	SANTA_EVENT_EVIL_SEQ1 = 7
	SANTA_EVENT_EVIL_SEQ2 = 7
	SANTA_EVENT_EVIL_SEQ3 = 7
	SANTA_EVENT_EVIL_SEQ4 = 7
	SANTA_EVENT_DEATH = 8
]]--

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

function ENT:SpawnFunction( )
	return false
end

function ENT:GetState( state )
	return self:GetNWString( "SantaState" )
end

function ENT:SetState( state )
	self:SetNWString( "SantaState", state )
	AddSystemLog( L.INFO, "Changing Santa's State..." )

end

function ENT:SpawnFunction( pos, state )
	if #ents.FindByClass( "npc_santa" ) == 1 then
		self:SetState( SANTA_EVENT_ACTIVE )
		self:SetPos( pos )
		self:Activate()
		self:Spawn()
	end
end

function ENT:Use( ply )
	if not ply:IsPlayer() or not ply:Alive() then return end
	if not cooldown and self:GetState() == SANTA_EVENT_ACTIVE then
		self:EmitSound( SantaDialouge['h_merrychristmas0' .. math.random(1, 2)] )
		cooldown = true
		timer.Simple( 1, function()
			cooldown = false
		end)
	end
end

function ENT:Touch( ply )
	if not ply:IsPlayer() or not ply:Alive() then return end
	if not cooldown and self:GetState() == SANTA_EVENT_ACTIVE then
		self:EmitSound( SantaDialouge['h_grettings0' .. math.random(1, 6)] )
		cooldown = true
		timer.Simple( 1, function()
			cooldown = false
		end)
	end
end

function ENT:Initialize()
	if #ents.FindByClass( "npc_santa" ) == 1 then
		self:SetState( "SANTA_EVENT_ACTIVE" )
		self:SetModel( SantaConfig.Model )
		self:SetPos( pos )
		self:Activate()
		self:Spawn()
	else
		return false
		AddSystemLog( "FAILURE", "Failed to create santa! (Reached Max Limit | Santa State: " .. self:GetState() .. ")" )
	end
end