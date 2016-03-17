local last = 0
local function gp2Callback( ply, cmd, args ) 
	if last > CurTime() then return end
	if args[1] == "up" then
		local tr = util.TraceLine( {
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() + Vector( 0, 0, 9999999),
			mask = MASK_BLOCKLOS,
		} )
		x = tr.HitPos.X
		y = tr.HitPos.Y
		z = tr.HitPos.Z
	elseif args[1] == "down" then
		local tr = util.TraceLine( {
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() - Vector( 0, 0, 9999999),
			mask = MASK_BLOCKLOS,
		} )
		x = tr.HitPos.X
		y = tr.HitPos.Y
		z = tr.HitPos.Z
	elseif args[1] == "aim" then
		local tr = LocalPlayer():GetEyeTrace()
		x = tr.HitPos.X
		y = tr.HitPos.Y
		z = tr.HitPos.Z
	else
		x = LocalPlayer():GetPos().X
		y = LocalPlayer():GetPos().Y
		z = LocalPlayer():GetPos().Z
	end

	local niceangle = LocalPlayer():EyeAngles()--:SnapTo("y", 45)
	--niceangle.p = 0	
	
	--LocalPlayer():SetEyeAngles(niceangle)
	last = CurTime() + 1 -- Prevent spam
	chat.AddText(string.format("Vector( %f, %f, %f ), Angle( %i, %i, %i )", x, y, z, niceangle.p, niceangle.y, niceangle.r))
end

local blacklist = {
	"DMenuBar",
	"DMenu",
	"SpawnMenu",
	"ContextMenu",
	"ControlPanel",
	"CGMODMouseInput",
	"Panel",
}

local lightblacklist = {
	"scoreboard",
	"f1",
	"f2",
	"f3",
	"f4",
	"playx",
	"gcompute",
	"xgui",
	"pac",
	"DMenuBar",
	"chatbox",
	"ContextMenu",
	"ControlPanel",
	"SpawnMenu",
	"ContextMenu",
}

local function VGUICleanup()
	local sum = 0
	for _,pnl in next,vgui.GetWorldPanel():GetChildren() do
		if not IsValid(pnl) then continue end
		local name = pnl:GetName()
		local class = pnl:GetClassName()
		local hit_blacklist = false
		if blacklist[class] then continue end
		if blacklist[name] then continue end
		for _,class in next,lightblacklist do
			if name:lower():match(class:lower()) then
				hit_blacklist = true
				continue
			end
		end
		if hit_blacklist then continue end
		Msg("[vgui] ") print("Removed " .. tostring(pnl))
		pnl:Remove()
		sum = sum + 1
	end
	Msg("[vgui] ") print("Total panels removed: " .. sum)
end

concommand.Add( "vgui_cleanup", VGUICleanup )
concommand.Add( "getpos2", gp2Callback )