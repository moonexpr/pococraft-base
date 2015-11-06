ModInfo.Name = "Spawning Effect"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

util.AddNetworkString( "PP:PlayerSpawnEffect" )

AddCSLuaFile( "modules/all/game_spawneffect/cl_networking.lua" )

hook.Add( "PlayerDeath", "BeginEffect", function( ply )
	net.Start("PP:PlayerSpawnEffect")
		net.WriteBool( true )
	net.Send( ply )
end)

hook.Add( "PlayerSpawn", "EndEffect", function( ply )
	net.Start("PP:PlayerSpawnEffect")
		net.WriteBool( false )
	net.Send( ply )
end)