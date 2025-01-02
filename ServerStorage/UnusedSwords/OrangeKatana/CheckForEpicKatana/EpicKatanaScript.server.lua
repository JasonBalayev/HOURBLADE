-------- OMG HAX

r = game:service("RunService")
local sword = script.Parent.Handle
local Tool = script.Parent

local damage = 15
local p = nil
local humanoid = nil

local slash_damage = 30
local lunge_damage = 42
local regularWalk = 16


local SlashSound = Instance.new("Sound")
SlashSound.SoundId = "rbxasset://sounds\\swordslash.wav"
SlashSound.Parent = sword
SlashSound.Volume = .7

local UnsheathSound = Instance.new("Sound")
UnsheathSound.SoundId = "rbxasset://sounds\\unsheath.wav"
UnsheathSound.Parent = sword
UnsheathSound.Volume = 1

local epicLungeSound = Instance.new("Sound")
epicLungeSound.SoundId = "http://www.roblox.com/asset/?id=25256253"
epicLungeSound.Parent = sword
epicLungeSound.Volume = .8

sparkles1 = Instance.new("Sparkles")
sparkles1.Name = "Sparkles1"
sparkles1.SparkleColor = Color3.new(1,1,1)
sparkles1.Parent = Tool.Handle

sparkles2 = Instance.new("Sparkles")
sparkles2.Name = "Sparkles1"
sparkles2.SparkleColor = Color3.new(1,0,1)
sparkles2.Parent = Tool.Handle

function blow(hit)
	local humanoid = hit.Parent:findFirstChild("Humanoid")
	local vCharacter = Tool.Parent
	local vPlayer = game.Players:playerFromCharacter(vCharacter)
	local hum = vCharacter:findFirstChild("Humanoid") -- non-nil if tool held by a character
	if humanoid~=nil and humanoid ~= hum and hum ~= nil then
		-- final check, make sure sword is in-hand

		local right_arm = vCharacter:FindFirstChild("Right Arm")
		if (right_arm ~= nil) then
			local joint = right_arm:FindFirstChild("RightGrip")
			if (joint ~= nil and (joint.Part0 == sword or joint.Part1 == sword)) then
				tagHumanoid(humanoid, vPlayer)
				humanoid:TakeDamage(damage)
				wait(1)
				untagHumanoid(humanoid)
			end
		end


	end
end


function tagHumanoid(humanoid, player)
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

function changeSparkleColor()

	sparkles1 = Tool.Handle:FindFirstChild("Sparkles1")
	if sparkles1 ~= nil then
		colorOfSparkle = Color3.new(math.random(-5,5),math.random(-10,12),math.random(0,15))
		sparkles1.SparkleColor = colorOfSparkle
	end
	sparkles2 = Tool.Handle:FindFirstChild("Sparkles2")
	if sparkles2 ~= nil then
		colorOfSparkle = Color3.new(math.random(-21,12),math.random(-2,3),math.random(-20,15))
		sparkles2.SparkleColor = colorOfSparkle
	end

end

function attack()
	damage = slash_damage
	SlashSound:play()
	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Slash"
	anim.Parent = Tool
end

function lunge()
	damage = lunge_damage

	humanoid.WalkSpeed = regularWalk + 100
	epicLungeSound:play()

	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Lunge"
	anim.Parent = Tool
	
	force = Instance.new("BodyVelocity")
	force.velocity = Vector3.new(0,10,0) --Tool.Parent.Torso.CFrame.lookVector * 80
	force.Parent = Tool.Parent.Torso
	wait(.2)
	swordOut()
	wait(.2)
	force.Parent = nil
	wait(.4)
	swordUp()

	humanoid.WalkSpeed = regularWalk + 2

	damage = slash_damage
end

function swordUp()
	Tool.GripForward = Vector3.new(-1,0,0)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(0,0,1)
end

function swordOut()
	Tool.GripForward = Vector3.new(0,0,1)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(1,0,0)
end

function swordAcross()
	-- parry
end


Tool.Enabled = true
local last_attack = 0
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character.Humanoid
	if humanoid == nil then
		print("Humanoid not found")
		return 
	end

	t = r.Stepped:wait()

	if (t - last_attack < .2) then
		lunge()
	else
		attack()
	end

	last_attack = t

	--wait(.5)

	Tool.Enabled = true
end

function onEquipped()
	
	humanoid = Tool.Parent:FindFirstChild("Humanoid")
	UnsheathSound:play()
	humanoid.WalkSpeed = regularWalk + 2
	p = game.Players:GetPlayerFromCharacter(Tool.Parent)

end

function empty()

end

function onUnequipped()

	humanoid.WalkSpeed = regularWalk

end

Tool.Unequipped:connect(onUnequipped)
script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)

connection = sword.Touched:connect(blow)

while true do

	wait(3)
	changeSparkleColor()
	
end
