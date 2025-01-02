local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local dataStoreService = game:GetService("DataStoreService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local killsData = dataStoreService:GetOrderedDataStore("KillsData")
local bestTimeData = dataStoreService:GetOrderedDataStore("BestTimeData")
local levelData = dataStoreService:GetOrderedDataStore("LevelData")

local dataManager = require(game:GetService("ServerScriptService").Data.Manager)

local profileLoaded = replicatedStorage.Remotes.ProfileLoaded

coroutine.wrap(function()
	while true do
		wait(60)

		if game:GetService("RunService"):IsStudio() then
			continue
		end

		coroutine.wrap(function()
			for _, player in pairs(players:GetPlayers()) do
				local leaderstats = player:FindFirstChild("leaderstats")

				if not leaderstats then
					continue
				end

				local bestTime = leaderstats["Best Time"].Value
				local kills = leaderstats.Kills.Value
				local level = leaderstats.Level.Value

				pcall(function()
					bestTimeData:UpdateAsync(player.UserId, function(oldData)
						if not oldData then
							return bestTime
						elseif bestTime <= oldData then
							return nil
						end

						return bestTime
					end)
				end)

				pcall(function()
					killsData:UpdateAsync(player.UserId, function(oldData)
						if not oldData then
							return kills
						elseif kills <= oldData then
							return nil
						end

						return kills
					end)
				end)

				pcall(function()
					levelData:UpdateAsync(player.UserId, function(oldData)
						if not oldData then
							return level
						elseif level <= oldData then
							return nil
						end

						return level
					end)
				end)

				wait(1)
			end
		end)()
	end
end)()

profileLoaded.Event:Connect(function(player)
	local profile = dataManager[player]
	local leaderstats = player.leaderstats

	local experience = serverStorage.PlayerData[player.Name].Experience

	for _, stat in pairs(leaderstats:GetChildren()) do
		stat:GetPropertyChangedSignal("Value"):Connect(function()
			profile.Data[stat.Name] = stat.Value
		end)
	end

	experience:GetPropertyChangedSignal("Value"):Connect(function()
		profile.Data.Experience = experience.Value
	end)
end)