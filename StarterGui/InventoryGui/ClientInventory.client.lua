local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local marketPlaceService = game:GetService("MarketplaceService")

local remotes = replicatedStorage.Remotes.Inventory

local ownsPass = remotes.OwnsPass
local equipSword = remotes.EquipSword
local unequipSword = remotes.UnequipSword
local passPurchased = remotes.PassPurchased
local sendRequirements = remotes.SendRequirements
local viewData = remotes.ViewInventory

local player = players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")

local itemHolder = script.Parent.MainFrame.Background.ScrollHolder.ItemHolder

task.wait(1)
local equippedSwords = viewData:InvokeServer()[1]

local debounce = false

local tweenService = game:GetService("TweenService")

-- Add button effect settings
local clickTweenInfo = TweenInfo.new(
	0.15, -- Quick animation
	Enum.EasingStyle.Back,
	Enum.EasingDirection.Out
)

local hoverTweenInfo = TweenInfo.new(
	0.3,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

local function createButtonEffects(button)
	local originalSize = button.Size
	local originalPosition = button.Position
	
	-- Hover effect
	local hoverGoal = {
		Size = UDim2.new(
			originalSize.X.Scale * 1.05,
			originalSize.X.Offset,
			originalSize.Y.Scale * 1.05,
			originalSize.Y.Offset
		)
	}
	
	-- Click effect
	local clickGoal = {
		Size = UDim2.new(
			originalSize.X.Scale * 0.95,
			originalSize.X.Offset,
			originalSize.Y.Scale * 0.95,
			originalSize.Y.Offset
		)
	}
	
	-- Create tweens
	local hoverTween = tweenService:Create(button, hoverTweenInfo, hoverGoal)
	local unhoverTween = tweenService:Create(button, hoverTweenInfo, {Size = originalSize})
	local clickTween = tweenService:Create(button, clickTweenInfo, clickGoal)
	local releaseTween = tweenService:Create(button, clickTweenInfo, {Size = originalSize})
	
	-- Add effects
	button.MouseEnter:Connect(function()
		hoverTween:Play()
	end)
	
	button.MouseLeave:Connect(function()
		unhoverTween:Play()
	end)
	
	button.MouseButton1Down:Connect(function()
		clickTween:Play()
	end)
	
	button.MouseButton1Up:Connect(function()
		releaseTween:Play()
	end)
end

local function requirementText(stat, gap)
	if stat == "Best Time" then
		return "You need a " .. gap .. " higher " .. stat .. " to unlock"
	elseif stat == "Kills" then
		return "You need " .. gap .. " more " .. stat .. " to unlock"
	elseif stat == "Level" then
		return "You need " .. gap .. " more " .. stat .. "s to unlock"
	end
end

local function activated(child)
	if debounce then return end
	debounce = true
	
	local name = child.Name
	if not equippedSwords[name] then
		local equip = equipSword:InvokeServer(name)
		
		if equip then
			child.BackgroundColor3 = Color3.fromRGB(0, 85, 0)
			
			equippedSwords[name] = true
		end
	else
		print("unequipped")
		local unequip = unequipSword:InvokeServer(name)

		if unequip then
			child.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
			
			equippedSwords[name] = false
		end
	end
	
	wait(0.5)
	debounce = false
end

local requirements = sendRequirements.OnClientEvent:Wait()

for _, child in pairs(itemHolder:GetChildren()) do
	if not child:IsA("Frame") then
		continue
	end
	
	local name = child.Name
	local req = requirements[name]
	local itemButton = child.ItemButton
	
	-- Add button effects to the ItemButton
	createButtonEffects(itemButton)
	
	local stat = req[1]
	local amount = req[2]
	
	local displayRequirement = child:FindFirstChild("DisplayRequirement")
	
	if stat ~= "Pass" then
		local gap = amount - leaderstats[stat].Value
		
		if gap > 0 then
			displayRequirement.TextLabel.Text = requirementText(stat, gap)
		else
			displayRequirement:Destroy()
		end
	else
		if not ownsPass:InvokeServer(name) then
			displayRequirement.TextLabel.Text = "You need the " .. child.Name .. " pass to unlock"
		else
			displayRequirement:Destroy()
		end
	end
	
	if equippedSwords[name] then
		child.BackgroundColor3 = Color3.fromRGB(0, 85, 0)
	end
	
	child.ItemButton.Activated:Connect(function()
		if child:FindFirstChild("DisplayRequirement") then
			if stat == "Pass" then
				marketPlaceService:PromptGamePassPurchase(player, req[2])
			end
			
			
			return
		end
		
		activated(child)
	end)
end

for _, stat in pairs(leaderstats:GetChildren()) do
	stat:GetPropertyChangedSignal("Value"):Connect(function()
		for _, child in pairs(itemHolder:GetChildren()) do
			local name = child.Name
			local displayRequirement = child:FindFirstChild("DisplayRequirement")
			
			if not displayRequirement then
				continue
			end
			
			if requirements[name][1] == stat.Name then
				local gap = requirements[name][2] - stat.Value
				
				if gap > 0 then
					displayRequirement.TextLabel.Text = requirementText(stat.Name, gap)
				else
					displayRequirement:Destroy()
				end
			end
		end
	end)
end

passPurchased.OnClientEvent:Connect(function(name)
	itemHolder[name].Requirement:Destroy()
end)