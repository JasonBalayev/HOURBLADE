local bar = script.Parent.Bar
local insidebar = bar.Bar2
local percentage = bar.Percentage
local TweenService = game:GetService("TweenService")

wait(2)

insidebar:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 20, true)
wait(20)

script.Parent.Parent.EndSequence:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 3, true)
wait(3)

script.Parent.Visible = false

local fadeInfo = TweenInfo.new(
	1,                                  
	Enum.EasingStyle.Quad,            
	Enum.EasingDirection.InOut         
)
 
local fadeOut = TweenService:Create(
	script.Parent.Parent.EndSequence,
	fadeInfo,
	{BackgroundTransparency = 1}        
)

fadeOut:Play()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
wait(1)

script.Parent.Parent.Parent.LoadingScreen:Destroy()
