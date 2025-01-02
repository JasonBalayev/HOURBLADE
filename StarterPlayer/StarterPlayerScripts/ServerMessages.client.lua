pcall(function()
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "[Server]: " ..game.Players.LocalPlayer.Name.. " has joined the server!";
		Color = Color3.new(0,128,0);
		Font = Enum.Font.SourceSansBold;
		FontSize = Enum.FontSize.Size24;
	})
end)

game.Players.ChildAdded:Connect(function(player)
	if not pcall(function()
			game.StarterGui:SetCore("ChatMakeSystemMessage", {
				Text = "[Server]: " ..player.Name.. " has joined the server!";
				Color = Color3.new(0,128,0);
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
			})
		end) then
		print("Yikes")
	end
end)

game.Players.ChildRemoved:Connect(function(player)
	if not pcall (function()
			game.StarterGui:SetCore("ChatMakeSystemMessage", {
				Text = "[Server]: " ..player.Name.. " has left the server!";
				Color = Color3.new(255,0,0);
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
			})
		end) then
		print("Yikes")
	end
end)