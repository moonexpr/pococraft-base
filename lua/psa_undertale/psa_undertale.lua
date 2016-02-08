-- This script is copyright of !cake, STEAM_0:1:19269760, http://steamcommunity.com/profiles/76561197998805249
-- Undertale is copyright of Toby Fox
-- Undertale audio samples are copyright of Toby Fox

PSA = PSA or {}
PSA.Undertale = PSA.Undertale or {}

PSA.Undertale.Commands = {}
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "psa",       TextStyle = nil       }
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "undertale", TextStyle = nil       }
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "sans",      TextStyle = "Sans"    }
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "papyrus",   TextStyle = "Papyrus" }
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "flowey",    TextStyle = "Flowey"  }
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "toriel",    TextStyle = "Toriel"  }
PSA.Undertale.Commands [#PSA.Undertale.Commands + 1] = { CommandName = "temmie",    TextStyle = "Temmie"  }

include ("ulx.lua")

function PSA.Class (methodTable)
	local metatable = { __index = methodTable }
	
	return function (...)
		local instance = {}
		setmetatable (instance, metatable)
		
		if instance.ctor then
			instance:ctor (...)
		end
		
		return instance
	end
end

if SERVER then
	include ("psa_undertale_sv.lua")
elseif CLIENT then
	include ("psa_undertale_cl.lua")
end