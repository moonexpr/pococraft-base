ModInfo.Name = "Warnbot: Entity Tracker"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end
--Entity Crash Catcher
--Detects entities that are either going to fast or have invalid positions, and stops them from crashing the server.
-- By code_gs, Ambro, DarthTealc, TheEMP
-- GitHub: https://github.com/Kefta/Entity-Crash-Catcher
-- Facepunch thread: http://facepunch.com/showthread.php?t=1347114
-- This script is also implemented into pLib: https://github.com/SuperiorServers/plib_v2

-- Config
LoggingTag		= "[Warnbot] "
LoggingColor	= Color(200, 0, 100)

EchoFreeze	= true		-- Tell players when a body is frozen
EchoRemove	= true		-- Tell players when a body is removed

FreezeSpeed	= 8000		-- Velocity ragdoll is frozen at; make greater than RemoveSpeed if you want to disable freezing
RemoveSpeed	= 10000		-- Velocity ragdoll is removed at

FreezeTime	= 1       	-- Time body is frozen for
ThinkDelay	= 0.5     	-- How often the server should check for bad ragdolls; change to 0 to run every Think

VelocityHook = true		-- Check entities for unreasonable velocity	
UnreasonableHook = true		-- Check entities for unreasonable angles/positions
NaNCheck = true			-- Check and attempt to remove any ragdolls that have NaN/inf positions
-- End config

IsTTT = false			-- Internal variable for detecting TTT
--[[
MAX_COORD = 16000
MIN_COORD = -MAX_COORD
MAX_ANGLE = 16000
MIN_ANGLE = -MAX_ANGLE
COORD_EXTENT = 2*MAX_COORD
MAX_TRACE_LENGTH = math.sqrt(3)*COORD_EXTENT
]]--
MAX_REASONABLE_COORD = 15950
MAX_REASONABLE_ANGLE = 15950
MIN_REASONABLE_COORD = -MAX_REASONABLE_COORD
MIN_REASONABLE_ANGLE = -MAX_REASONABLE_ANGLE

hook.Add( "PostGamemodeLoaded", "physics.CheckTTT", function()
	if ( GAMEMODE_NAME == "terrortown" or ( CORPSE and CORPSE.Create ) ) then
		IsTTT = true
	end
end )

function KillVelocity( ent )
	if ( not IsValid( ent ) ) then return end
	
	local oldcolor = ent:GetColor() or Color( 255, 255, 255, 255 )
	local newcolor = Color( 255, 0, 255, 255 )
	ent:SetColor( newcolor )
	
	ent:SetVelocity( vector_origin )
	
	if ( IsTTT and IsValid( ent:GetOwner() ) ) then
		ent:GetOwner():GetWeapon( "weapon_zm_carry" ):Reset( false )
	end
	
	for i = 0, ent:GetPhysicsObjectCount() - 1 do
		local subphys = ent:GetPhysicsObjectNum( i )
		if ( IsValid( subphys ) ) then
			subphys:EnableMotion( false )
			subphys:SetMass( subphys:GetMass() * 20 )
			subphys:SetVelocity( vector_origin )
		end
	end
	
	timer.Simple( FreezeTime, function()
		if ( not IsValid( ent ) ) then return end
		for i = 0, ent:GetPhysicsObjectCount() - 1 do
			local subphys = ent:GetPhysicsObjectNum( i )
			if ( IsValid( subphys ) ) then
				subphys:SetMass( subphys:GetMass() / 20 )
				subphys:EnableMotion( true )
				subphys:Wake()
			end
		end
		
		ent:SetColor( oldcolor )
	end )
end

function IdentifyCorpse( ent )
	if ( not IsValid( ent ) or not CORPSE or CORPSE.GetFound( ent, false ) ) then return end
	
	local dti = CORPSE.dti
	local ply = ent:GetDTEntity( dti.ENT_PLAYER ) or player.GetByUniqueID( ent.uqid )
	local nick = CORPSE.GetPlayerNick( ent, nil ) or ply:Nick() or "N/A"
	local role = ent.was_role or ( ply.GetRole and ply:GetRole() ) or ROLE_INNOCENT
	
	if ( IsValid( ply ) ) then
		ply:SetNWBool( "body_found", true )
		if ( role == ROLE_TRAITOR ) then
			SendConfirmedTraitors( GetInnocentFilter( false ) )
		end
	end
	
	local bodyfound = true
	
	if ( IsValid( GetConVar( "ttt_announce_body_found" ) ) ) then
		bodyfound = GetConVar( "ttt_announce_body_found" ):GetBool()
	end
	
	local roletext = "body_found_i"
	
	if ( bodyfound ) then
		if ( role == ROLE_TRAITOR ) then
			roletext = "body_found_t"
		elseif ( role == ROLE_DETECTIVE ) then
			roletext = "body_found_d"
		end
		
		LANG.Msg( "body_found", { finder = "The Server", victim = nick, role = LANG.Param( roletext ) } )
	end
	
	CORPSE.SetFound( ent, true )
	
	for _, vicid in pairs( ent.kills ) do
		local vic = player.GetByUniqueID( vicid )
		if ( IsValid( vic ) and not vic:GetNWBool( "body_found", false ) ) then
			LANG.Msg( "body_confirm", { finder = "The Server", victim = vic:Nick() or vic:GetClass() } )
			vic:SetNWBool( "body_found", true )
		end
	end
end

if ( VelocityHook or UnreasonableHook ) then
	local NextThink = 0
	
	local InvalidStrings =
	{
		["nan"] = true,
		["inf"] = true,
		["-inf"] = true,
		["-nan"] = true
	}
	
	hook.Add( "Think", "physics.Unreasonable", function()
		local function EPOELog(msg)
			parse = string.format("epoe.AddText(Color(255, 0, 50), [[Entity Tracker: ]], Color(255, 255, 255), [[%s\n]])", msg)
			for _, ply in pairs(player.GetAll()) do
				if ply:IsAdmin() then
					ply:SendLua(parse)
				end
			end
		end

		if ( NextThink > CurTime() ) then return end
		
		NextThink = CurTime() + ThinkDelay
			
		local ents = ents.GetUnreasonables()
		local ent
		
		for i = 1, #ents do
			ent = ents[i]
			if ( IsValid( ent ) ) then
				if ( NaNCheck ) then
					local pos = ent:GetPos()
					if ( InvalidStrings[tostring( pos.x )] or InvalidStrings[tostring( pos.y )] or InvalidStrings[tostring( pos.z )] ) then
						ent:Remove()
						continue
					end
					local ang = ent:GetAngles()
					if ( InvalidStrings[tostring( ang.p )] or InvalidStrings[tostring( ang.y )] or InvalidStrings[tostring( ang.r )] ) then
						ent:Remove()
						continue
					end
				end
				
				if ( VelocityHook ) then
					local velo = ent:GetVelocity():Length()
					if ent:IsPlayer() and ent:GetMoveType() == MOVETYPE_WALK and ent:IsOnGround() and ent:GetUserGroup() == "user" then
						local nick = ent:Nick()
						local maxspeed = ULib.ucl.groups[ent:GetUserGroup()].team.runSpeed or 500
						if velo >= maxspeed + 1500 then -- + 1500 compensation
							ent:Spawn()
							local message = "Respawned player " .. nick .. " for moving too fast (Run Speed: " .. velo .. " UPS, Max: " .. maxspeed .. ", Compensation: 1500 UPS )"
							ServerLog( message .. "\n" )
							if ( EchoRemove ) then
								EPOELog( message )
							end
						end
					elseif ( velo >= RemoveSpeed ) then
						local nick = ent:GetNWString( "nick", ent:GetClass() )
						local owner = IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner():IsPlayer() and "player: " .. ent:CPPIGetOwner():Nick() or tostring(ent:CPPIGetOwner()) or "world"
						if ( IsTTT and ent:IsPlayer() ) then
							IdentifyCorpse( ent )
						end
						ent:Remove()
						local message = "Removed " .. nick .. " (owned by " .. owner .. ") for moving too fast" .. " (" .. velo .. " UPS )"
						ServerLog( message .. "\n" )
						if ( EchoRemove ) then
							EPOELog( message )
						end
					elseif ( velo >= FreezeSpeed ) then
						ent:CollisionRulesChanged()
						local nick = ent:GetNWString( "nick", ent:GetClass() )
						local owner = IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner():IsPlayer() and "player: " .. ent:CPPIGetOwner():Nick() or tostring(ent:CPPIGetOwner()) or "world"
						KillVelocity( ent )
						local message = "Froze " .. nick .. " (owned by " .. owner .. ") for moving too fast" .. " (" .. velo .. " UPS )"
						ServerLog( message .. " (" .. velo .. ") \n" )
						if ( EchoFreeze ) then
							EPOELog( message )
						end
					end
				end
				
				if ( UnreasonableHook ) then
					local ang = ent:GetAngles()
					if ( not util.IsReasonable( ang ) ) then
						ent:SetAngles( ang.p % 360, ang.y % 360, ang.r % 360 )
					end
				
					local pos = ent:GetPos()
					if ( not util.IsReasonable( pos ) ) then
						if ( ent:IsPlayer() or ent:IsNPC() ) then
							ent:SetPos( vector_origin )
						else
							ent:Remove()
						end
					end
				end
			end
		end
	end )
end

function util.IsReasonable( struct )
	if ( isvector( struct ) ) then
		if( struct.x >= MAX_REASONABLE_COORD or struct.x <= MIN_REASONABLE_COORD or 
			struct.y >= MAX_REASONABLE_COORD or struct.y <= MIN_REASONABLE_COORD or 
			struct.z >= MAX_REASONABLE_COORD or struct.y <= MIN_REASONABLE_COORD ) then
			return false
		end
	elseif ( isangle( struct ) ) then
		if( struct.p >= MAX_REASONABLE_ANGLE or struct.p <= MIN_REASONABLE_ANGLE or 
			struct.y >= MAX_REASONABLE_ANGLE or struct.y <= MIN_REASONABLE_ANGLE or 
			struct.r >= MAX_REASONABLE_ANGLE or struct.r <= MIN_REASONABLE_ANGLE ) then
			return false
		end
	else
		error( string.format( "Invalid data type sent into util.IsReasonable ( Vector or Angle expected, got %s )", type( struct ) ) )
	end
	
	return true
end

local UnreasonableEnts =
{
	[ "prop_physics" ] = true,
	[ "prop_ragdoll" ] = true
}

function ents.GetUnreasonables()
	local ParedEnts = {}
	local AllEnts = ents.GetAll()
	
	for i = 1, #AllEnts do
		if ( UnreasonableEnts[ AllEnts[i]:GetClass() ] or AllEnts[i]:IsPlayer() or AllEnts[i]:IsNPC() ) then
			ParedEnts[#ParedEnts + 1] = AllEnts[i]
		end
	end
	
	return ParedEnts
end
