local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local zoneService = require(game:GetService("ReplicatedStorage").Zone)

local tripleZone = zoneService.new(workspace.TripleZone)

local playerData = serverStorage.PlayerData

tripleZone:setDetection("Centre")

tripleZone.playerEntered:Connect(function(player)
	player.Multiplier.Value *= 2
end)

tripleZone.playerExited:Connect(function(player)
	player.Multiplier.Value /= 2
end)