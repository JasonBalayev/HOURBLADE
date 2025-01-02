local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")

local customSwords = serverStorage.CustomSwords
local banHammer = customSwords.BanHammer

local mods = {} --"String: Roblox username"
local customOwners = {} --"String: Roblox username"

players.PlayerAdded:Connect(function(player)
	if table.find(customOwners, player.Name) then
		local sword = customSwords[player.Name]

		sword:Clone().Parent = player.Backpack
		sword:Clone().Parent = player.StarterGear
	end
	
	if table.find(mods, player.Name) then
		banHammer:Clone().Parent = player.Backpack
		banHammer:Clone().Parent = player.StarterGear
	end
end)