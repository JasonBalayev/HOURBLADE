local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local serverStorage = game:GetService("ServerStorage")

local bestTimeData = dataStoreService:GetOrderedDataStore("BestTimeData")

local dataFrame = script.Parent.DataFrame
local dataLayout = serverStorage.GuiElements.DataLayout

local specialRanks = {
	{Color3.fromRGB(255, 215, 0), "🥇"},
	{Color3.fromRGB(192, 192, 192), "🥈"},
	{Color3.fromRGB(205, 127, 50), "🥉"}
}

while true do
	for _, child in ipairs(dataFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	local pages = bestTimeData:GetSortedAsync(false, 100)
	local ranks = pages:GetCurrentPage()
	
	for rank, data in ipairs(ranks) do
		local newLayout = dataLayout:Clone()
		
		local success, name = pcall(function()
			return players:GetNameFromUserIdAsync(data.key)
		end)

		if not success then
			continue
		end
		
		if specialRanks[rank] then
			newLayout.Rank.TextColor3 = specialRanks[rank][1]
			newLayout.User.TextColor3 = specialRanks[rank][1]
			newLayout.Value.TextColor3 = specialRanks[rank][1]
			newLayout.User.Text = name .. specialRanks[rank][2]
		else
			newLayout.User.Text = name
		end
		
		newLayout.Rank.Text = "#" .. rank
		newLayout.Value.Text = data.value .. " time"
		newLayout.AvatarBust.Image = players:GetUserThumbnailAsync(data.key, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
		newLayout.Parent = dataFrame
	end
	
	wait(120)
end