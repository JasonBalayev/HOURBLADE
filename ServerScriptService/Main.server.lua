local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local serverScript = game:GetService("ServerScriptService")

local serverMultiplyer = serverStorage:WaitForChild("ServerScoreMultiplyer")

local activeManager = require(serverScript:WaitForChild("Data2"):WaitForChild("ActiveManager"))

while true do
	for _, player in pairs(players:GetPlayers()) do
		local character = player.Character

		if not character or not character:FindFirstChildOfClass("Humanoid") then
			continue
		end
		
		local edits = {}
		
		local multiplyer = player.Multiplier.Value * serverMultiplyer.Value
		
		if character.Humanoid.Health > 0 then
			if player:FindFirstChild("Safe") and not player:FindFirstChild("Safe").Value then
				table.insert(edits, {path = "Time.data", method = "add", data = multiplyer})
				table.insert(edits, {path = "Experience.data", method = "add", data = multiplyer})
			else 
				multiplyer = 0
			end
		end
		
		if (player.leaderstats.Time.Value + multiplyer) > player.leaderstats["Best Time"].Value then
			table.insert(edits, {path = "Best Time.data", method = "set", data = (player.leaderstats.Time.Value + multiplyer)})
		end
		
		if #edits > 0 then
			activeManager:edit(player.UserId, edits)
		end
	end

	wait(1)
end