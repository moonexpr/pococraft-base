include( "define.lua" )

function LockdownServer( type )
	if type == 1 then
		function GAMEMODE:CheckPassword( SteamID64, IP, ServerPass, ClientPass, ClientName )
			return false, "Sorry, It looks as if we are experiencing technical issues that have caused our server to stop operating normally. Please be patient with us as we resolve this issue!"
		end
		game.ConsoleCommand( "kickall \"Unfortunately, We're experiencing internal issues that are preventing our servers from operating normally.\"\n" )
	elseif type == 2 then
		function GAMEMODE:CheckPassword( SteamID64, IP, ServerPass, ClientPass, ClientName )
			return false, "This server is used for the development of Christmas 2015! For more information, please visit us at forums.pococraft.org!"
		end
		game.ConsoleCommand( "sv_password #DEVELOPER_PASSWORD\n" )
		game.ConsoleCommand( "hostname Pococraft Christmas 2015 (Locked)\n" )
		for id, ply in pairs(player.GetAll()) do
			ply:SendLua( [[
				LocalPlayer():ConCommand( "connect 72.14.181.134:27015" )
			]])
		end
	else
		ServerLog( "[ERROR] Christmas 2015: Attempted to use lockdown type " .. type )
	end
end

function ChangeServerState( state )
	if state == GAME_STATE_MISMATCH then
		hook.Add( "Tick", "CantFunctionHere", function()
			game.ConsoleCommand( "gamemode sandbox\n" )
			game.ConsoleCommand( "changelevel rp_christmastown\n" )
		end )
		ServerState = GAME_STATE_MISMATCH
	elseif state == GAME_STATE_BUGGED then
		LockdownServer( 1 )
		ServerState = GAME_STATE_BUGGED
	elseif state == GAME_STATE_DEVELOPMENT then
		LockdownServer( 2 )
		ServerState = GAME_STATE_DEVELOPMENT
	elseif state == GAME_STATE_NORMAL then
		ServerState = GAME_STATE_NORMAL
	end
	hook.Call( "AppendServerState", GAMEMODE, state )
end