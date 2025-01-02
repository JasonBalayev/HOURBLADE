--[[

Author: ARCHIE0709
Last Modified: 30/12/2024

Description: Manager for Powerups

]]

local settings = {
	maxDrops = 10,
	spawnCooldown = 3, -- Usual 30, changed for testing
	playersPerPowerup = 3,
}

--// Variables
-- Services
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local zoneService = require(game:GetService("ReplicatedStorage").Zone)

-- Remotes
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local powerUpDeletedEvent = remotesFolder:WaitForChild("PowerUpDeleted")

-- Tables
local powerUps = {}

-- Other
local powerUpScript = script:WaitForChild("Powerup")
local dropZone = zoneService.new(workspace:WaitForChild("DropZone"))
local powerUpDrops = workspace:WaitForChild("PowerUpDrops")

local currentDrops = 0


--// Functions
local function TagPowerUps()
	for _, powerUp in pairs(CollectionService:GetTagged("PowerUp")) do
		if powerUp:IsA("Model") then
			table.insert(powerUps, powerUp)
			local newScript = powerUpScript:Clone()
			newScript.Parent = powerUp
			newScript.Enabled = true
		end
	end
end

local function spawnPowerUp()
	local newPowerUp = powerUps[math.random(1, #powerUps)]:Clone()
	local position = dropZone:getRandomPoint()
	newPowerUp:PivotTo(CFrame.new(position + Vector3.new(0, 3, 0)))
	newPowerUp.Parent = powerUpDrops
end


local function dropDeleted()
	currentDrops -= 1
end


--// Main
powerUpDeletedEvent.Event:Connect(dropDeleted)

TagPowerUps()
while true do
	wait(settings.spawnCooldown)
	local numToSpawn = math.ceil(#Players:GetPlayers() / settings.playersPerPowerup)
	while numToSpawn > 0 and settings.maxDrops > currentDrops do
		spawnPowerUp()
		currentDrops += 1
		numToSpawn -= 1
	end
end
