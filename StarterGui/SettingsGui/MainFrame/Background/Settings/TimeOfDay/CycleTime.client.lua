local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")

local button = script.Parent

local cycling = false
local nighttime = false

 local originalLightingSettings = {
	ClockTime = lighting.ClockTime,
	Ambient = lighting.Ambient,
	OutdoorAmbient = lighting.OutdoorAmbient,
	Brightness = lighting.Brightness,
	FogEnd = lighting.FogEnd,
	FogStart = lighting.FogStart,
	FogColor = lighting.FogColor,
}

local function setNightSettings()
	lighting.Ambient = Color3.fromRGB(100, 100, 120)
	lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 100)
	lighting.Brightness = 2.5
	lighting.FogEnd = 700
	lighting.FogStart = 150
	lighting.FogColor = Color3.fromRGB(60, 60, 80)
end

local function restoreDaySettings()
	lighting.Ambient = originalLightingSettings.Ambient
	lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
	lighting.Brightness = originalLightingSettings.Brightness
	lighting.FogEnd = originalLightingSettings.FogEnd
	lighting.FogStart = originalLightingSettings.FogStart
	lighting.FogColor = originalLightingSettings.FogColor
end

 
local function smoothTransition(targetClockTime, step)
	local currentClockTime = lighting.ClockTime
	local stopColorAdjustment = false

	runService.RenderStepped:Connect(function()
		if stopColorAdjustment then return end
		lighting.ClockTime = currentClockTime
	end)

	if currentClockTime < targetClockTime then
		while currentClockTime < targetClockTime do
			currentClockTime = math.min(currentClockTime + step, targetClockTime)
			runService.RenderStepped:Wait()
		end
	else
		while currentClockTime > targetClockTime do
			currentClockTime = math.max(currentClockTime - step, targetClockTime)
			runService.RenderStepped:Wait()
		end
	end
	stopColorAdjustment = true
end

 
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
		smoothTransition(originalLightingSettings.ClockTime, 0.02) -- Smoothly transition to day
		nighttime = false
		restoreDaySettings()
		button.TextLabel.Text = "Switch to Night"
	end

	cycling = false
end)
