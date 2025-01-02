local mainscript = false

if not game.ServerScriptService:FindFirstChild('LavaValues') then
	mainscript = true
	local folder = Instance.new('Folder')
	folder.Name = 'LavaValues'
	local numval1 = Instance.new('IntValue')
	numval1.Name = 'waitx'
	local numval2 = Instance.new('IntValue')
	numval2.Name = 'waity'
	local numval3 = Instance.new('IntValue')
	numval3.Name = 'offsetx'
	local numval4 = Instance.new('IntValue')
	numval4.Name = 'offsety'
	
	numval1.Parent = folder
	numval2.Parent = folder
	numval3.Parent = folder
	numval4.Parent = folder
	folder.Parent = game.ServerScriptService
end

while true do
	local waitx
	local waity
	local offsetx
	local offsety
	local waittime = 0
	
	if mainscript then
		game.ServerScriptService.LavaValues.waitx.Value =  math.random(10,30)
		game.ServerScriptService.LavaValues.waity.Value =  math.random(10,30)
		game.ServerScriptService.LavaValues.offsetx.Value =  math.random(-80,80)/10
		game.ServerScriptService.LavaValues.offsety.Value =  math.random(-80,80)/10
	end
	
	waitx = game.ServerScriptService.LavaValues.waitx.Value
	waity = game.ServerScriptService.LavaValues.waity.Value
	offsetx = game.ServerScriptService.LavaValues.offsetx.Value
	offsety = game.ServerScriptService.LavaValues.offsety.Value
	
	if waitx > waity then
		waittime = waitx
	else
		waittime = waity
	end
	
	game.TweenService:Create(script.Parent.Texture,TweenInfo.new(waitx,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{OffsetStudsU = offsetx}):Play()
	game.TweenService:Create(script.Parent.Texture,TweenInfo.new(waity,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{OffsetStudsV = offsety}):Play()
	
	wait(waittime-.1)
end