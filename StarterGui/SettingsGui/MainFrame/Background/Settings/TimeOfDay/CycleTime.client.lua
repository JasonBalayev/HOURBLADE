 
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
 
local player = Players.LocalPlayer
local button = script.Parent
 
local cycling = false
local nighttime = false

local originalLightingSettings = {
	ClockTime = Lighting.ClockTime,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart,
	FogColor = Lighting.FogColor,
}

local function setNightSettings()
	Lighting.Ambient = Color3.fromRGB(100, 100, 120)
	Lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 100)
	Lighting.Brightness = 2.5
	Lighting.FogEnd = 700
	Lighting.FogStart = 150
	Lighting.FogColor = Color3.fromRGB(60, 60, 80)
end

local function restoreDaySettings()
	Lighting.Ambient = originalLightingSettings.Ambient
	Lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
	Lighting.Brightness = originalLightingSettings.Brightness
	Lighting.FogEnd = originalLightingSettings.FogEnd
	Lighting.FogStart = originalLightingSettings.FogStart
	Lighting.FogColor = originalLightingSettings.FogColor
end
 
local function smoothTransition(targetClockTime, step)
	local currentClockTime = Lighting.ClockTime
	local stopColorAdjustment = false
 
	RunService.RenderStepped:Connect(function()
		if stopColorAdjustment then return end
		Lighting.ClockTime = currentClockTime
	end)

	if currentClockTime < targetClockTime then
		while currentClockTime < targetClockTime do
			currentClockTime = math.min(currentClockTime + step, targetClockTime)
			RunService.RenderStepped:Wait()
		end
	else
		while currentClockTime > targetClockTime do
			currentClockTime = math.max(currentClockTime - step, targetClockTime)
			RunService.RenderStepped:Wait()
		end
	end

	stopColorAdjustment = true
end

 
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

local currentTween  
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
 
	if cycling then
		return
	end
	cycling = true

	if not nighttime then
		smoothTransition(21, 0.02) 
		nighttime = true
		setNightSettings()
		button.TextLabel.Text = "Switch to Day"
	else
		smoothTransition(originalLightingSettings.ClockTime, 0.02)
		nighttime = false
		restoreDaySettings()
		button.TextLabel.Text = "Switch to Night"
	end

	cycling = false

	releaseEffect()
end)
