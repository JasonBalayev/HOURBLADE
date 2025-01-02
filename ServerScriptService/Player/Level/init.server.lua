local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local serverScript = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local playerRequirements = require(script.Requirements)
local activeManager = require(serverScript:WaitForChild("Data2"):WaitForChild("ActiveManager"))

local updateBar = replicatedStorage.Remotes.Level.UpdateBar
local profileLoaded = replicatedStorage.Remotes.ProfileLoaded
local sendInformation = replicatedStorage.Remotes.Level.SendInformation

profileLoaded.Event:Connect(function(player)
	local leaderstats = player.leaderstats
	local playerFolder = player.values

	local level = leaderstats.Level
	local experience = playerFolder.Experience
	
	repeat wait(0.25) until playerRequirements[player.Name]
	
	sendInformation:FireClient(player, level.Value, experience.Value, playerRequirements[player.Name])
	
	experience:GetPropertyChangedSignal("Value"):Connect(function()
		local required = playerRequirements[player.Name]

		if experience.Value >= required then
			local overlevel = experience.Value - playerRequirements[player.Name]
			
			local instructions = {}

			if overlevel >= 0 then
				table.insert(instructions, {path = "Experience.data", method = "set", data = overlevel})
			else
				table.insert(instructions, {path = "Experience.data", method = "set", data = 0})
			end
			
			table.insert(instructions, {path = "Level.data", method = "add", data = 1})
			
			activeManager:edit(player.userId, instructions)

			required = playerRequirements[player.Name]
		end

		updateBar:FireClient(player, level.Value, experience.Value, required)
	end)
end)