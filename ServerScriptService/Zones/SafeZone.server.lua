local zoneService = require(game:GetService("ReplicatedStorage").Zone)
local safeZone = zoneService.new(workspace.SafeZone)

safeZone:setDetection("Centre")

safeZone.playerEntered:Connect(function(player)
	player:WaitForChild("Safe").Value = true
end)

safeZone.playerExited:Connect(function(player)
	player:WaitForChild("Safe").Value = false
end)