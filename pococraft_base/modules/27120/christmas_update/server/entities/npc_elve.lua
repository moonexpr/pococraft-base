include( "extra_crap/elves_config.lua" )

ELVE = ents.Create( "npc_elve" )

ELVE.Spawnable		= false
ELVE.AdminSpawnable	= false

ELVE.SoundList = {
	SANTA_EVENT_IDLE = function() self:EmitSound( ElvesDialouge['w_busy0' .. math.random(1, 2)] ) end,
	SANTA_EVENT_ACTIVE = function() self:EmitSound( ElvesDialouge['p_greetings0' .. math.random(1, 6)] ) end,
	SANTA_EVENT_EVENT1 = function() self:EmitSound( ElvesDialouge['i_bugoff0' .. math.random(1, 4)] ) end,
	SANTA_EVENT_EVENT2 = function() self:EmitSound( ElvesDialouge['i_sleepexcuse0' .. math.random(1, 4)] ) end,
	SANTA_EVENT_EVENT3 = function() self:EmitSound( ElvesDialouge['i_bugoff0' .. math.random(1, 4)] ) end,
	SANTA_EVENT_EVENT4 = function() self:EmitSound( ElvesDialouge['i_sleepexcuse0' .. math.random(1, 4)] ) end,
	SANTA_EVENT_EVENT5 = function() self:EmitSound( ElvesDialouge['i_bugoff0' .. math.random(1, 4)] ) end,
	SANTA_EVENT_EVENTSPECIAL = function() self:EmitSound( ElvesDialouge['p_greetings0' .. math.random(1, 6)] ) end,
	SANTA_EVENT_EVIL_SEQ1 = function() self:EmitSound( ElvesDialouge['w_busy0' .. math.random(1, 2)] ) end,
	SANTA_EVENT_DEATH = function() self:EmitSound( ElvesDialouge['d_scream0' .. math.random(1, 3)] ) end,
}


function ELVE:SpawnFunction()
	return false
end

function ELVE:GetSantaState() -- Messy but effective
	return ents.FindByClass( "npc_santa" )[1]:GetState()
end

function ELVE:Initialize()
	if #ents.FindByClass( "npc_elve" ) <= Config.ElvesMax["e" .. GetSantaState()] then
		self:SetModel( ElvesConfig.Model )
		self:SetPos( pos ) -- ?
		self:Activate()
		self:Spawn()
	else
		return false
		AddSystemLog( "FAILURE", "Failed to create new elve! (Reached Max Limit | Santa State: " .. GetSantaState() .. ")" )
	end
end

function ELVE:Use( activator, caller )
	if not ply:IsPlayer() or not ply:Alive() then return end
	if not cooldown then
		self.SoundList[GetSantaState()]()
		cooldown = true
		timer.Simple( 1, function()
			cooldown = false
		end)
	end
end
