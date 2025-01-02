local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")

local constant = 50
local multiplier = 100

local playerRequirements = {}

local function playerAdded(player)
	local leaderstats = player:WaitForChild("leaderstats")
	
	local level = leaderstats.Level
	
	playerRequirements[player.Name] = constant + level.Value * multiplier
	
	level:GetPropertyChangedSignal("Value"):Connect(function()
		playerRequirements[player.Name] = constant + level.Value * multiplier
	end)
end

for _, player in pairs(players:GetPlayers()) do
	playerAdded(player)
end

players.PlayerAdded:Connect(playerAdded)

return playerRequirements