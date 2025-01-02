local players = game:GetService("Players")
local marketplaceService = game:GetService("MarketplaceService")
local chatService = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner").ChatService)
local runService = game:GetService("RunService")

local passOwners = {}
local group = 35282187
local vipPass = 1013098029


local groupTags = require(script:WaitForChild("GroupTags"))


local function getRainbowColor()
	local t = tick() * 2 
	return Color3.fromHSV((t % 1), 1, 1) 
end

local function setDynamicTag(speaker, player)
	if not speaker or not player then return end
	local playerGroupRank = player:GetRankInGroup(group)
	if not table.find(passOwners, player.Name) and playerGroupRank <= 1 then return end

	spawn(function()
		while players:FindFirstChild(player.Name) do
			local tags = {}
			
			if groupTags[playerGroupRank] then
				table.insert(tags, groupTags[playerGroupRank])
			end
			
			if table.find(passOwners, player.Name) then
				table.insert(tags, {
					TagText = "💎 VIP",
					TagColor = getRainbowColor() 
				})
			end
			
			speaker:SetExtraData("Tags", tags)
			wait(0.1) 
		end
	end)
end


local function playerAdded(player)
	if marketplaceService:UserOwnsGamePassAsync(player.UserId, vipPass) then
		table.insert(passOwners, player.Name)
	end
end

for _, player in ipairs(players:GetPlayers()) do
	playerAdded(player)
end

players.PlayerAdded:Connect(playerAdded)

chatService.SpeakerAdded:Connect(function(name)
	local speaker = chatService:GetSpeaker(name)
	if speaker then
		local player = players:FindFirstChild(name)
		if player then
			setDynamicTag(speaker, player)
		end
	end
end)

marketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, id, purchased)
	if id == vipPass and purchased then
		table.insert(passOwners, player.Name)
		local speaker = chatService:GetSpeaker(player.Name)
		if speaker then
			setDynamicTag(speaker, player)
		end
	end
end)
