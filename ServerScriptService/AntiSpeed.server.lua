------------------
-- Made by TetraAdur --
------------------

local speedSettings = {
	maxSpeed = 40,
	allowedTime = 2,
	checkInterval = 0.2	
}

local Players = game:GetService("Players")
local overSpeedTimes = {}
local previousPositions = {}

local function getRootPart(character)
	if not character then return end
	return character:FindFirstChild("HumanoidRootPart")
end

while true do 
	for _, player in pairs(Players:GetPlayers()) do
		local character = player.Character
		local rootPart = getRootPart(character)
		
		if rootPart then
			local currentPos = rootPart.Position
			local previousPos = previousPositions[player]
			if previousPos then
				local distance  = (currentPos - previousPos).Magnitude
				local speed = distance / speedSettings.checkInterval
				if speed > speedSettings.maxSpeed then
					overSpeedTimes[player] = (overSpeedTimes[player] or 0) + speedSettings.checkInterval
				else 
					overSpeedTimes[player] = 0
				end
				
				if (overSpeedTimes[player] or 0) >= speedSettings.allowedTime then
					player:Kick(
						"Kicked for Exploiting")
					:format(speedSettings.maxSpeed, speedSettings.allowedTime)
				end
			end
			previousPositions[player] = currentPos
		end
	end
	wait(speedSettings.checkInterval)
end
