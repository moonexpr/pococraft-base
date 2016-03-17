local META = FindMetaTable("Player")

function META:GetMoney()
	if SERVER then
	if tonumber(self:GetPData("player_money", 100)) < 0 then self:SetPData("player_money", 0) end
	self:SetNWInt("money", self:GetPData("player_money")) end
	return tonumber(self:GetNWInt("money"))
end

function META:CanAfford(price)
	return price <= self:GetMoney()
end

function META:TransferMoney(ply,num)
	if ply:IsBot() or not ply:IsPlayer() or ply == self then return false end
	if self:GetMoney() < num then num = self:GetMoney() end

	if SERVER then
		if num <= 0 then return false end
		self:TakeMoney(num)
		ply:GiveMoney(num)
	end
	hook.Run("transfermoney", self,ply,num)
end

function META:SetMoney(num)
	if SERVER then
		self:SetPData("player_money",num)
		self:SetNWInt("money", self:GetPData("player_money"))
	end
	hook.Run("setmoney", self,num)
end

function META:GiveMoney(num)
	if SERVER then
		self:SetPData("player_money",self:GetPData("player_money", 100) + num )
		self:SetNWInt("money", self:GetPData("player_money"))
	end
	hook.Run("givemoney", self,num)
end

function META:TakeMoney(num)
	if SERVER then
		if self:GetMoney() < 0 then return end
		self:SetPData("player_money",self:GetPData("player_money", 100) - num )
		self:SetNWInt("money", self:GetPData("player_money"))
		self:GetMoney()
	end
	hook.Run("takemoney", self,num)
end

function META:SaveMoney()
	self:SetPData("player_money", self:GetPData("player_money")) --useless code but yolo
end

function META:LoadMoney()
	if SERVER then self:SetNWInt("money", self:GetPData("player_money")) end
end

function META:Katching()
	self:EmitSound("ambient/levels/labs/coinslot1.wav")
end

function META:PayMoney(price)
	self:SetCoins(self:GetCoins()-price)
end

hook.Add("PlayerDisconnected","money_save",function(ply)
	if CLIENT then return end
	ply:SaveMoney()
	MsgN("Money saved for disconnected player: "..ply:Name())
end)

hook.Add("PlayerInitialSpawn","money_load",function(ply)
	ply:LoadMoney()
end)

hook.Add("transfermoney","fbox_transfermoney_notice",function(sender,receiver,num)
	sender:PrintMessage(3,"You gave "..receiver:GetName().." $"..num)
	receiver:PrintMessage(3,sender:GetName().." gave you $"..num)
	receiver:Katching()
	sender:Katching()
end)

hook.Add("givemoney","givemoney",function(ply,num)
	ply:Katching()
end)

hook.Add("takemoney","takemoney",function(ply,num)
	ply:Katching()
end)

hook.Add("setmoney","setmoney",function(ply,num)
	ply:Katching()
end)



--if SERVER then
--	aowl.AddCommand("transfermoney", function(ply,line,target)
--		target = easylua.FindEntity(target)
--		local amount = tonumber(string.sub(line,string.find(line,",")+1))
--		if not isnumber(amount) or not IsValid(target) then return "Invalid target or amount." end
--		ply:TransferMoney(target,amount)
--	end, "players")
--end
