local players = game:GetService("Players")
local serverScript = game:GetService("ServerScriptService")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local marketPlaceService = game:GetService("MarketplaceService")

local requirements = require(script.Requirements)

local swords = serverStorage.Swords

local activeManager = require(serverScript:WaitForChild("Data2"):WaitForChild("ActiveManager"))

local remotes = replicatedStorage.Remotes.Inventory

local ownsPass = remotes.OwnsPass
local equipSword = remotes.EquipSword
local unequipSword = remotes.UnequipSword
local passPurchased = remotes.PassPurchased

ownsPass.OnServerInvoke = function(player, name)
	if requirements[name] then
		return marketPlaceService:UserOwnsGamePassAsync(player.UserId, requirements[name][2])
	end
end

equipSword.OnServerInvoke = function(player, name)
	if not requirements[name] then
		return false
	end
	
	local stat = requirements[name][1]
	
	activeManager:edit(player.UserId, {{path = ("Equipped.data."..name), method = "set", data = true}})
	swords[stat][name]:Clone().Parent = player.Backpack
	
	return true
end

unequipSword.OnServerInvoke = function(player, name)
	local inventory = activeManager:view(player.UserId, {"Equipped"})[1]
	
	if not requirements[name] or not inventory[name] or not player.Backpack:FindFirstChild(name) then
		return false
	end
	
	if player.Character then
		if player.Character.Humanoid then
			player.Character.Humanoid:UnequipTools()
		end
	end
	
	activeManager:edit(player.UserId, {{path = ("Equipped.data."..name), method = "set", data = false}})
	player.Backpack[name]:Destroy()
	
	return true
end

marketPlaceService.PromptGamePassPurchaseFinished:Connect(function(player, id, purchased)
	if not purchased then
		return
	end
	
	for name, req in pairs(requirements) do
		if req[2] == id then
			passPurchased:FireClient(player, name)
		end
	end
end)

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local inventory = activeManager:view(player.UserId, {"Equipped"})[1]
		for name, equipped in pairs(inventory) do
			if not equipped then continue end
			local stat = requirements[name][1]
			swords[stat][name]:Clone().Parent = player.Backpack
		end
	end)
end)