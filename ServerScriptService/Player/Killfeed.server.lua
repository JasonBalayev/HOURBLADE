local players = game:GetService("Players")

local updateFeed = game:GetService("ReplicatedStorage").Remotes.UpdateFeed

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		
		humanoid.Died:Connect(function()
			local tag = character:FindFirstChildOfClass("ObjectValue")
			
			if not tag then
				return
			end
			
			local killer = tag.Value
			
			if not character or not killer.Character then
				return
			end
			
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			local killerRootPart = killer.Character:FindFirstChild("HumanoidRootPart")
			
			if rootPart and killerRootPart then
				local distance = math.floor((rootPart.Position - killerRootPart.Position).Magnitude * 10) / 10
				
				updateFeed:FireAllClients(player.Name, killer.Name, distance)
			end
		end)
	end)
end)