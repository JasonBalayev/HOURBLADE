local tweenService = game:GetService("TweenService")

local openButton = script.Parent
local mainFrame = script.Parent.Parent.MainFrame
 
local originalPosition = UDim2.new(0.5, 0, 0.5, 0)
local hiddenPosition = UDim2.new(0.5, 0, -1.5, 0)
local buttonOriginalPosition = openButton.Position
 
local tweenInfo = TweenInfo.new(
    0.8,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)
 
local hoverTweenInfo = TweenInfo.new(
    0.3,
    Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut
)
 
local openGoal = {
    Position = originalPosition
}

local hideGoal = {
    Position = hiddenPosition
}

-- Create hover effect goals
local hoverOnGoal = {
    Position = UDim2.new(
        buttonOriginalPosition.X.Scale,
        buttonOriginalPosition.X.Offset,
        buttonOriginalPosition.Y.Scale - 0.003,
        buttonOriginalPosition.Y.Offset
    ),
    Size = UDim2.new(
        openButton.Size.X.Scale * 1.05,
        openButton.Size.X.Offset,
        openButton.Size.Y.Scale * 1.05,
        openButton.Size.Y.Offset
    )
}

local hoverOffGoal = {
    Position = buttonOriginalPosition,
    Size = openButton.Size
}
 
local openTween = tweenService:Create(mainFrame, tweenInfo, openGoal)
local hideTween = tweenService:Create(mainFrame, tweenInfo, hideGoal)
local hoverOnTween = tweenService:Create(openButton, hoverTweenInfo, hoverOnGoal)
local hoverOffTween = tweenService:Create(openButton, hoverTweenInfo, hoverOffGoal)

_G.inventoryOpen = false

openButton.MouseEnter:Connect(function()
    hoverOnTween:Play()
end)

openButton.MouseLeave:Connect(function()
    hoverOffTween:Play()
end)

openButton.Activated:Connect(function()
    if not _G.inventoryOpen then
        openTween:Play()
        _G.inventoryOpen = true
    else
        hideTween:Play()
        _G.inventoryOpen = false
    end
end)