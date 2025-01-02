local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local profileLoaded = replicatedStorage.Remotes.ProfileLoaded

local profileService = require(script.ProfileService)

local profileStore = profileService.GetProfileStore(
	"PlayerData",
	{
		Time = 0,
		["Best Time"] = 0,
		Kills = 0,
		Level = 1,
		Experience = 0
	}
)

local profiles = {}

local function handleProfile(player, profile)
	local leaderstats = player:WaitForChild("leaderstats")
	local playerFolder = serverStorage:WaitForChild("PlayerData"):WaitForChild(player.Name)
	
	leaderstats.Time.Value = profile.Data.Time
	leaderstats["Best Time"].Value = profile.Data["Best Time"]
	leaderstats.Level.Value = profile.Data.Level
	leaderstats.Kills.Value = profile.Data.Kills
	
	playerFolder.Experience.Value = profile.Data.Experience
	
	profileLoaded:Fire(player)
end

local function resetLeaderBoardStats()
	for _, player in pairs(players:GetPlayers()) do 
			local profile = profiles[player]
			if profile then 
				local leaderstats = player:FindFirstChild("leaderstats")
				if leaderstats then
					leaderstats.Time.Value = 0
					leaderstats["Best Time"].Value = 0
					leaderstats.Kills.Value = 0
					leaderstats.Level.Value = 1
				end
				
				profile.Data.Time = 0
				profile.Data["Best Time"] = 0
				profile.Data.kills = 0
				profile.Data.level = 0
				profile.Data.Experience = 0
				profile:Save()
			end
		end
		print("Stats have been reset")
end

resetLeaderBoardStats()


local function playerAdded(player)
	local profile = profileStore:LoadProfileAsync(
		"Test" .. player.UserId, -- Change string name for stat resets (Original name = Player)
		"ForceLoad"
	)
	
	if profile then
		profile:ListenToRelease(function()
			profiles[player] = nil
			
			player:Kick()
		end)
		
		if player:IsDescendantOf(players) then
			profiles[player] = profile
			
			handleProfile(player, profile)
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end

for _, player in pairs(players:GetPlayers()) do
	coroutine.wrap(playerAdded)(player)
end

players.PlayerAdded:Connect(playerAdded)

players.PlayerRemoving:Connect(function(player)
	local profile = profiles[player]
	
	if profile then
		profile:Release()
	end
end)

return profiles