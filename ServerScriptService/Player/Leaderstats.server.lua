local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local marketplaceService = game:GetService("MarketplaceService")

local playerData = serverStorage.PlayerData

players.PlayerAdded:Connect(function(player)
	local safe = Instance.new("BoolValue")
	safe.Name = "Safe"
	safe.Parent = player
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local time = Instance.new("IntValue")
	time.Name = "Time"
	time.Parent = leaderstats
	
	local bestTime = Instance.new("IntValue")
	bestTime.Name = "Best Time"
	bestTime.Parent = leaderstats
	
	local level = Instance.new("IntValue")
	level.Value = 1
	level.Name = "Level"
	level.Parent = leaderstats
	
	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Parent = leaderstats
	
	local playerFolder = Instance.new("Folder")
	playerFolder.Name = player.Name
	playerFolder.Parent = playerData
	
	local multiplier = Instance.new("IntValue")
	multiplier.Value = 1
	multiplier.Name = "Multiplier"
	multiplier.Parent = playerFolder
	
	local inventory = Instance.new("Folder")
	inventory.Name = "Inventory"
	inventory.Parent = playerFolder
	
	local experience = Instance.new("IntValue")
	experience.Name = "Experience"
	experience.Parent = playerFolder
	
	time:GetPropertyChangedSignal("Value"):Connect(function()
		if time.Value > bestTime.Value then
			bestTime.Value = time.Value
		end
	end)
end)

players.PlayerRemoving:Connect(function(player)
	delay(2, function()
		serverStorage.PlayerData[player.Name]:Destroy()
	end)
end)