local players = game:GetService("Players")

local tool = script.Parent

local handle = script.Parent.Handle

local timeDisplay = handle.TimeDisplay
local timeLabel = timeDisplay.TimeLabel

local openSound = handle.OpenSound
local drinkSound = handle.DrinkSound

local timeValue = math.random(50, 200)
local drinkAmount = timeValue / 3

local activated = false

timeLabel.Text = timeValue

tool.Equipped:Connect(function()
	openSound:Play()
end)

tool.Activated:Connect(function()
	if activated then
		return
	end
	
	activated = true
	
	local character = tool.Parent
	local player = players:GetPlayerFromCharacter(character)
	
	tool.GripForward = Vector3.new(0,-.759,-.651)
	tool.GripPos = Vector3.new(1.5,-.5,.3)
	tool.GripRight = Vector3.new(1,0,0)
	tool.GripUp = Vector3.new(0,.651,-.759)

	drinkSound:Play()

	wait(2)
	
	tool.GripForward = Vector3.new(-0.976, 0, -0.217)
	tool.GripPos = Vector3.new(0.03, 0, 0)
	tool.GripRight = Vector3.new(0.217, 0, -0.976)
	tool.GripUp = Vector3.new(0, 1, 0)
	
	if not tool:IsDescendantOf(character) then
		activated = false
		
		return
	end
	
	if timeValue - drinkAmount > 0 then
		player.leaderstats.Time.Value += math.ceil(drinkAmount)
		
		timeValue -= math.ceil(drinkAmount)
	else
		player.leaderstats.Time.Value += math.floor(drinkAmount)
		
		tool:Destroy()
	end
	
	timeLabel.Text = timeValue
	
	activated = false
end)