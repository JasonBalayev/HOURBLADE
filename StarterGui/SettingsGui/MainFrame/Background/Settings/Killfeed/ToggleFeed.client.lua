
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local button = script.Parent

local killfeed = player:WaitForChild("PlayerGui"):WaitForChild("KillfeedGui")

local disabled = false
local currentTween 

local originalSize = button.Size
local originalColor = button.BackgroundColor3

local pressedSize = UDim2.new(
	originalSize.X.Scale, 
	originalSize.X.Offset, 
	originalSize.Y.Scale - 0.02, 
	originalSize.Y.Offset
)
local pressedColor = Color3.fromRGB(225, 225, 225)

local pressTweenInfo = TweenInfo.new(
	0.15,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local releaseTweenInfo = TweenInfo.new(
	0.15,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In
)

local function playTween(tweenInfo, goalProps)
	if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then
		currentTween:Cancel()
	end

	local newTween = TweenService:Create(button, tweenInfo, goalProps)
	currentTween = newTween
	newTween:Play()
end

local function pressEffect()
	playTween(pressTweenInfo, {
		Size = pressedSize,
		BackgroundColor3 = pressedColor
	})
end

local function releaseEffect()
	playTween(releaseTweenInfo, {
		Size = originalSize,
		BackgroundColor3 = originalColor
	})
end

button.MouseButton1Down:Connect(function()
	pressEffect()
end)

button.MouseButton1Up:Connect(function()
	releaseEffect()
end)

button.MouseLeave:Connect(function()
	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		releaseEffect()
	end
end)


button.Activated:Connect(function()
	if not disabled then
		killfeed.Enabled = false
		button.TextLabel.Text = "Enable Killfeed"
		disabled = true
	else
		killfeed.Enabled = true
		button.TextLabel.Text = "Disable Killfeed"
		disabled = false
	end
	
	releaseEffect()
end)
