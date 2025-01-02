local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")

local alertLabel = script.Parent.Frame.AlertLabel
local penaltyLabel = script.Parent.Frame.PenaltyLabel

local showAlertTween = tweenService:Create(alertLabel, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 0, 0)})
local hideAlertTween = tweenService:Create(alertLabel, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 1, 0)})

local showPenaltyTween = tweenService:Create(penaltyLabel, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 1, 0)})
local hidePenaltyTween = tweenService:Create(penaltyLabel, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 2, 0)})

local player = players.LocalPlayer
local safe = player:WaitForChild("Safe")

safe:GetPropertyChangedSignal("Value"):Connect(function()
	if safe.Value then
		showAlertTween:Play()
		showPenaltyTween:Play()
	elseif not safe.Value then
		hideAlertTween:Play()
		hidePenaltyTween:Play()
	end
end)