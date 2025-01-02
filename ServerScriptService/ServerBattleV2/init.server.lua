--[[

Author: 	ARCHIE0709
Date: 		26/12/24
Last Edit:	26/12/24

Description: Handler for server battles

]]

--// Settings
local settings = {
	roundCooldown = 120,
	minPlayers = 2,
	roundLength = 90,
	
	winTime = 350,
	drawTime = 125,
}

--// Variables
-- Services
local players = game:GetService("Players")
local serverScript = game:GetService("ServerScriptService")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local zoneService = require(game:GetService("ReplicatedStorage").Zone)

-- Modules
local activeManager = require(serverScript:WaitForChild("Data2"):WaitForChild("ActiveManager"))

-- Remotes
local remotes = replicatedStorage.Remotes.ServerBattle
local playersInMinigame = remotes:WaitForChild("PlayersInGame")

local promptPlayer = remotes.PromptPlayer
local updateStatus = remotes.UpdateStatus
local toggleStatus = remotes.ToggleStatus


-- Workspace
local lobby = game.Workspace:WaitForChild("Lobby")
local lobbyCenter = lobby:WaitForChild("LobbyCenter")


-- Tables
local times = {}
local contestants = {}

-- Other
local joiningClosed = true


--// Functions
-- General
local function removePlayerFromContestants(player)
	local index = table.find(contestants, player)
	if index then
		table.remove(contestants, index)
	end
end

local function toggleBattleSettings(player, state) -- state: true for entering arena, false for leaving arena
	player.Character.Head.Display.Enabled = not state
	player.PlayerGui.SafeGui.Enabled = not state
	player.PlayerGui.LobbyGui.Enabled = state
	if state then
		Instance.new("ForceField", player.Character)
	else
		player.Character.ForceField:Destroy()
	end
end

local function countdownRound()
	toggleStatus:FireAllClients(true)
	
	if #players:GetPlayers() < settings.minPlayers then
		repeat
			updateStatus:FireAllClients("⚠️ Not enough players to start a server battle!")
			wait(5)
		until #players:GetPlayers() >= settings.minPlayers
	end
	
	for countdown = settings.roundCooldown, 1, -1 do
		local message = countdown <= 5 
			and ("🔥 Battle starting in " .. countdown .. "!") 
			or ("⚔️ Next Battle: " .. countdown .. " seconds")

		updateStatus:FireAllClients(message)
		wait(1)
	end
	
	toggleStatus:FireAllClients(false)
end

local function promptRound()
	contestants = {}

	joiningClosed = false
	promptPlayer:FireAllClients()

	wait(11)
	joiningClosed = true
	print("Number of contestants after joining closed:", #contestants)

	if #contestants < settings.minPlayers then
		updateStatus:FireAllClients("❌ Not enough contestants joined the battle!")
		for _, contestant in pairs(contestants) do
			toggleBattleSettings(contestant, false)
			contestant:LoadCharacter()
		end
		wait(5)
		print(#contestants)
		return false
	end

	return true
end

local function beginRound()
	times = {}
	
	local map = serverStorage.ServerBattle:Clone()
	local stormZone = zoneService.new(map.Storm)
	map.Parent = workspace
	
	wait(1)
	
	local spawns = map.Spawns:GetChildren()
	if #contestants > #spawns then
		updateStatus:FireAllClients("Not enough spawn points for all players!")
		for _, contestant in pairs(contestants) do
			toggleBattleSettings(contestant, false)
			contestant:LoadCharacter()
		end
		return false
	end
	
	for _, contestant in pairs(contestants) do
		local character = contestant.Character
		local time = contestant.leaderstats.Time
		
		times[contestant] = time.Value
		time.Value = 0
		
		if not character or not character:FindFirstChildOfClass("Humanoid") then
			removePlayerFromContestants(contestant)
			continue
		end
		
		character.Humanoid.Died:Connect(function()
			removePlayerFromContestants(contestant)
		end)
		
		players.PlayerRemoving:Connect(function(player)
			if player == contestant then
				removePlayerFromContestants(player)
			end
		end)
		
		local spawn = table.remove(spawns, math.random(1, #spawns))
		if spawn then
			character:SetPrimaryPartCFrame(spawn.CFrame)
		else
			removePlayerFromContestants(contestant)
		end
		
		character.Humanoid.WalkSpeed = 0
		character.Humanoid.Health = character.Humanoid.MaxHealth
		character.ForceField:Destroy()
	end
	
	wait(3)
	
	for _, contestant in pairs(contestants) do
		local character = contestant.Character
		contestant.Safe.Value = false
		contestant.PlayerGui.SafeGui.Enabled = true
		contestant.PlayerGui.LobbyGui.Enabled = false
		character.Humanoid.WalkSpeed = 16
	end
	
	toggleStatus:FireAllClients(true)

	local timer = settings.roundLength
	while timer > 0 and #contestants > 1 do
		local message = timer <= 10 
			and ("⚠️ Battle ending in " .. timer .. " seconds!") 
			or ("💥 Battle in progress • " .. timer .. " seconds remaining")

		updateStatus:FireAllClients(message)

		for _, contestant in pairs(contestants) do
			if not contestant.Character or not contestant.Character:FindFirstChildOfClass("Humanoid") then
				removePlayerFromContestants(contestant)
			end
		end

		if #contestants < 2 then
			break
		end

		local playersInZone = stormZone:getPlayers()
		for _, plr in pairs(contestants) do
			if table.find(playersInZone, plr) then continue end
			plr.Character.Humanoid:TakeDamage(10)
		end

		timer -= 1
		wait(1)
	end

	for player, time in pairs(times) do
		if player then
			player.leaderstats.Time.Value += time
		end
	end

	if timer == 0 then
		updateStatus:FireAllClients("⏰ Time's up!")

		for _, contestant in pairs(contestants) do
			if not contestant then
				continue
			end

			contestant:LoadCharacter()
			activeManager:edit(contestant.UserId, {{path="Time.data", method="add", data = settings.drawTime}})
		end
	elseif #contestants == 1 then
		local winner = contestants[1]

		updateStatus:FireAllClients("👑 " .. winner.Name .. " won the battle! (+350)")

		winner:LoadCharacter()
		activeManager:edit(winner.UserId, {{path="Time.data", method="add", data = settings.winTime}})
	end

	map:Destroy()
	
	return true
end


-- Remote listeners
local function joinPlayerIntoBattle(player)
	if joiningClosed then return end
	if not player.Character or player.Character.Humanoid.Health <= 0 then return end
	if not table.find(contestants, player) then
		table.insert(contestants, player)
		player.Character:SetPrimaryPartCFrame(lobbyCenter.CFrame)
		toggleBattleSettings(player, true)
	end
end


--// Main
promptPlayer.OnServerEvent:Connect(joinPlayerIntoBattle)
playersInMinigame.OnInvoke = function()
	return contestants
end

while true do
	countdownRound()
	
	local joinedSuccessfully = promptRound()
	if joinedSuccessfully then
		beginRound()
	end
	
	wait(1)
end
