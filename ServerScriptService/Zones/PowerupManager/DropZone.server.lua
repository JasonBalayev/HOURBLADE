local zoneService = require(game:GetService("ReplicatedStorage").Zone)
local dropZone = zoneService.new(workspace.DropZone)

local timeDrops = game:GetService("ServerStorage").TimeDrops:GetChildren()

local function spawnDrop()
	local drop = timeDrops[math.random(1, #timeDrops)]:Clone()
	local position, touchingParts = dropZone:getRandomPoint()

	drop.Handle.CFrame = CFrame.new(position + Vector3.new(0, 10, 0))
	drop.Parent = workspace
end

while true do
	wait(20)
	
	local dropCount = 0
	
	for _, child in pairs(workspace:GetChildren()) do
		if child:IsA("Tool") then
			dropCount += 1
		end
	end
	
	if dropCount < #game:GetService("Players"):GetPlayers() then
		spawnDrop()
	end
end