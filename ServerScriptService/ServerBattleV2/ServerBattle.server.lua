local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local zoneService = require(game:GetService("ReplicatedStorage").Zone)

local playerData = serverStorage.PlayerData

local remotes = replicatedStorage.Remotes.ServerBattle
local playersInMinigame = remotes:WaitForChild("PlayersInGame")

local promptPlayer = remotes.PromptPlayer
local updateStatus = remotes.UpdateStatus
local toggleStatus = remotes.ToggleStatus

local lobby = game.Workspace:WaitForChild("Lobby")
local lobbyCenter = lobby:WaitForChild("LobbyCenter")

local times = {}
local contestants = {}

local function removePlayerFromContestants(player)
	local index = table.find(contestants, player)
	if index then
		table.remove(contestants, index)

	end
end

coroutine.wrap(function()
	while true do
		toggleStatus:FireAllClients(true)

		wait(1)
		if #players:GetPlayers() < 1 then
			updateStatus:FireAllClients("⚠️ Not enough players to start a server battle!")
			repeat wait(5) until #players:GetPlayers() > 1
		else
			for countdown = 360, 1, -1 do
				local message = countdown <= 5 
					and ("🔥 Battle starting in " .. countdown .. "!") 
					or ("⚔️ Next Battle: " .. countdown .. "s")

				updateStatus:FireAllClients(message)
				wait(1)
			end	
		end

		times = {}
		contestants = {}

		toggleStatus:FireAllClients(false)
		promptPlayer:FireAllClients()

		wait(10)

		if #contestants < 2 then
			updateStatus:FireAllClients("❌ Not enough contestants joined the battle!")
			for _, contestant in pairs(contestants) do
				contestant.PlayerGui.SafeGui.Enabled = true
				contestant.PlayerGui.LobbyGui.Enabled = false
				contestant.Safe.Value = false
				contestant:LoadCharacter()
			end
			continue
		end

		local map = serverStorage.ServerBattle:Clone()
		local stormZone = zoneService.new(map.Storm)
		map.Parent = workspace

		wait(2)

		local spawns = map.Spawns:GetChildren()
		if #spawns < #contestants then
			updateStatus:FireAllClients("Not enough spawn points for all players!")
			for _, contestant in pairs(contestants) do
				contestant.PlayerGui.SafeGui.Enabled = true
				contestant.PlayerGui.LobbyGui.Enabled = false
				contestant.Safe.Value = false
				contestant:LoadCharacter()
			end
			map:Destroy()
			continue
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
				contestant.PlayerGui.SafeGui.Enabled = true
				contestant.PlayerGui.LobbyGui.Enabled = false
			else
				removePlayerFromContestants(contestant)
			end

			coroutine.wrap(function()
				character.Humanoid.WalkSpeed = 0
				character.Humanoid.Health = character.Humanoid.MaxHealth

				wait(3)

				contestant.Safe.Value = false
				character.Humanoid.WalkSpeed = 16
			end)()
		end

		wait(3)

		toggleStatus:FireAllClients(true)

		local timer = 90

		while timer > 0 and #contestants > 1 do
			local message = timer <= 10 
				and ("⚠️ Battle ending in " .. timer .. "s!") 
				or ("💥 Battle in progress • " .. timer .. "s remaining")

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
				contestant.leaderstats.Time.Value += 125
			end
		elseif #contestants == 1 then
			local winner = contestants[1]

			updateStatus:FireAllClients("👑 " .. winner.Name .. " won the battle! (+350)")

			winner:LoadCharacter()
			winner.leaderstats.Time.Value += 350
		end

		map:Destroy()
	end
end)()

-- Handle player joining the battle
promptPlayer.OnServerEvent:Connect(function(player)
	if not table.find(contestants, player) then
		table.insert(contestants, player)
		player.Character:SetPrimaryPartCFrame(lobbyCenter.CFrame)
		player.Character.Head.Display.Enabled = false
		player.PlayerGui.SafeGui.Enabled = false
		player.PlayerGui.LobbyGui.Enabled = true
		player.Safe.Value = true
		print(player.Name .. " joined the server battle!")
	end
end)




playersInMinigame.OnInvoke = function()
	return contestants
end