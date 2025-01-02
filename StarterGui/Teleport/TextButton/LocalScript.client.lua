local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local teleportButton = script.Parent
local safeZone = game.Workspace:WaitForChild("SafeZone")
local teleportTarget = game.Workspace:WaitForChild("Spawn"):WaitForChild("d")
local destroyAtLobby = game.Workspace:WaitForChild("Lobby"):WaitForChild("LobbyCenter")

local lastPosition
local isCountingDown = false
local isMoving = false
local isButtonVisible = false
local quietTime = 0.5  
local lastMoveTime = 0  

local fadeTweenInfo = TweenInfo.new(
	0.4,                               
	Enum.EasingStyle.Quad,             
	Enum.EasingDirection.Out,          
	0,                                 
	false,                             
	0                                  
)

teleportButton.Visible = false
teleportButton.BackgroundTransparency = 1
teleportButton.TextTransparency = 1

local function fadeButtonIn()
	if isButtonVisible then return end
	isButtonVisible = true

	teleportButton.Visible = true

	local fadeInTween = TweenService:Create(
		teleportButton,
		fadeTweenInfo,
		{BackgroundTransparency = 0, TextTransparency = 0}
	)
	fadeInTween:Play()
end

destroyAtLobby.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and player == game.Players.LocalPlayer then 
		teleportButton:Destroy()
	end
end)

local function fadeButtonOut()
	if not isButtonVisible then return end
	isButtonVisible = false

	local fadeOutTween = TweenService:Create(
		teleportButton,
		fadeTweenInfo,
		{BackgroundTransparency = 1, TextTransparency = 1}
	)
	fadeOutTween.Completed:Connect(function()
		teleportButton.Visible = false
	end)
	fadeOutTween:Play()
end

local function isInsideZone(character, zonePart)
	if character and character:FindFirstChild("HumanoidRootPart") and zonePart then
		local playerPosition = character.HumanoidRootPart.Position
		local zoneSize = zonePart.Size
		local zoneCFrame = zonePart.CFrame

		local halfSize = zoneSize / 2
		local minBounds = zoneCFrame.Position - halfSize
		local maxBounds = zoneCFrame.Position + halfSize

		return playerPosition.X >= minBounds.X and playerPosition.X <= maxBounds.X
			and playerPosition.Y >= minBounds.Y and playerPosition.Y <= maxBounds.Y
			and playerPosition.Z >= minBounds.Z and playerPosition.Z <= maxBounds.Z
	end
	return false
end

local function updateButtonVisibility()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	if isInsideZone(character, safeZone) then
		fadeButtonOut()
	else
		fadeButtonIn()
	end
end

local function checkIfMoving()
	if isCountingDown then return end

	local player = game.Players.LocalPlayer
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local currentPosition = character.HumanoidRootPart.Position
		if not lastPosition then
			lastPosition = currentPosition
			lastMoveTime = tick()
			isMoving = true
			return
		end
 
		if (currentPosition - lastPosition).magnitude > 0.1 then
			isMoving = true
			lastMoveTime = tick()   
		else
			if tick() - lastMoveTime >= quietTime then
				isMoving = false
			else
				isMoving = true
			end
		end
		lastPosition = currentPosition
	end
end

local function updateButtonText()
	if isCountingDown then return end

	if isMoving then
		teleportButton.Text = "Stay still to teleport!"
	else
		teleportButton.Text = "Teleport"
	end
end

RunService.Heartbeat:Connect(function()
	checkIfMoving()
	updateButtonVisibility()
	updateButtonText()
end)

teleportButton.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
 
	if isCountingDown then
		return
	end
 
	if character and character:FindFirstChild("HumanoidRootPart") then
		lastPosition = character.HumanoidRootPart.Position
	end

	isCountingDown = true
	teleportButton.Active = false  

	for i = 5, 1, -1 do
		if character and character:FindFirstChild("HumanoidRootPart") then
			local currentPosition = character.HumanoidRootPart.Position

			if (currentPosition - lastPosition).magnitude > 0.1 then
				teleportButton.Text = "Stay still to teleport!"
				isCountingDown = false
				teleportButton.Active = true
				return
			end

			lastPosition = currentPosition
			teleportButton.Text = "Teleporting to Spawn in " .. i .. "..."
		end
		wait(1)
	end
 
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = teleportTarget.CFrame
	end

	isCountingDown = false
	teleportButton.Active = true
	teleportButton.Text = "Teleport"
end)
