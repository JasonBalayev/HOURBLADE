local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local updateBar = replicatedStorage.Remotes.Level.UpdateBar
local sendInformation = replicatedStorage.Remotes.Level.SendInformation

local progressBar = script.Parent.ProgressBar
local textHolder = script.Parent.TextHolder
local currentLevel = textHolder.CurrentLevel
local experience = textHolder.Experience

local function changeBar(level, current, required)
	currentLevel.Text = "Level " .. level .. ":"
	experience.Text = current .. " / " .. required

	tweenService:Create(progressBar, TweenInfo.new(0.2), {Size = UDim2.new(current / required, 0, 1, 0)}):Play()
end

local level, current, required = sendInformation.OnClientEvent:Wait()

changeBar(level, current, required)

updateBar.OnClientEvent:Connect(function(level, current, required)
	changeBar(level, current, required)
end)