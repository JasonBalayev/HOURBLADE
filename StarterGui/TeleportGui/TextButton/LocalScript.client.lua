local tweenService = game:GetService("TweenService")

local teleportButton = script.Parent
local teleportText = teleportButton:WaitForChild("TextLabel")
local isTeleported = false
local canTeleport = true

local player = game.Players.LocalPlayer

local obbyFolder = game.Workspace:WaitForChild("Obby")
local checkpoint1 = obbyFolder:WaitForChild("1")

local spawnFolder = game.Workspace:WaitForChild("Spawn")
local spawnPoint = spawnFolder:WaitForChild("d")

local buttonOriginalPosition = teleportButton.Position
local buttonOriginalSize = teleportButton.Size

local hoverTweenInfo = TweenInfo.new(
	0.3,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

local hoverOnGoal = {
	Position = UDim2.new(
		buttonOriginalPosition.X.Scale,
		buttonOriginalPosition.X.Offset,
		buttonOriginalPosition.Y.Scale - 0.003,
		buttonOriginalPosition.Y.Offset
	),
	Size = UDim2.new(
		buttonOriginalSize.X.Scale * 1.05,
		buttonOriginalSize.X.Offset,
		buttonOriginalSize.Y.Scale * 1.05,
		buttonOriginalSize.Y.Offset
	)
}

local hoverOffGoal = {
	Position = buttonOriginalPosition,
	Size = buttonOriginalSize
}

local hoverOnTween = tweenService:Create(teleportButton, hoverTweenInfo, hoverOnGoal)
local hoverOffTween = tweenService:Create(teleportButton, hoverTweenInfo, hoverOffGoal)

local function teleportPlayer()
	if canTeleport and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local rootPart = player.Character.HumanoidRootPart
		canTeleport = false

		if isTeleported then
			if spawnPoint then
				rootPart.CFrame = spawnPoint.CFrame
				isTeleported = false
				player:SetAttribute("InObby", false)
			end
		else
			if checkpoint1 then
				rootPart.CFrame = checkpoint1.CFrame
				isTeleported = true
				player:SetAttribute("InObby", true)
			end
		end

		-- Cooldown to prevent anti cheat from falsely kicking
		for countdown = 10, 1, -1 do
			teleportText.Text = "Wait " .. countdown .. " seconds"
			task.wait(1)
		end

		canTeleport = true
		if isTeleported then
			teleportText.Text = "Teleport Back"
		else
			teleportText.Text = "Teleport"
		end
	end
end

teleportButton.MouseButton1Click:Connect(teleportPlayer)

teleportButton.MouseEnter:Connect(function()
	hoverOnTween:Play()
end)

teleportButton.MouseLeave:Connect(function()
	hoverOffTween:Play()
end)
