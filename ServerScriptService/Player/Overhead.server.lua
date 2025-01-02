local players = game:GetService("Players")

local display = script.Display

local function characterAdded(player, character)
	local humanoid = character.Humanoid
	
	local leaderstats = player:WaitForChild("leaderstats")
	local time = leaderstats.Time
	
	local newDisplay = display:Clone()
	
	local timeLabel = newDisplay.TimeLabel
	local healthLabel = newDisplay.HealthLabel
	local nameLabel = newDisplay.NameLabel
	
	timeLabel.Text = time.Value
	healthLabel.Text = humanoid.Health .. "/" .. humanoid.MaxHealth
	nameLabel.Text = player.Name
	
	time:GetPropertyChangedSignal("Value"):Connect(function()
		timeLabel.Text = time.Value
	end)
	
	humanoid.HealthChanged:Connect(function(health)
		healthLabel.Text = math.round(humanoid.Health) .. "/" .. humanoid.MaxHealth
		healthLabel.TextColor3 = Color3.fromHSV(math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1) / 3, 1, 1)
	end)
	
	
	wait()
	newDisplay.Parent = character.Head
end

local function playerAdded(player)
	characterAdded(player, player.Character or player.CharacterAdded:Wait())
	
	player.CharacterAdded:Connect(function(character)
		characterAdded(player, character)
	end)
end

for _, player in pairs(players:GetPlayers()) do
	playerAdded(player)
end

players.PlayerAdded:Connect(playerAdded)