local dots = {
	script.Parent.Dot1.InsideDot,
	script.Parent.Dot2.InsideDot,
	script.Parent.Dot3.InsideDot
}
local tweenService = game:GetService("TweenService")

local growTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local shrinkTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local function loadingEffect()
	while true do
		for _, dot in ipairs(dots) do
			local growGoal = {Size = UDim2.new(1, 0, 1, 0)}
			local growTween = tweenService:Create(dot, growTweenInfo, growGoal)
			growTween:Play()
			growTween.Completed:Wait()
 
			local shrinkGoal = {Size = UDim2.new(0, 0, 0, 0)}
			local shrinkTween = tweenService:Create(dot, shrinkTweenInfo, shrinkGoal)
			shrinkTween:Play()
			wait(0.3) 
		end
	end
end
 
loadingEffect()
