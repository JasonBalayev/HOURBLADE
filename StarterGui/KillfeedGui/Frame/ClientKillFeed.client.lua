local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

local frame = script.Parent
local feedLabel = replicatedStorage.FeedLabel

local updateFeed = replicatedStorage.Remotes.UpdateFeed


local function createColorTween(label)
	local colorValue = Instance.new("Color3Value")
	colorValue.Value = Color3.fromRGB(255, 0, 0) 

	local colorTween = tweenService:Create(colorValue, 
		TweenInfo.new(
			2, 
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.InOut,
			-1 
		),
		{Value = Color3.fromRGB(0, 255, 0)} 
	)

	colorValue.Changed:Connect(function()
		label.TextColor3 = colorValue.Value
	end)

	return colorTween
end

updateFeed.OnClientEvent:Connect(function(player, killer, distance)
	local label = feedLabel:Clone()
	label.Text = "<b>" .. killer .. "</b> killed <b>" .. player .. "</b> " .. distance .. " studs away"
	label.Parent = frame

	local colorTween = createColorTween(label)
	colorTween:Play()

	delay(4, function()
		local fadeOut = tweenService:Create(label, 
			TweenInfo.new(1, Enum.EasingStyle.Linear), 
			{TextTransparency = 1}
		)

		fadeOut:Play()
		fadeOut.Completed:Wait()
		label:Destroy()
	end)
end)