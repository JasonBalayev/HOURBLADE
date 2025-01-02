local runService = game:getService("RunService")
local debris = game:GetService("Debris")
local players = game:GetService("Players")

local soundRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlaySound")

local tool = script.Parent
local sword = tool.Handle

local player = tool.Parent.Parent

local currentDamage = 6
local slashDamage = 6
local lungeDamage = 66

local lastAttack = 0

local sounds = tool.Sounds
local unsheathSound = sounds.Unsheath
local slashSound = sounds.Slash
local lungeSound = sounds.Lunge

local function swordUp()
	tool.GripForward = Vector3.new(-1, 0, 0)
	tool.GripRight = Vector3.new(0, 1, 0)
	tool.GripUp = Vector3.new(0, 0, 1)
end

local function swordOut()
	tool.GripForward = Vector3.new(0, 0, 1)
	tool.GripRight = Vector3.new(0, -1, 0)
	tool.GripUp = Vector3.new(-1, 0, 0)
end

local function playSound(sound)
	soundRemote:FireClient(player, sound)
end

local function slash()
	local slashAnimation = Instance.new("StringValue")
	slashAnimation.Name = "toolanim"
	slashAnimation.Value = "Slash"
	slashAnimation.Parent = tool

	playSound(slashSound)
end

local function lunge()
	local lungeAnimation = Instance.new("StringValue")
	lungeAnimation.Name = "toolanim"
	lungeAnimation.Value = "Lunge"
	lungeAnimation.Parent = tool

	wait(0.25)
	swordOut()

	playSound(lungeSound)

	wait(0.75)
	swordUp()
end

local function activated()
	if not tool.Enabled then
		return
	end

	tool.Enabled = false

	local frame = runService.Stepped:Wait()

	if frame - lastAttack < 0.2 then
		currentDamage = lungeDamage

		lunge()
	else
		currentDamage = slashDamage

		slash()
	end

	lastAttack = frame

	tool.Enabled = true
end


local function equipped()
	playSound(unsheathSound)
end

local function createTag(character, killer)
	local tagCheck = character:FindFirstChildOfClass("ObjectValue")

	if tagCheck then
		tagCheck:Destroy()
	end

	local tag = Instance.new("ObjectValue")
	tag.Name = killer.Name
	tag.Value = killer
	tag.Parent = character
end

local function damage(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	local killerCharacter = tool.Parent
	local killer = players:GetPlayerFromCharacter(killerCharacter)

	if not humanoid or humanoid.Health <= 0 or killerCharacter.Humanoid.Health <= 0 then
		return
	end

	if character:FindFirstChild("HumanoidRootPart") then
		if (character.HumanoidRootPart.Position - sword.Position).Magnitude > 12 then
			return
		end
	end

	if players:GetPlayerFromCharacter(character).Safe.Value or killer.Safe.Value then
		return
	end

	local rightArm = killerCharacter:FindFirstChild("Right Arm")

	if rightArm then
		local joint = rightArm:FindFirstChild("RightGrip")

		if joint then
			if joint.Part0 == sword or joint.Part1 == sword then
				if humanoid.Health - currentDamage < 0 then
					humanoid:TakeDamage(humanoid.Health)
				else
					humanoid:TakeDamage(currentDamage)
				end

				createTag(character, killer)
			end
		end
	end
end

tool.Equipped:Connect(equipped)
tool.Activated:Connect(activated)
sword.Touched:Connect(damage)