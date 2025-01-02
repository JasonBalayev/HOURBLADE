local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")

local activeManager = require(game:GetService("ServerScriptService"):WaitForChild("Data2"):WaitForChild("ActiveManager"))

local function characterAdded(character)
	character.Humanoid.Died:Connect(function()
		local player = players:GetPlayerFromCharacter(character)

		local leaderstats = player.leaderstats
		local time = leaderstats.Time

		if character:FindFirstChildOfClass("ObjectValue") then
			local killer = character:FindFirstChildOfClass("ObjectValue").Value
			
			activeManager:edit(killer.UserId, {
				{path = "Time.data", method = "add", data = time.Value},
				{path = "Kills.data", method = "add", data = 1},
				{path = "Experience.data", method = "add", data = 50},
			})

			if killer.Character then
				local humanoid = killer.Character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid.Health = humanoid.MaxHealth
				end
			end
		end

		activeManager:edit(player.UserId, {
			{path = "Time.data", method = "set", data = 0},
		})

		player.CharacterAdded:Wait()

		player.Safe.Value = true
	end)
end

players.PlayerAdded:Connect(function(player)
	if player.Character then
		characterAdded(player.Character)
	end

	player.CharacterAdded:Connect(characterAdded)
end)