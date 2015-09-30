AddCSLuaFile()

ENT.Spawnable			= false
ENT.AdminOnly			= false

SnowDensity = 1
SnowDirection = "down"

function ChangeDirection()
	if not SnowTimeout then
		local direction = nil
		if tobool( math.random( 0, 1 ) ) then
			return true
		else
			return false
		end
		SnowTimeout = false
		timer.Create( "TimerDelay", tonumber( string.format( ".%i%i", math.random(0, 9), math.random(0, 9) ) ) * 2, 0, function()
			SnowTimeout = true
		end )
	else
		return nil
	end
end

function CalcDensity()
	if not IsValid(ChangeDirection) then
		return SnowDirection, tonumber( string.format( ".%i%i", math.random(0, 5), math.random(0, 9) ) )
	else
		if ChangeDirection then
			SnowDirection = "up"
		else
			SnowDirection = "down"
		end
	end
end

function ENT:Initialize()
	
	if CLIENT then

		hook.Add( "SetupWorldFog", self, self.SetupWorldFog )
		hook.Add( "SetupSkyboxFog", self, self.SetupSkyFog )

	end

end

function ENT:SetupWorldFog()

	render.FogMode( 1 ) 
	render.FogStart( 0 )
	render.FogEnd( 0 )
	render.FogMaxDensity( math.Clamp( InterchangingVariableThatIWillAddLater, .6, 1 ) )
	render.FogColor( 255, 255, 255 )

	return true

end

function ENT:SetupSkyFog( skyboxscale )

	render.FogMode( 1 ) 
	render.FogStart( 0 )
	render.FogEnd( 0 )
	render.FogMaxDensity( math.Clamp( InterchangingVariableThatIWillAddLater, .6, 1 ) )
	render.FogColor( 255, 255, 255 )

	return true

end