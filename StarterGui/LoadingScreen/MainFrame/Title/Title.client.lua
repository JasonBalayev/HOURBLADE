local title = script.Parent
local tweenService = game:GetService("TweenService")
 
local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

local originalTextSize = title.TextSize

local function animateTitle()
	while true do
 
		local pulseOutGoal = {
			Rotation = 5,
			TextTransparency = 0.1,
			TextSize = originalTextSize * 1.15,
			TextStrokeTransparency = 0.3   
		}

		local pulseOutTween = tweenService:Create(title, tweenInfo, pulseOutGoal)
		pulseOutTween:Play()
		pulseOutTween.Completed:Wait()

	 
		local pulseInGoal = {
			Rotation = -5,
			TextTransparency = 0,
			TextSize = originalTextSize * 0.95,
			TextStrokeTransparency = 0.7   
		}

		local pulseInTween = tweenService:Create(title, tweenInfo, pulseInGoal)
		pulseInTween:Play()
		pulseInTween.Completed:Wait()
 
		local returnGoal = {
			Rotation = 0,
			TextTransparency = 0,
			TextSize = originalTextSize,
			TextStrokeTransparency = 0.5  
		}

		local returnTween = tweenService:Create(title, tweenInfo, returnGoal)
		returnTween:Play()
		returnTween.Completed:Wait()

		task.wait(3)  
	end
end
 
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

animateTitle()

-- Original Aniamtion Title below


--local title = script.Parent
--local tweenService = game:GetService("TweenService")

--local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

--local function animateTitle()
--	while true do
-- 		local step1Goal = {
--			Rotation = 10,
--			TextTransparency = 0.5,
--			TextSize = title.TextSize + 10
--		}
		
--		local step1Tween = tweenService:Create(title, tweenInfo, step1Goal)
--		step1Tween:Play()
--		step1Tween.Completed:Wait()

-- 		local step2Goal = {
--			Rotation = -10,
--			TextTransparency = 0,
--			TextSize = title.TextSize - 5
--		}
		
--		local step2Tween = tweenService:Create(title, tweenInfo, step2Goal)
--		step2Tween:Play()
--		step2Tween.Completed:Wait()

-- 		local step3Goal = {
--			Rotation = 0,
--			TextTransparency = 0,
--			TextSize = title.TextSize
--		}
		
--		local step3Tween = tweenService:Create(title, tweenInfo, step3Goal)
--		step3Tween:Play()
--		step3Tween.Completed:Wait()
--	end
--end

--animateTitle()

--Attempt to make a loading screen with a cut through text effect

--local title = script.Parent
--local tweenService = game:GetService("TweenService")

--local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
 
--local function swordCutEffect()
--	local sword = Instance.new("ImageLabel")
--	sword.Image = "rbxassetid://12345678"  
--	sword.Size = UDim2.new(0, 200, 0, 200)
--	sword.BackgroundTransparency = 1
--	sword.Position = UDim2.new(1, 0, 0.5, -100)  
--	sword.AnchorPoint = Vector2.new(0.5, 0.5)
--	sword.Parent = title.Parent
 
--	local swordTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
--	local swordTweenGoal = {
--		Position = UDim2.new(-0.5, 0, 0.5, -100)  
--	}
--	local swordTween = tweenService:Create(sword, swordTweenInfo, swordTweenGoal)
--	swordTween:Play()
 
--	wait(0.5)
--	title.TextTransparency = 1  

--	local leftText = Instance.new("TextLabel")
--	leftText.Text = title.Text
--	leftText.Font = title.Font
--	leftText.TextSize = title.TextSize
--	leftText.Size = title.Size
--	leftText.Position = title.Position
--	leftText.BackgroundTransparency = 1
--	leftText.TextColor3 = title.TextColor3
--	leftText.Parent = title.Parent
--	leftText.AnchorPoint = title.AnchorPoint

--	local rightText = leftText:Clone()
--	rightText.Parent = title.Parent
 
--	local splitTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
--	local leftTextGoal = {
--		Position = UDim2.new(leftText.Position.X.Scale - 0.1, leftText.Position.X.Offset, leftText.Position.Y.Scale, leftText.Position.Y.Offset)
--	}
--	local rightTextGoal = {
--		Position = UDim2.new(rightText.Position.X.Scale + 0.1, rightText.Position.X.Offset, rightText.Position.Y.Scale, rightText.Position.Y.Offset)
--	}

--	local leftTextTween = tweenService:Create(leftText, splitTweenInfo, leftTextGoal)
--	local rightTextTween = tweenService:Create(rightText, splitTweenInfo, rightTextGoal)

--	leftTextTween:Play()
--	rightTextTween:Play()

--	leftTextTween.Completed:Wait()
 
--	leftText:Destroy()
--	rightText:Destroy()
--	sword:Destroy()
--	title.TextTransparency = 0  
--end
 
--local function animateTitle()
--	while true do
--		local step1Goal = {
--			Rotation = 10,
--			TextTransparency = 0.5,
--			TextSize = title.TextSize + 10
--		}
--		local step1Tween = tweenService:Create(title, tweenInfo, step1Goal)
--		step1Tween:Play()
--		step1Tween.Completed:Wait()

--		local step2Goal = {
--			Rotation = -10,
--			TextTransparency = 0,
--			TextSize = title.TextSize - 5
--		}
--		local step2Tween = tweenService:Create(title, tweenInfo, step2Goal)
--		step2Tween:Play()
--		step2Tween.Completed:Wait()

--		local step3Goal = {
--			Rotation = 0,
--			TextTransparency = 0,
--			TextSize = title.TextSize
--		}
--		local step3Tween = tweenService:Create(title, tweenInfo, step3Goal)
--		step3Tween:Play()
--		step3Tween.Completed:Wait()
 
--		swordCutEffect()
--	end
--end

--animateTitle()
