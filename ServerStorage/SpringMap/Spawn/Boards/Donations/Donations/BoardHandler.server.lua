local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local serverStorage = game:GetService("ServerStorage")

local donationData = dataStoreService:GetOrderedDataStore("DonationData")

local board = script.Parent
local dataFrame = board.SurfaceGui.DataFrame

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

	local pages = donationData:GetSortedAsync(false, 100)
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
		newLayout.Value.Text = data.value .. " R$"
		newLayout.AvatarBust.Image = players:GetUserThumbnailAsync(data.key, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
		newLayout.Parent = dataFrame
		
		if rank == 1 then
			local statue = board.Parent:FindFirstChild("Statue")

			if statue then
				statue.Head.Display.NameLabel.Text = name
				statue.Humanoid:ApplyDescription(players:GetHumanoidDescriptionFromUserId(data.key))
			end
		end
	end

	wait(120)
end