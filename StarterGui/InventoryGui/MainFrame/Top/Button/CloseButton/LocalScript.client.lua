local tweenService = game:GetService("TweenService")

local closeButton = script.Parent
local mainFrame = closeButton.Parent.Parent.Parent

local hideTween = tweenService:Create(mainFrame, TweenInfo.new(0.8), {Position = UDim2.new(0.5, 0, -1.5, 0)})

closeButton.Activated:Connect(function()
	hideTween:Play()
	
	_G.inventoryOpen = false
end)