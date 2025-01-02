function removeAllKatanas(katanasToRemove)
	
	for i = 1, #katanasToRemove do
		katanasToRemove[i]:remove()
	end

end

function createEpicKatana(orangeSword)

	local epicKatanaHandle = orangeSword.Handle:clone()
	epicKatanaHandle.Mesh.VertexColor = Vector3.new(0,0,0)
	--local epicKatanaMesh = orangeSword.Handle.Mesh:clone()
	--epicKatanaMesh.VertexColor = Vector3.new(0,0,0)
	--epicKatanaMesh.Parent = epicKatanaHandle

	EpicKatanaTool = Instance.new("Tool")
	EpicKatanaTool.GripForward = Vector3.new(-1,0,0)
	EpicKatanaTool.GripPos = Vector3.new(0,0,-1.7)
	EpicKatanaTool.GripRight = Vector3.new(-1,0,0)
	EpicKatanaTool.GripUp =  Vector3.new(0,0,1)
	EpicKatanaTool.Name = "EpicKatana"
	EpicKatanaTool.TextureId = "http://www.roblox.com/asset/?id=25265469"

	script.EpicKatanaScript.Disabled = false
	script.EpicKatanaScript.Parent = EpicKatanaTool
	
	localGui = orangeSword:FindFirstChild("Local Gui"):clone()
	localGui.Parent = EpicKatanaTool
--	script:FindFirstChild("Local Gui").Disabled = false
--	script:FindFirstChild("Local Gui").Parent = EpicKatanaTool

	EpicKatanaTool.Enabled = false
	epicKatanaHandle.Parent = EpicKatanaTool
	
	EpicKatanaTool.Parent = script.Parent
	orangeSword:remove()
	script:remove()
end


while true do

	wait(3)
	local orangeSword = nil
	p = game.Players:GetPlayerFromCharacter(script.Parent)
	local swordCounter = 0
	if p ~= nil then
		BackpackItems = p.Backpack:GetChildren()
		local katanas = {}

		for i = 1, #BackpackItems do
			if BackpackItems[i].Name == "BlueKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "GreenKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "RedKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "YellowKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "purpleKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "OrangeKatana" then
				table.insert(katanas,BackpackItems[i])
				if orangeSword == nil then
					orangeSword = BackpackItems[i]:clone()
					orangeSword.Parent = nil
				end
				swordCounter = swordCounter + 1
			end
		end

		BackpackItems = script.Parent:GetChildren()
		for i = 1, #BackpackItems do
			if BackpackItems[i].Name == "BlueKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "GreenKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "RedKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "YellowKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "PurpleKatana" then
				table.insert(katanas,BackpackItems[i])
				swordCounter = swordCounter + 1
			elseif BackpackItems[i].Name == "OrangeKatana" then
				table.insert(katanas,BackpackItems[i])
				if orangeSword == nil then
					orangeSword = BackpackItems[i]:clone()
					orangeSword.Parent = nil
				end
				swordCounter = swordCounter + 1
			end
		end

		if swordCounter >= 6 then

			wait(3)
			removeAllKatanas(katanas)
			createEpicKatana(orangeSword)

		end
	end
end
