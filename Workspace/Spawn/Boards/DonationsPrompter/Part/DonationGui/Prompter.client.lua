local players = game:GetService("Players")
local marketplaceService = game:GetService("MarketplaceService")

local frame = script.Parent.Frame

local player = players.LocalPlayer

local ids = {
	[10] = 2681900005,
	[50] = 2681900171,
	[100] = 2681900594,
	[1000] = 2681900789,
	[10000] = 2681901036,  
	[25000] = 2686745199
}

for _, child in pairs(frame:GetChildren()) do
	if not child:IsA("TextButton") then
		continue
	end
	
	child.Activated:Connect(function()
		marketplaceService:PromptProductPurchase(player, ids[tonumber(child.Name)])
	end)
end