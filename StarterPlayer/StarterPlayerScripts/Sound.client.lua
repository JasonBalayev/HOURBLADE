local soundRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlaySound")

soundRemote.OnClientEvent:Connect(function(sound)
	sound:Play()
end)