local debounce = true

function touch(prt)
	if debounce and prt and prt.Parent and ((prt.Parent:IsA("Tool") and script.Parent.BurnTools.Value) or game.Players:GetPlayerFromCharacter(prt.Parent)) then
		if (prt.Parent:FindFirstChild('Humanoid') and prt.Parent.Humanoid.Health == 0) or prt:FindFirstChild('Sssh') then return end
		debounce = false
		local snd = script.Parent.Sssh:Clone()
		snd.Parent = prt
		snd.PlaybackSpeed = math.random(80,150)/100
		snd:Play()
		if prt.Parent:FindFirstChild("Humanoid") then
			prt.Parent.Humanoid:TakeDamage(100)
		elseif prt.Parent:IsA("Tool") then
			game.Debris:AddItem(prt.Parent,.5)	
		end
		wait(.5)
		debounce = true
	end
end

script.Parent.Touched:Connect(touch)

