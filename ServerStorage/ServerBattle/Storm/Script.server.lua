local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")

local storm = script.Parent

tweenService:Create(storm, TweenInfo.new(90), {Size = Vector3.new(60, 124, 60)}):Play()