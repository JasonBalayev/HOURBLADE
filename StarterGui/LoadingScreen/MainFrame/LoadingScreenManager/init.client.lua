--[[

Author: ARCHIE0709
Last Modified: 30/12/2024

Description: Manager for loading screen

]]

local settings = {
	maxLoadBeforeGame = 63,
	jumpToWhenLoaded = 70,
}

--// Variables
-- Services
local TweenService = game:GetService("TweenService")

-- UI Elements
local loadingGui = script.Parent.Parent
local endSequence = loadingGui:WaitForChild("EndSequence")
local mainFrame = loadingGui:WaitForChild("MainFrame")
local bar = mainFrame:WaitForChild("Bar")
local bar2 = bar:WaitForChild("Bar2")

local percentageText = bar:WaitForChild("Percentage")


--// Functions
local function percentManager()
	local current = 0
	
	repeat
		if current < settings.maxLoadBeforeGame then
			current += 1
			percentageText.Text = current.."%"
			bar2:TweenSize(UDim2.new(current/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.1, true)
		end
		task.wait(0.1)
	until game:IsLoaded()
	
	current = settings.jumpToWhenLoaded - 1
	
	while current < 100 do
		current += 1
		percentageText.Text = current.."%"
		bar2:TweenSize(UDim2.new(current/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.1, true)
		task.wait(0.1)
	end
end

local function closeScreen()
	endSequence:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 3, true)
	
	task.wait(3)
	
	mainFrame.Visible = false
	TweenService:Create(
		endSequence,
		TweenInfo.new(
			1,                                  
			Enum.EasingStyle.Quad,            
			Enum.EasingDirection.InOut         
		),
		{BackgroundTransparency = 1}        
	):Play()
	
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
	
	task.wait(1)
	
	loadingGui:Destroy()
end



--// Main
mainFrame.Visible = true
percentManager()

task.wait(0.5)

closeScreen()
