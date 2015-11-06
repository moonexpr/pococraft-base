ModInfo.Name = "Spawn Model"
ModInfo.Author = "Potatofactory"

function TestSuccess()
	return true
end

function SpawnMen()
	for k, v in pairs(ents.FindByModel( "models/editor/playerstart.mdl" )) do
		v:Remove()
	end

	Ents = {}

	for k, v in pairs(ents.FindByClass( "info_player_start" )) do
		local trace = {
			start = v:GetPos(),
			endpos = v:GetPos() - Vector( 0, 0, 32768 ),
			mask = MASK_BLOCKLOS,
		}
		
		e = ents.Create( "prop_dynamic" )
		table.insert(Ents, e)
		e:SetModel( "models/editor/playerstart.mdl" )
		e:SetPos(util.TraceLine(trace).HitPos)
		e:SetAngles( v:GetAngles() )
		e:Spawn()
		
	end

	hook.Add( "Tick", "Rotate", function()
		for k, v in pairs(Ents) do
			v:SetAngles( v:GetAngles() + Angle(	0, 3, 0 ) )
		end
	end )
end

hook.Add( "InitPostEntity", "", SpawnMen)
hook.Add( "PostCleanupMap", "", SpawnMen)