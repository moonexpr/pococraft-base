include( "extra_crap/santa_config.lua" )

--[[
	For reference
	=================================
	SANTA_EVENT_IDLE = 0
	SANTA_EVENT_ACTIVE = 1
	SANTA_EVENT_EVENT1 = 12
	SANTA_EVENT_EVENT2 = 13
	SANTA_EVENT_EVENT3 = 14
	SANTA_EVENT_EVENT4 = 15
	SANTA_EVENT_EVENT5 = 16
	SANTA_EVENT_EVENTSPECIAL = 9999
	SANTA_EVENT_EVIL_SEQ1 = 22
	SANTA_EVENT_DEATH = 32
]]--

ENT.Spawnable			= false
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

function ENT:Use( ply )
	if not ply:IsPlayer() or not ply:Alive() then return end
	if not cooldown and self:GetState() == SANTA_EVENT_ACTIVE then
		self:EmitSound( SantaConfig.Dialouge['h_merrychristmas0' .. math.random(1, 2)] )
		cooldown = true
		timer.Simple( 1, function()
			cooldown = false
		end)
	end
end

function ENT:Touch( ply )
	if not ply:IsPlayer() or not ply:Alive() then return end
	if not cooldown and self:GetState() == SANTA_EVENT_ACTIVE then
		self:EmitSound( SantaConfig.Dialouge['h_grettings0' .. math.random(1, 6)] )
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