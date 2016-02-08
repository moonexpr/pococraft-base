easylua.StartEntity("trigger_lua")

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
		self.AreaData = -- Modify trigger variables after spawning
		{
			["Name"] = "Unknown",
			["Ambience"] = nil,
			["Building"] = true,
			["UserGroupRestricted"] = nil,
			["StartTouchCallback"] = nil,
			["EndTouchCallback"] = nil,
		}
	end
	function ENT:StartTouch( ent )
		if self.AreaData["StartTouchCallback"] then
			self.AreaData["StartTouchCallback"]( ent )
		end
		if ent:IsPlayer() then
			ent:SetLocation(self.AreaData["Name"])
			if self.AreaData["UserGroupRestricted"] and not table.HasValue(self.AreaData["UserGroupRestricted"], ent:GetUserGroup()) then
				ent:Spawn()
				ent:Notify(10, "error", "This is an administator only area. :(")
				return
			end
			if self.AreaData["Ambience"] then
				net.Start("TriggerEvent_SafeZone")
					net.WriteString( self.AreaData["Ambience"] )
					net.WriteBool( true )
				net.Send(ent)
			end
		elseif ent:CPPIGetOwner() or ent:IsNPC() and self.AreaData["Building"] then
			ent:Remove()
		end
	end
	function ENT:EndTouch( ent )
		local function FindOutsideBox()
			local total_ents = ents.FindInSphere(ent:GetPos(), 2)
			for num, _ent in pairs(total_ents) do
				if _ent:GetClass() == "trigger_lua" and _ent.AreaData["Name"] ~= self.AreaData["Name"] then
					return _ent.AreaData["Name"]
				elseif num == #total_ents then
					return "Unknown"
				end
			end
		end
		if self.AreaData["EndTouchCallback"] then
			self.AreaData["EndTouchCallback"]( ent )
		end
		if ent:IsPlayer() then
			ent:SetLocation(FindOutsideBox())
			if self.AreaData["Ambience"] then
				net.Start("TriggerEvent_SafeZone")
					net.WriteString( self.AreaData["Ambience"] )
					net.WriteBool( false )
				net.Send(ent)
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		return false
	end
end

easylua.EndEntity(false, false)