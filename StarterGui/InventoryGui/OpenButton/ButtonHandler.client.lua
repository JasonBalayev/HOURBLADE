local tweenService = game:GetService("TweenService")

local openButton = script.Parent
local mainFrame = script.Parent.Parent.MainFrame

local openTween = tweenService:Create(mainFrame, TweenInfo.new(0.8), {Position = UDim2.new(0.5, 0, 0.5, 0)})
local hideTween = tweenService:Create(mainFrame, TweenInfo.new(0.8), {Position = UDim2.new(0.5, 0, -1.5, 0)})

_G.inventoryOpen = false

openButton.Activated:Connect(function()
	if not _G.inventoryOpen then
		openTween:Play()
		
		_G.inventoryOpen = true
	else
		hideTween:Play()
		
		_G.inventoryOpen = false
	end
end)