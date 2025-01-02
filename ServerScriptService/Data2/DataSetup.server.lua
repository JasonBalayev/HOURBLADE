--[[

Author: ARCHIE0709
Last Edited: 31/12/2024
Description: Handles setup and ongoing calls for DataManager

]]

local settings = {
	leaderboardUpdatePeriod = 120, -- Time in seconds between leaderboard updates
}

--// Variables
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

-- Modules
local data2 = ServerScriptService:WaitForChild("Data2")
local dataManager = require(data2:WaitForChild("DataManager"))
local activeManager = require(data2:WaitForChild("ActiveManager"))

-- Events
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local profileLoaded = remotes:WaitForChild("ProfileLoaded")

-- Functions
local viewInventory = remotes:WaitForChild("Inventory"):WaitForChild("ViewInventory")

-- Bindables
local dataBindables = ServerStorage:WaitForChild("Bindables"):WaitForChild("Data")
local incrementLeaderboard = dataBindables:WaitForChild("SetLeaderboard")


--// Functions
local function playerAdded(player)
	dataManager:addPlayer(player)
	profileLoaded:Fire(player)
end

local function playerRemoving(player)
	dataManager:removePlayer(player)
end

local function incrememnt(userId, boardName, value)
	dataManager:SetLeaderboard(userId, boardName, value)
end


viewInventory.OnServerInvoke = function(player)
	return activeManager:view(player.UserId, {"Equipped"})
end


--// Main
Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

incrementLeaderboard.Event:Connect(incrememnt)


task.wait(1)
while true do
	dataManager:UpdateLeaderboards()
	task.wait(settings.leaderboardUpdatePeriod)
end
