local player = game:GetService("Players").LocalPlayer

local button = script.Parent

local disabled = false

button.Activated:Connect(function()
	local killfeed = player.PlayerGui.KillfeedGui
	
	if not disabled then
		killfeed.Enabled = false
		
		button.TextLabel.Text = "Enable killfeed"
		
		disabled = true
	else
		killfeed.Enabled = true
		
		button.TextLabel.Text = "Disable killfeed"
		
		disabled = false
	end
end)