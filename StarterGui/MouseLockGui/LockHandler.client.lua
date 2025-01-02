local MOBILE_ENABLED = true
local CONSOLE_ENABLED = true

local CONSOLE_BUTTON = Enum.KeyCode.ButtonR2

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local Player = game.Players.LocalPlayer  

local IsMobile = UserInputService.TouchEnabled  
local IsConsole = GuiService:IsTenFootInterface()

local UserGameSettings = UserSettings():GetService("UserGameSettings")  

local offset = CFrame.new(1.75, 0, 0) 
local originalRotationType = UserGameSettings.RotationType  

local LockButton = script.Parent:FindFirstChild("LockButton")
 
if not IsMobile and not IsConsole then
	if LockButton then
		LockButton.Visible = false
	end
else
	if LockButton then
		LockButton.Visible = true
	end
end

if (IsMobile and MOBILE_ENABLED) or (IsConsole and CONSOLE_ENABLED) then  
	local Activated = false

	local LockButtonLabel = LockButton and LockButton:FindFirstChild("TextLabel")

	if LockButton then
		LockButton.MouseButton1Click:Connect(function()
			Activated = not Activated

			if LockButtonLabel then
				LockButtonLabel.Text = Activated and "Shift Lock: ON" or "Shift Lock: OFF"
			end

			if not Activated then
				UserGameSettings.RotationType = originalRotationType  
				RunService:UnbindFromRenderStep("Mobile/ConsoleShiftLock")  
			else
				UserGameSettings.RotationType = Enum.RotationType.CameraRelative
				RunService:BindToRenderStep("Mobile/ConsoleShiftLock", Enum.RenderPriority.Camera.Value + 1, function()
					local Camera = workspace.CurrentCamera
					if Camera then
						if (Camera.Focus.Position - Camera.CFrame.Position).Magnitude >= 0.99 then
							Camera.CFrame = Camera.CFrame * offset
							Camera.Focus = CFrame.fromMatrix(Camera.Focus.Position, Camera.CFrame.RightVector, Camera.CFrame.UpVector) * offset
						end
					end
				end)
			end
		end)
	else
		warn("LockButton not found!")
	end

	if IsConsole and CONSOLE_ENABLED then
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == CONSOLE_BUTTON then
				Activated = not Activated

				if LockButtonLabel then
					LockButtonLabel.Text = Activated and "Shift Lock: ON" or "Shift Lock: OFF"
				end

				if not Activated then
					UserGameSettings.RotationType = originalRotationType  
					RunService:UnbindFromRenderStep("Mobile/ConsoleShiftLock")  
				else
					UserGameSettings.RotationType = Enum.RotationType.CameraRelative
					RunService:BindToRenderStep("Mobile/ConsoleShiftLock", Enum.RenderPriority.Camera.Value + 1, function()
						local Camera = workspace.CurrentCamera
						if Camera then
							if (Camera.Focus.Position - Camera.CFrame.Position).Magnitude >= 0.99 then
								Camera.CFrame = Camera.CFrame * offset
								Camera.Focus = CFrame.fromMatrix(Camera.Focus.Position, Camera.CFrame.RightVector, Camera.CFrame.UpVector) * offset
							end
						end
					end)
				end
			end
		end)
	end
end
