local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local itemHolder = script.Parent

local handlesModel = replicatedStorage.Handles

local tweenInfo = TweenInfo.new(
	8,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.In,
	-1
)

for _, child in pairs(itemHolder:GetChildren()) do
	if child:IsA("Frame") then
		child.ItemName.Text = child.Name
		
		local viewport = child.Viewport
		
		local weaponClone = handlesModel[child.Name]:Clone()
		weaponClone.Parent = viewport

		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new(Vector3.new(0, 0, -4.6), weaponClone.Position)
		camera.Parent = viewport

		viewport.CurrentCamera = camera

		tweenService:Create(weaponClone, tweenInfo, {Orientation = Vector3.new(360, 360, 360)}):Play()
	end
end