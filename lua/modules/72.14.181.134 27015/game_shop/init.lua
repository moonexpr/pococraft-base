ModInfo.Name = "Pococraft Shop System"
ModInfo.Author = "Potatofactory"

function TestSuccess()
    return true
end

AddCSLuaFile()

if SERVER then
    _include(ModInfo, "shop/items.lua")

    util.AddNetworkString("PococraftShopBuy")

    net.Receive("PococraftShopBuy", function()
        local item = net.ReadString()
    end)
end