local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local profileLoaded = replicatedStorage.Remotes.ProfileLoaded
local sendRequirements = replicatedStorage.Remotes.Inventory.SendRequirements

local requirements = {}

for _, sword in pairs(serverStorage.Swords:GetDescendants()) do
	local req = sword:FindFirstChildOfClass("IntValue")
	
	if req then
		requirements[sword.Name] = {req.Name, req.Value}
	end
end

profileLoaded.Event:Connect(function(player)
	sendRequirements:FireClient(player, requirements)
end)

return requirements