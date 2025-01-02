local collectionService = game:GetService("CollectionService")

local swordScript = script:WaitForChild("SwordScript")


for _, sword in pairs(collectionService:GetTagged("Sword")) do
	if sword:IsA("Tool") then
		local newScript = swordScript:Clone()
		newScript.Parent = sword
		newScript.Enabled = true
	end
end