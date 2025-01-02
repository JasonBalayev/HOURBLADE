------------------
-- Made by TetraAdur --
------------------

local FlySettings = {
	StrikesUntilRefresh = 6; 
	StrikesUntilKick = 0;  
	MaxHeight =  Vector3.new(0,-40,0); 
	Intervals = 15;  
	AddStrikeIfPlatformStanding = true;  
};

local PlayerStrikes = {};
local KickStrikes = {};

local Players = game:GetService("Players");
local RS = game:GetService("RunService")

Players.PlayerAdded:Connect(function(player)  
	player.CharacterAdded:Connect(function(character)
		PlayerStrikes[player.Name] = 0;  
	end)
	KickStrikes[player.Name] = 0;
end)


Players.PlayerRemoving:Connect(function(player)
	PlayerStrikes[player.Name] = nil;  
	KickStrikes[player.Name] = nil;
end)

local function RefreshPlayer(player, pos)  
	player:LoadCharacter();
	player.Character:SetPrimaryPartCFrame(CFrame.new(pos));
	local ForceField = player.Character:FindFirstChildWhichIsA("ForceField");
	if (ForceField) then
		ForceField:Destroy();
	end
end

CurrentInterval = 0;
RS.Heartbeat:Connect(function()
	if (CurrentInterval >= FlySettings.Intervals) then
		CurrentInterval = 0;
		local Characters = {};  
		for _, player in pairs(Players:GetPlayers()) do
			if (player.Character) then
				table.insert(Characters, player.Character);
			end 
		end
		local FlyParams = RaycastParams.new()  
		FlyParams.FilterType = Enum.RaycastFilterType.Exclude;
		FlyParams.FilterDescendantsInstances = Characters;

		for _, player in pairs(game.Players:GetPlayers()) do
			if (player.Character) then  
				local Root = player.Character:FindFirstChild("HumanoidRootPart");
				local Humanoid = player.Character:FindFirstChild("Humanoid");
				local Head = player.Character:FindFirstChild("Head");
				if (Humanoid and Humanoid.Health > 0) then  
					if (not Root) then  
						continue;
					end

					local FoundGround = workspace:Raycast(Root.Position, FlySettings.MaxHeight, FlyParams);
					if (not FoundGround) then  
						if (FlySettings.AddStrikeIfPlatformStanding) then
							if (Humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding) then
								PlayerStrikes[player.Name] += 2;
							else
								PlayerStrikes[player.Name] += 1;
							end
						end
						
					
						
						if (PlayerStrikes[player.Name] >= FlySettings.StrikesUntilRefresh) then  
							if (KickStrikes[player.Name] >= FlySettings.StrikesUntilKick) then 
								player:Kick("Kicked for exploiting");
								continue;
							end
							local GroundPos = Root.Position;  
							local FindingGround = workspace:Raycast(Root.Position, Vector3.new(0,-300,0), FlyParams);
							if (FindingGround) then
								GroundPos = FindingGround.Position+Vector3.new(0,5,0)  
							end
							PlayerStrikes[player.Name] = 0;
							RefreshPlayer(player, GroundPos);  
							KickStrikes[player.Name] += 1;
						end
					end
				end
			end
		end
	end
	CurrentInterval += 1;
end)

