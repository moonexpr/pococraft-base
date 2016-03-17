for _, v in pairs(ents.FindByClass("ent_jumpgame")) do v:Remove() end
for _, v in pairs(ents.FindByClass("trigger_lua")) do v:Remove() end

local jumpgame = ents.Create( "ent_jumpgame" )
jumpgame:SetPos( Vector( 12104.572266, 6290.136230, -191.968750 ) )
jumpgame:SetAngles( Angle(0, 0, 0) )
jumpgame:Spawn()

local genloc1 = ents.Create("trigger_lua")
genloc1:Spawn()
genloc1:SetCollisionBoundsWS( Vector( -14319.968750, -14319.968750, 10239.96875), Vector(14319.968750, 14319.968750,-887.968750)  )
genloc1.AreaData["Name"] = "Overworld"

local upperWhite = ents.Create("trigger_lua")
upperWhite:Spawn()
upperWhite:SetCollisionBoundsWS( Vector( -14724.575195, -20457.435547, -10739.590820 ), Vector( 10161.572266, 3081.076904, -97.916496 ) )
upperWhite.AreaData["Name"] = "Chromaroom"
upperWhite.AreaData["Parent"] = genloc1

local upperMirror = ents.Create("trigger_lua")
upperMirror:Spawn()
upperMirror:SetCollisionBoundsWS( Vector( 8324.033203, 4287.968750, -687.865295 ), Vector( 9483.089844, 3295.968750, -421.933990 ) )
upperMirror.AreaData["Name"] = "Mirror Room"
upperMirror.AreaData["Parent"] = genloc1

local upperbldg1 = ents.Create("trigger_lua")
upperbldg1:Spawn()
upperbldg1:SetCollisionBoundsWS( Vector( 9911.961914, 4639.946777, -399.968750 ), Vector( 7912.031250, 3776.037109, -96.028694 )  )
upperbldg1.AreaData["Name"] = "Hanger"
upperbldg1.AreaData["Parent"] = genloc1

local upperbldg2 = ents.Create("trigger_lua")
upperbldg2:Spawn()
upperbldg2:SetCollisionBoundsWS( Vector( 12911.968750, 5467.790039, -456.171051 ), Vector( 8784.143555, 1964.303467, -887.968750 ) )
upperbldg2.AreaData["Name"] = "TO DO: Room"
upperbldg2.AreaData["Parent"] = genloc1

local upperbldg3 = ents.Create("trigger_lua")
upperbldg3:Spawn()
upperbldg3:SetCollisionBoundsWS( Vector( 7719.897949, 3120.031250, -399.893890 ), Vector( 5656.031250, 4639.962891, -96.033699 ) )
upperbldg3.AreaData["Name"] = "Dark Room"
upperbldg3.AreaData["Parent"] = genloc1

local upperbldg4 = ents.Create("trigger_lua")
upperbldg4:Spawn()
upperbldg4:SetCollisionBoundsWS( Vector( 5656.031250, 4639.962891, -96.033699 ), Vector( 5888.094238, 8847.968750, -16.155685 ) )
upperbldg4.AreaData["Name"] = "Central Station Lobby"
upperbldg4.AreaData["Parent"] = genloc1

local upperbldg5 = ents.Create("trigger_lua")
upperbldg5:Spawn()
upperbldg5:SetCollisionBoundsWS( Vector( 6335.370605, 10048.268555, 303.568024 ), Vector( 7663.912598, 8864.031250, -207.866653 ) )
upperbldg5.AreaData["Name"] = "Central Station Tower"
upperbldg5.AreaData["Parent"] = genloc1

local upperbldg6 = ents.Create("trigger_lua")
upperbldg6:Spawn()
upperbldg6:SetCollisionBoundsWS( Vector( 6295.830566, 9792.076172, -16.031250 ), Vector( 5952.247559, 13247.968750, -207.926697 ) )
upperbldg6.AreaData["Name"] = "Central Station Observatory"
upperbldg6.AreaData["Parent"] = genloc1

local spawninglobby1 = ents.Create("trigger_lua")
spawninglobby1:Spawn()
spawninglobby1:SetCollisionBoundsWS( Vector( 12599.869141, 6543.911621, -224.031250 ), Vector( 12008.044922, 4672.102539, -399.968750 ) )
spawninglobby1.AreaData["Name"] = "Spawning Lobby"
spawninglobby1.AreaData["Parent"] = genloc1

local spawninglobby2 = ents.Create("trigger_lua")
spawninglobby2:Spawn()
spawninglobby2:SetCollisionBoundsWS( Vector( 11524.031250, 3664.074707, -399.813354 ), Vector( 12551.985352, 4655.920898, -48.031258 ) )
spawninglobby2.AreaData["Name"] = "Spawning Lobby"
spawninglobby2.AreaData["Parent"] = genloc1

local spawninglobby2 = ents.Create("trigger_lua")
spawninglobby2:Spawn()
spawninglobby2:SetCollisionBoundsWS( Vector( 11524.031250, 3664.074707, -399.813354 ), Vector( 12551.985352, 4655.920898, -48.031258 ) )
spawninglobby2.AreaData["Name"] = "Spawning Lobby"
spawninglobby2.AreaData["Parent"] = genloc1

local trainobserv1 = ents.Create("trigger_lua")
trainobserv1:Spawn()
trainobserv1:SetCollisionBoundsWS( Vector( 12551.985352, 4655.920898, -48.031258 ), Vector( 12704.203125, 13623.960938, -104.035866 ) )
trainobserv1.AreaData["Name"] = "Train Observatory 1"
trainobserv1.AreaData["Parent"] = genloc1

local spawningarea1 = ents.Create("trigger_lua")
spawningarea1:Spawn()
spawningarea1:SetCollisionBoundsWS( Vector( 11975.968750, 4902.729980, -207.703018 ), Vector( 11615.920898, 6808.586426, -399.968750 ) )
spawningarea1.AreaData["Name"] = "Spawning Area"
spawningarea1.AreaData["Parent"] = genloc1

