local player = game:GetService("Players").LocalPlayer

local id = 1013098029

script.Parent.Activated:Connect(function()
	game:GetService("MarketplaceService"):PromptGamePassPurchase(player, id)
end)