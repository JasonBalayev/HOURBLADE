local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local holder = script.Parent
local yesButton = holder.YesFrame.Button
local noButton = holder.NoFrame.Button
local description = holder.Description

local promptPlayer = replicatedStorage.Remotes.ServerBattle.PromptPlayer

holder.Position = UDim2.new(-1,0,1,-100)

local showHolder = tweenService:Create(holder, TweenInfo.new(1), {Position = UDim2.new(0, 10, 0.87, -10)}) 
local hideHolder = tweenService:Create(holder, TweenInfo.new(1), {Position = UDim2.new(-1, 0, 0.87, -10)})

yesButton.Activated:Connect(function()
	hideHolder:Play()

	promptPlayer:FireServer()
end)

noButton.Activated:Connect(function()
	hideHolder:Play()
end)

promptPlayer.OnClientEvent:Connect(function()
	showHolder:Play()
	
	for countdown = 10, 1, -1 do
		description.Text = "A server battle is starting soon, want to join? (" .. countdown .. ")"
		
		wait(1)
	end
	
	hideHolder:Play()
end)