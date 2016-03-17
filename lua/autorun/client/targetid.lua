hook.Add("PostGamemodeLoaded", "ReplaceTargetID", function()
	surface.CreateFont( "NewTargetID", {
		font = "Akbar", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		size = 25,
		weight = 100,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	} )

	ExtendedFriendlies = {
		"lua_npc_wander",
		"npc_tf2_ghost",
		"npc_crow",
		"npc_pigeon",
		"npc_seagull",
	}

	local available = {
		"╜","▓","ì","╛","φ","ï","₧","←",

		"≥","╜","╔","ƒ","Ω","‼","┌","÷",

		"¢","¿"
	}
	function compilestring(tab)
		local str = ""
		for _, char in pairs(tab) do
			str = str .. char
		end
		return str
	end

	function GAMEMODE:HUDDrawTargetID()

		local tr = util.GetPlayerTrace( LocalPlayer() )
		local trace = util.TraceLine( tr )
		if ( !trace.Hit ) then return end
		if ( !trace.HitNonWorld ) then return end
		
		local text = "ERROR"
		local font = "NewTargetID"
		
		if trace.Entity:IsPlayer() then
			if not SigmaData then
				LocalPlayer():ConCommand("cl_sigma_refresh")
				return
			end
			local ent = trace.Entity
			if IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon():GetClass() == "weapon_mortar" then
				local name = ent:Nick()
				bstr = {}
				name:gsub(".", function(c) table.insert(bstr, c) end)
				bstr[math.random(1, #bstr)] = table.Random(available)
				text = compilestring(bstr)
			else
				text = color.gsub(trace.Entity:Nick())
			end
			
			sigma = SigmaData[trace.Entity:SteamID64()] and SigmaData[trace.Entity:SteamID64()]
				or arrUsergroupProperties[trace.Entity:GetUserGroup()][2] and arrUsergroupProperties[trace.Entity:GetUserGroup()][2] or
				trace.Entity:GetUserGroup()
			
			if string.len(sigma) > 150 then
				sigma = arrUsergroupProperties[trace.Entity:GetUserGroup()][2] and arrUsergroupProperties[trace.Entity:GetUserGroup()][2] or
				trace.Entity:GetUserGroup()
			end

			if ent:Health() > ent:GetMaxHealth() then
				fcolor = HSVToColor(math.abs(math.sin(CurTime() * .9) * 335), 1, 1)
			else
				local lerp = ent:Health() / ent:GetMaxHealth()
				local vecColor = arrUsergroupProperties[ent:GetUserGroup()][1] or GAMEMODE:GetTeamColor(ent) or Color( 255, 255, 255)
				--local vecColor = GAMEMODE:GetTeamColor(ent) or Color( 255, 255, 255)
				fcolor = Color(vecColor.r * lerp, vecColor.g * lerp, vecColor.b * lerp)
			end
		elseif trace.Entity:GetClass() == "lua_npc_administrator" then
				text = trace.Entity:GetNWString("CitizenName")
				sigma = "Population Control Committee"
				fcolor = Color(200, 0, 100)
		elseif trace.Entity:GetClass() == "lua_npc_wander" then
			if trace.Entity:GetNWString("CitizenName") == "G-Man" then
				local name = "gman"
				bstr = {}
				name:gsub(".", function(c) table.insert(bstr, c) end)
				for i=1,20 do
					bstr[math.random(1, #bstr)] = table.Random(available)
				end
				text = compilestring(bstr)
				sigma = "Unknown"
				fcolor = Color(255, 255 * VectorRand().X, 255 * VectorRand().Z)
			elseif string.find(trace.Entity:GetNWString("CitizenName"), "Alien Citizen:") then
				text = string.gsub(trace.Entity:GetNWString("CitizenName"), "Alien Citizen:", "")
				sigma = "Alien Citizen"
				fcolor = Color(0, 255, 0)
			elseif trace.Entity:GetNWBool("Transferred", false) then
				text = trace.Entity:GetNWString("CitizenName")
				sigma = "Transferred Citizen"
				fcolor = Color(0, 200, 0)
			else
				text = trace.Entity:GetNWString("CitizenName")
				sigma = "Registered Citizen"
				fcolor = Color(0, 200, 0)
			end		
		elseif trace.Entity:IsNPC() then
			local ent = trace.Entity
			local cname = ent.PrintName or ent:GetClass()
			local formatted = {}
			
			sigma = ""
			
			for key, str in pairs(string.Explode("_", string.gsub(cname, "npc_", ""))) do
				formatted[key] = str:gsub( "^%l", string.upper )
			end
			text = string.Implode( " ", formatted )
			if IsFriendEntityName(cname) or table.HasValue(ExtendedFriendlies, cname) then
				fcolor = Color(200 - (ent:Health() / ent:GetMaxHealth() * 200), (ent:Health() / ent:GetMaxHealth() * 200), 0)
			else
				fcolor = Color(ent:Health() / ent:GetMaxHealth() * 255, 0, 0)
			end
		else
			return
			--text = trace.Entity:GetClass()
		end
		
		surface.SetFont( font )
		
		if not sigma then sigma = "" end
		
		local w1, h1 = surface.GetTextSize( text )
		local w2, h2 = surface.GetTextSize( sigma )
		
		local MouseX, MouseY = gui.MousePos()
		
		if ( MouseX == 0 && MouseY == 0 ) then
		
			MouseX = ScrW() / 2
			MouseY = ScrH() / 2
		
		end
		
		draw.SimpleText( text, font, MouseX - w1 / 2, MouseY + 30, fcolor )
		draw.SimpleText( sigma, font, MouseX - w2 / 2, MouseY + 50, Color(200, 200, 200) )

	end
end )