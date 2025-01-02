--[[

Author: ARCHIE0709
Last Edited: 31/12/2024
Description: Manager for all player data & global leaderboards

]]

local DataManager = {}

local settings = {
	saveKey = "DEVELOPMENT-0.0.3",
	maxAttempts = 50,
	
	leaderboardSize = 100,
}

--// Variables
-- Services
local CollectionService = game:GetService("CollectionService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local activeManager = require(ServerScriptService:WaitForChild("Data2"):WaitForChild("ActiveManager"))
local dataTemplate = require(script:WaitForChild("DataTemplate"))
local leaderstatsOrder = require(script:WaitForChild("LeaderstatsOrder"))

-- Tables
local leaderboardRanks = {
	{Color3.fromRGB(255, 215, 0), "🥇"},
	{Color3.fromRGB(192, 192, 192), "🥈"},
	{Color3.fromRGB(205, 127, 50), "🥉"}
}

-- Other
local leaderboardFrame = script:WaitForChild("LeaderboardFrame")


--// Functions
-- Internal
local function setUpValue(folder, name, value)
	local newValue;
	local dataType = type(value.data)
	if dataType == "number" then
		newValue = Instance.new("NumberValue")
	elseif dataType == "string" then
		newValue = Instance.new("StringValue")
	elseif dataType == "boolean" then
		newValue = Instance.new("BoolValue")
	end	
	newValue.Value = value.data
	newValue.Name = name
	newValue.Parent = folder
end

local function updateLeaderboard(leaderboard)
	local leaderboardSettings = require(leaderboard:WaitForChild("LeaderboardSettings"))
	local gui = leaderboard.PrimaryPart:FindFirstChildOfClass("SurfaceGui")
	local dataFrame = gui:FindFirstChildOfClass("ScrollingFrame")

	for _, child in pairs(dataFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local orderedDataStore;
	local s, e = pcall(function()
		orderedDataStore = DataStoreService:GetOrderedDataStore(settings.saveKey .. leaderboardSettings.name)
	end)
	if not s or not orderedDataStore then 
		warn("Error fetching data for leaderbaord: " .. leaderboard.Name)
		return
	end

	local pages = orderedDataStore:GetSortedAsync(false, settings.leaderboardSize)
	local ranks = pages:GetCurrentPage()

	for rank, data in pairs(ranks) do
		local newLayout = leaderboardFrame:Clone()
		local playerName = Players:GetNameFromUserIdAsync(data.key)

		if leaderboardRanks[rank] then
			newLayout.Rank.TextColor3 = leaderboardRanks[rank][1]
			newLayout.User.TextColor3 = leaderboardRanks[rank][1]
			newLayout.Value.TextColor3 = leaderboardRanks[rank][1]
			newLayout.User.Text = playerName .. leaderboardRanks[rank][2]
		else
			newLayout.User.Text = playerName
		end

		newLayout.Rank.Text = "#" .. rank
		newLayout.Value.Text = data.value .. " " .. leaderboardSettings.prefix
		newLayout.AvatarBust.Image = Players:GetUserThumbnailAsync(data.key, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
		newLayout.Parent = dataFrame

		if leaderboardSettings.hasStatue and rank == 1 then
			local statue = leaderboard:FindFirstChild("Statue")
			if statue then
				statue.Head.Display.NameLabel.Text = playerName
				statue.Humanoid:ApplyDescription(Players:GetHumanoidDescriptionFromUserId(data.key))
			end
		end
	end
end

-- Callabale
function DataManager:addPlayer(player)
	local userId = player.UserId
	local data = DataStoreService:GetDataStore(userId):GetAsync(settings.saveKey) or dataTemplate
	
	local leaderstatsFolder = Instance.new("Folder")
	leaderstatsFolder.Name = "leaderstats"
	leaderstatsFolder.Parent = player
	local valuesFolder = Instance.new("Folder")
	valuesFolder.Name = "values"
	valuesFolder.Parent = player
	
	-- Setup values
	local leaderstatsToMake = {}
	for name, value in pairs(dataTemplate) do
		if data[name] == nil then
			data[name] = value
		end
		if value.leaderstat then
			if leaderstatsOrder then
				table.insert(leaderstatsToMake, name)
			else
				setUpValue(leaderstatsFolder, name, data[name])
			end
		elseif value.value then
			setUpValue(valuesFolder, name, data[name])
		end
	end
	
	if leaderstatsOrder then
		for _, leaderstat in pairs(leaderstatsOrder) do
			setUpValue(leaderstatsFolder, leaderstat, data[leaderstat])
		end
	end
	
	-- Send data to active manager
	activeManager:open(userId, data)
	
	
	-- Custom for game, create other valuea
	setUpValue(player, "Safe", {data = true})
	setUpValue(player, "Multiplier", {data = 1})
end

function DataManager:removePlayer(player)
	local userId = player.UserId
	local savaData = activeManager:close(userId)
	
	local s, e;
	repeat
		s, e = pcall(function()
			DataStoreService:GetDataStore(userId):SetAsync(settings.saveKey, savaData)
		end)
	until s == true
end

function DataManager:UpdateLeaderboards()
	for _, leaderboard in pairs(CollectionService:GetTagged("Leaderboard")) do
		updateLeaderboard(leaderboard)
	end
end

function DataManager:SetLeaderboard(userId, boardName, value)
	local attempts = 0
	local s, e;
	repeat
		attempts += 1
		if attempts > settings.maxAttempts then return false end
		s, e = pcall(function()
			local leaderboard = DataStoreService:GetOrderedDataStore(settings.saveKey .. boardName)
			leaderboard:SetAsync(userId, value)
		end)
	until s == true
	
	return true
end

--function DataManager:resetData(userId)

	-- we gonna want to kick player from game first if theyre in it

--	local s, e;
--	repeat
--		s, e = pcall(function()
--			DataStoreService:GetDataStore(userId):SetAsync(settings.saveKey, dataTemplate)
--		end)
--	until s == true
--end


--// Main
return DataManager