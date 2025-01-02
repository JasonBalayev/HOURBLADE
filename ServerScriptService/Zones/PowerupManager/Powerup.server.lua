--[[

Author: ARCHIE0709
Last Modified: 31/12/2024

Description: Manager for a powerup

]]

local settings = require(script.Parent:WaitForChild("PowerUpSettings"))
settings.tweenTime = 1

--// Variables
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")

-- Modules
local activeManager = require(ServerScriptService:WaitForChild("Data2"):WaitForChild("ActiveManager"))

-- Remotes
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local powerUpDeletedEvent = remotesFolder:WaitForChild("PowerUpDeleted")

-- Tables
local powerUpFunctions = {}
local tweens = {}

-- Tweens
local tweenInfo = TweenInfo.new(
	settings.tweenTime,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

-- Other
local object = script.Parent
local mainModel = object:FindFirstChild("Model")

local debounce = false
local modelDeleted = false


--// Functions
powerUpFunctions.Forcefield = function(char)
	local forcefield = Instance.new("ForceField")
	forcefield.Parent = char
	wait(math.random(settings.durationLower, settings.durationUpper))
	forcefield:Destroy()
end

powerUpFunctions.Health = function(char)
	char.Humanoid.MaxHealth += settings.amountToAdd
	char.Humanoid.Health = char.Humanoid.MaxHealth
end

powerUpFunctions.Jump = function(char)
	local currentJump = char.Humanoid.JumpPower
	local change = math.random(settings.lowerLimit, settings.upperLimit)
	char.Humanoid.JumpPower += change
	wait(math.random(settings.durationLower, settings.durationUpper))
	char.Humanoid.JumpPower -= change
end

powerUpFunctions.Speed = function(char)
	local currentSpeed = char.Humanoid.WalkSpeed
	local change = math.random(settings.lowerLimit, settings.upperLimit)
	char.Humanoid.WalkSpeed += change
	wait(math.random(settings.durationLower, settings.durationUpper))
	char.Humanoid.WalkSpeed -= change
end

powerUpFunctions.Time = function(char)
	local player = Players:GetPlayerFromCharacter(char)
	local change = math.random(settings.lowerLimit, settings.upperLimit)
	activeManager:edit(player.UserId, {{path = "Time.data", method = "add", data = change}})
end

local function deleteObject()
	for _, part in pairs(mainModel:GetChildren()) do
		local goal = {Transparency = 1}
		local tween = TweenService:Create(part, tweenInfo, goal)
		tween:Play()
		table.insert(tweens,tween)
	end
	
	task.wait(settings.tweenTime)
	
	object:FindFirstChild("Model"):Destroy()
	modelDeleted = true
end

local function OnTouch(hit)
	if debounce then return end
	debounce = true

	local char = hit.Parent
	local humanoid = char:FindFirstChild("Humanoid")
	if not humanoid then debounce=false; return end
	
	coroutine.resume(coroutine.create(deleteObject))
	powerUpFunctions[settings.type](char)
	
	repeat task.wait(0.25) until modelDeleted
	
	powerUpDeletedEvent:Fire()
	object:Destroy()
end


--// Main
object.PrimaryPart.Touched:Connect(OnTouch)
