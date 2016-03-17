timer.Simple(.1, function()

surface.CreateFont("DeathNotice", {
	font = system.IsWindows() and "Tahoma" or "Roboto",
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

local CitizenKillText = {
	"wowzerz",
	"murder!",
	"oshit",
	"halp!",
	"badass.",
	"yay!",
	"oh noes",
	"alert!",
	"tot rad.",
	"koolzerz",
	"woah!",
	"ZOMG",
	"pu$$y destroyer",
	"n0sc0pe'd",
	"360^^",
	"wowzerz",
	"murder!",
	"oshit",
	"halp!",
	"badass.",
	"yay!",
	"oh noes",
	"alert!",
	"tot rad.",
	"koolzerz",
	"woah!",
	"ZOMG",
	"pu$$y destroyer",
	"n0sc0pe'd",
	"360^^",
	"xXPussyDestroyer_360N0Sc0pedWOWOWOWOWOWOWxX"
}

local CustomDeaths = {
	["Physics Prop"] = "%s got crushed by physics",
	["Fire"] = "%s burned like a candle",
	["Explosion"] = "%s turned into a rocket and left the atmosphere!",
}

local GM = istable(GM) and GM or GAMEMODE

local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "10", FCVAR_REPLICATED, "Amount of time to show death notice" )

local NPC_Color = Color( 250, 50, 50, 255 )

local Deaths = {}
local cache = {}

--[[---------------------------------------------------------
   Name: gamemode:AddDeathNotice( Victim, Attacker, Weapon )
   Desc: Adds an death notice entry
-----------------------------------------------------------]]
function GM:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2 )
	
	
	Inflictor= '#'..Inflictor==Attacker and "" or Inflictor
	
	local cached = cache[Attacker or ""] and cache[Attacker or ""][Victim or ""] and cache[Attacker or ""][Victim or ""][Inflictor or ""]
	if cached then
		cached.time = RealTime()
		cached.times = cached.times + 1
		
		return
	end

	local Death = {}
	Death.Attacker 			= 	Attacker
	Death.Victim			=	Victim
	Death.time				=	RealTime()
	
	Death.times				= 1
	Death.Citizen			= false

	local Attacker_text = language.GetPhrase(Attacker or "")
	if Attacker_text:sub(1,1)=='#' then
		Attacker_text=Attacker_text:gsub("^#",""):gsub("_"," ")
	end
	
	local Victim_text = language.GetPhrase(Victim or "")

	if string.find(Victim_text, "lua_npc_wander") then
		Victim_text = string.gsub(Victim_text, "lua_npc_wander", "")
		Death.Citizen = true
		Death.CitizenText = { math.random(0, 1), table.Random(CitizenKillText)}
	end
	if Victim_text:sub(1,1)=='#' then
		Victim_text=Victim_text:gsub("^#",""):gsub("_"," ")
	end
	
	Death.left		= 	Attacker_text
	Death.right		= 	Victim_text --.. " @ " .. Death.	VictimLocation
	Death.icon		=	Inflictor
	
	if ( team1 == -1 ) then Death.color1 = table.Copy( NPC_Color )
	else Death.color1 = table.Copy( team.GetColor( team1 ) ) end
		
	if ( team2 == -1 ) then Death.color2 = table.Copy( NPC_Color )
	else Death.color2 = table.Copy( team.GetColor( team2 ) ) end
	
	if (Death.left == Death.right) then
		Death.left = nil
		Death.icon = "farewell Cruel World"
	end

	if not cache[Attacker or ""] then
		cache[Attacker or ""] = {}
	end

	if not cache[Attacker or ""][Victim or ""] then
		cache[Attacker or ""][Victim or ""] = {}
	end

	cache[Attacker or ""][Victim or ""][Inflictor or ""] = Death
	table.insert( Deaths, Death )

end

local margin = 16
local space = 8
local text_height = 32
local txtcache={}
local function DrawDeath( x, y, info, hud_deathnotice_time )

	x = ScrW() - margin

	surface.SetAlphaMultiplier(( info.time + hud_deathnotice_time ) - RealTime())
	surface.SetFont("DeathNotice")
	if info.Citizen then
		local line = info.CitizenText[2]

		local scale = math.max(1.25, 100 + (info.time + 0.1 - RealTime()) * 500)
		local scale2 = math.max(y, ScrH() - (info.time + 0.1 - RealTime()))
		local mx = Matrix()
		mx:Translate(info.CitizenText[1] == 1 and Vector(x - surface.GetTextSize(line) - 32.5, y + 20, 1) or Vector(x - surface.GetTextSize(line) - 25, y - 25, 1))
		mx:Scale(Vector(scale, scale, 1.25))
		mx:Rotate(info.CitizenText[1] == 1 and Angle(0, -25, 0) or Angle(0, 10, 0))

		x = x - surface.GetTextSize(line) - space

		cam.PushModelMatrix(mx)
			surface.SetTextPos(2, 2)
			surface.SetTextColor(color_black)
			surface.DrawText(line)

			surface.SetTextPos(0, 0)
			surface.SetTextColor(color_white)
			surface.DrawText(line)
		cam.PopModelMatrix()
	else
		if info.times > 1 then
			local line = "x " .. info.times
	
			local scale = math.max(1, 1 + (info.time + 0.1 - RealTime())/0.1)
			local mx = Matrix()
			mx:Translate(Vector(x - surface.GetTextSize(line), y, 1))
			mx:Scale(Vector(scale, scale, 1))
	
			x = x - surface.GetTextSize(line) - space
	
			cam.PushModelMatrix(mx)
				surface.SetTextPos(2, 2)
				surface.SetTextColor(color_black)
				surface.DrawText(line)
	
				surface.SetTextPos(0, 0)
				surface.SetTextColor(color_white)
				surface.DrawText(line)
			cam.PopModelMatrix()
		end
	end

	if CustomDeaths[info.left] then
		x = x - draw.SimpleText("", "DeathNotice", x, y, info.color2, TEXT_ALIGN_RIGHT ) - space
	else
		x = x - draw.SimpleText(info.right, "DeathNotice", x, y, info.color2, TEXT_ALIGN_RIGHT ) - space
	end

	local a = 64 + 64 * math.abs(math.sin((RealTime() - info.time)*8))
	local txt = txtcache[info.icon]
	if not txt then
		local copy =  weapons.Get(info.icon)
		local phrase = language.GetPhrase(info.icon)
		
		if phrase == info.icon then
			
			phrase=phrase:gsub("^weapon_","")
			phrase=phrase:gsub("_"," ")
			phrase=phrase:gsub("^.",function(s) return string.upper(s) end)
		end
		
		txt = phrase=="" and "killed" or "[" .. (copy and copy.PrintName or phrase) .. "]"
		txtcache[info.icon] = txt
	end
	if CustomDeaths[info.left] then
		x = x - draw.SimpleText(string.format(CustomDeaths[info.left], info.right), "DeathNotice", x, y, info.color2, TEXT_ALIGN_RIGHT ) - space
	else
		draw.SimpleText(txt, "DeathNotice", x + 2, y + 2, color_black, TEXT_ALIGN_RIGHT )
		x = x - draw.SimpleText(txt, "DeathNotice", x, y, Color(255, a, a), TEXT_ALIGN_RIGHT ) - space
	end

	if CustomDeaths[info.left] then
		info.case = info.case and info.case or math.random(700, 7000)
		x = x - draw.SimpleText("Murder Case #" .. info.case .. ":",  "DeathNotice", x, y, Color(255, a, a, 255), TEXT_ALIGN_RIGHT ) - space
	elseif info.left then -- we actually have a killer, right??
		x = x - draw.SimpleText(info.left, "DeathNotice", x, y, info.color1, TEXT_ALIGN_RIGHT ) - space
	end

	surface.SetAlphaMultiplier(1)
	
	return (y + text_height)

end


function GM:DrawDeathNotice( x, y )

	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = ScrW() - margin
	y = margin
	
	-- Draw
	for k, Death in pairs( Deaths ) do

		if (Death.time + hud_deathnotice_time > RealTime()) then
	
			if (Death.lerp) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		
		end
		
	end
	
	-- We want to maintain the order of the table so instead of removing
	-- expired entries one by one we will just clear the entire table
	-- once everything is expired.
	for k, Death in pairs( Deaths ) do
		if (Death.time + hud_deathnotice_time > RealTime()) then
			return
		end
	end
	
	Deaths = {}
	cache = {}

end

usermessage.Hook( "PlayerKilledByPlayer", function( message )
	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();

	if ( !IsValid( attacker ) ) then return end
	if ( !IsValid( victim ) ) then return end
			
	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team() )
end)


usermessage.Hook( "PlayerKilledSelf", function( message )
	local victim 	= message:ReadEntity();
	if ( !IsValid( victim ) ) then return end
	GAMEMODE:AddDeathNotice( nil, 0, "farewell Cruel World", victim:Name(), victim:Team() )
end)
	
usermessage.Hook( "PlayerKilled", function( message )
	local victim 	= message:ReadEntity();
	if ( !IsValid( victim ) ) then return end
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
	
	if victim:IsPlayer() then
		GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name() .. "@" .. victim:GetLocation(), victim:Team() )
	else
		GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name() .. "@" .. attacker:GetLocation(), victim:Team() )
	end
end)

usermessage.Hook( "PlayerKilledNPC", function( message )
	local victimtype = message:ReadString();
	local victim 	= "#" .. victimtype;
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();

	--
	-- For some reason the killer isn't known to us, so don't proceed.
	--
	if ( !IsValid( attacker ) ) then return end
			
	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim, -1 )
	
	local bIsLocalPlayer = (IsValid(attacker) and attacker == LocalPlayer())
	
	local bIsEnemy = IsEnemyEntityName( victimtype )
	local bIsFriend = IsFriendEntityName( victimtype )
	
	if ( bIsLocalPlayer and bIsEnemy ) then
		achievements.IncBaddies();
	end
	
	if ( bIsLocalPlayer and bIsFriend ) then
		achievements.IncGoodies();
	end
	
	if ( bIsLocalPlayer and (!bIsFriend and !bIsEnemy) ) then
		achievements.IncBystander();
	end
end)

usermessage.Hook( "NPCKilledNPC", function( message )
	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
			
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim, -1 )
end)

if me then
	for i = 1, 100 do
		GAMEMODE:AddDeathNotice( "Test", -1, "wow", "Test2 @ Spawning Area", -1 )
		GAMEMODE:AddDeathNotice( "Test", -1, "wow", "Test1 @ Spawning Area", -1 )
	end
end

end)