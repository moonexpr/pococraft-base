ENT.Base 					= "base_entity"
ENT.Type 					= "brush"
ENT.Author					= "Potatofactory"
ENT.PrintName 				= "Trigger"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

if SERVER then
	function ENT:Initialize()
		self:SetSolid( SOLID_BBOX )
		self:SetTrigger( true )
		self.Touching = {}
		self.AreaData = -- Modify trigger variables after spawning
		{
			["Name"] = "Unknown",
			["Parent"] = false,
			["Ambience"] = nil,
			["Building"] = true,
			["Announce"] = false,
			["UserGroupRestricted"] = nil,
			["StartTouchCallback"] = nil,
			["EndTouchCallback"] = nil,
		}
	end
	function ENT:StartTouch( ent )
		self.Touching[ent:EntIndex()] = ent
		local function compileGroups(tab, ignore)
			local str = ""
			for k, char in pairs(tab) do
				if k == 1 then
					str = char
				elseif k == #tab then
					str = str .. " or " ..  char
				else
					str = str .. ", " ..  char
				end
			end
			return string.lower(str)
		end
		if self.AreaData["StartTouchCallback"] then
			self.AreaData["StartTouchCallback"]( ent )
		end
		
		if self.AreaData["Parent"] then
			ent:SetNWEntity("IgnoreParentTrigger", self.AreaData["Parent"])
		end
		if ent:GetNWEntity("IgnoreParentTrigger") ~= self then
			ent:SetLocation(self)
		end

		if ent:IsPlayer() then
			if self.AreaData["UserGroupRestricted"] and not table.HasValue(self.AreaData["UserGroupRestricted"], ent:GetUserGroup() == "manager_dev" and "manager" or ent:GetUserGroup()) then
				ent:Kill()
				if not ULib.ucl.groups[self.AreaData["UserGroupRestricted"][1]] then
					ent:Notify(10, "error", self.AreaData["UserGroupRestricted"][1])
				else
					ent:Notify(2, "error", "You're not allowed to enter " .. self.AreaData["Name"] .. " :(")
					ent:Notify(5, "error", "You must be apart of " .. compileGroups(self.AreaData["UserGroupRestricted"]) .. " ")
				end
				return
			end
			if self.AreaData["Announce"] then
				if isstring(self.AreaData["Announce"]) then
					ent:Notify(5, "hint", self.AreaData["Announce"])
				else
					ent:Notify(5, "hint", "Now entering " .. self.AreaData["Name"] .. "...")
				end
				if not self.AreaData["Building"] then
					ent:Notify(5, "error", "Building is outlawed in this area!")
				end
			end
			if self.AreaData["Ambience"] then
				net.Start("TriggerEvent:AmbientToggle")
					net.WriteString( self.AreaData["Ambience"] )
					net.WriteBool( true )
				net.Send(ent)
			end
		elseif not self.AreaData["Building"] and ent:CPPIGetOwner() and not ent:CPPIGetOwner():IsAdmin() and not ent:IsNPC() and ent:GetModel() ~= "models/noesis/donut.mdl" then
			ent:Remove()
		end
	end
	function ENT:EndTouch( ent )
		self.Touching[ent:EntIndex()] = nil
		if self.AreaData["EndTouchCallback"] then
			self.AreaData["EndTouchCallback"]( ent )
		end
		if self.AreaData["Parent"] then
			ent:SetNWEntity("IgnoreParentTrigger", nil)
		end

		if ent:IsInWorld() then
			if self.AreaData["Parent"] and table.HasValue(self.AreaData["Parent"].Touching, ent) then
				ent:SetLocation(self.AreaData["Parent"])
			end
		else
			ent:SetLocation("The Void")
		end

		if ent:IsPlayer() then
			--print(ent:Nick() .. ": " .. tostring(table.HasValue(self.AreaData["Parent"].Touching, ent)))
			if self.AreaData["Ambience"] then
				net.Start("TriggerEvent:AmbientToggle")
					net.WriteString( self.AreaData["Ambience"] )
					net.WriteBool( false )
				net.Send(ent)
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		return 
	end
end