ENT.Type = "brush"
ENT.Spawnable = false
ENT.AdminSpawnable = false

-- Called when the entity is spawned.
function ENT:SpawnFunction( name )
	local origin_x = ( TownData.loc_start[name].X + TownData.loc_end[name].X ) / 2
	local origin_y = ( TownData.loc_start[name].Y + TownData.loc_end[name].Y ) / 2
	local origin_z = ( TownData.loc_start[name].Z + TownData.loc_end[name].Z ) / 2

    self:SetName( name )
    self:SetPos( Vector( origin_x, origin_y, origin_z ) )
	self:SetCollisionBounds( minpos, maxpos )
	self:Spawn()
	self:Activate()
end

-- Called when the entity inits.
function ENT:Initialize()
	self:SetSolid( SOLID_BBOX ) -- Not Solid
	self:SetTrigger( true )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:SetRenderMode( RENDERMODE_NONE )
end

function ENT:StartTouch( ply )
	local areasong = TownData[loc_ambient[self:GetName()]]
	if ply:IsPlayer() and ply:IsValid() and ply:Alive() then
		net.Start( "CHRISTMAS:SetupAmbient" ) -- Networking already initialized in sv_networking.lua
			net.WriteBool( true )
			net.WriteString( areasong )
		net.Send( ply )
	end
end

function ENT:EndTouch( ply )
	local areasong = TownData[loc_ambient[self:GetName()]]
	if ply:IsPlayer() and ply:IsValid() and ply:Alive() then
		net.Start( "CHRISTMAS:SetupAmbient" )
			net.WriteBool( false )
			net.WriteString( areasong )
		net.Send( ply )
	end
end