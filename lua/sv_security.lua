local today = tonumber(os.date("%u", os.time() - 21600))
WeekdayCodes = {
	"", -- Monday
	"", -- Tuesday
	"", -- Wedsday
	"", -- Thursday
	"", -- Friday
	"", -- Saturday
	"", -- Sunday
}
SecurityKey = {
	User 	= WeekdayCodes[today] .. " commit 77",
	Unban 	= WeekdayCodes[today] .. " commit 77",
}

local function ManagersExist()
	local hasManager = false
	for _, ply in pairs(player.GetAll()) do
		if ply:IsSuperAdmin() then
			hasManager = true
		end
	end
	return hasManager
end

local function ManagersCount()
	local count = 0
	for _, ply in pairs(player.GetAll()) do
		if ply:IsSuperAdmin() then
			count = count + 1
		end
	end
	return count
end

function restartPop()
	game.ConsoleCommand("say Good Morning!\n")
	timer.Simple(4, function()
		if ManagersExist() then
			game.ConsoleCommand("say Today's security code is <c=200,0,100>" .. WeekdayCodes[tonumber(os.date("%u", os.time() - 21600))] .."</c>.\n" )
		else
			game.ConsoleCommand("say Today's security code is <c=200,0,100>********</c>.\n" )
		end
		SecurityKey.User = WeekdayCodes[tonumber(os.date("%u", os.time() - 21600))]
		timer.Simple(3, function()
			game.ConsoleCommand("say Restarting pop data...\n" )
			timer.Simple(1, function()
				game.ConsoleCommand("say Remember: Play Smart, Work Hard!\n" )
				for _, ply in pairs(player.GetAll()) do
					ply:Kill()
				end
			end)
		end)
	end)
end

hook.Add("PlayerInitialSpawn", "", function( ply )
	if ManagersCount == 1 then
		restartPop()
	end
end)

timer.Create("CheckForChange", 30, 0, function()
	if not ManagersExist() then return end
	if today ~= tonumber(os.date("%u", os.time() - 21600)) then
		today = tonumber(os.date("%u", os.time() - 21600))
		restartPop()
	end
end )