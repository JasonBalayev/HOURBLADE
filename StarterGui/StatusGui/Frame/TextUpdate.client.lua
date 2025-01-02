local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local remotes = replicatedStorage.Remotes.ServerBattle

local updateStatus = remotes.UpdateStatus
local toggleStatus = remotes.ToggleStatus

local status = script.Parent.Status

local SHOWN_POSITION = UDim2.new(0, 0, 0, 3)  
local HIDDEN_POSITION = UDim2.new(0, 0, -1, 0)

local function animateText(text)
	local fadeOut = tweenService:Create(status, TweenInfo.new(0.2), {TextTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Wait()

	status.Text = text
	local fadeIn = tweenService:Create(status, TweenInfo.new(0.2), {TextTransparency = 0})
	fadeIn:Play()
end

updateStatus.OnClientEvent:Connect(function(text)
	animateText(text)
end)

toggleStatus.OnClientEvent:Connect(function(visible)
	local isErrorMessage = status.Text:match("Not enough") ~= nil

	if visible then
		status.TextTransparency = 1

		if not isErrorMessage then
			status.Position = HIDDEN_POSITION
			local showTween = tweenService:Create(status, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				Position = SHOWN_POSITION,
				TextTransparency = 0
			})
			showTween:Play()
		else
			status.Position = SHOWN_POSITION
			local fadeIn = tweenService:Create(status, TweenInfo.new(0.25), {
				TextTransparency = 0
			})
			fadeIn:Play()
		end
	else
		if not isErrorMessage then
			local hideTween = tweenService:Create(status, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				Position = HIDDEN_POSITION,
				TextTransparency = 1
			})
			hideTween:Play()
		else
			local fadeOut = tweenService:Create(status, TweenInfo.new(0.25), {
				TextTransparency = 1
			})
			fadeOut:Play()
		end
	end
end)