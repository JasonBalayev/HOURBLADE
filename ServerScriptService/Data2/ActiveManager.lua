--[[

Author: ARCHIE0709
Last Edited: 30/12/2024
Description: Manager for storing all player data on server

]]

local ActiveManager = {}

--// Variables
-- Services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Tables
local serverData = {}

-- Bindables
local dataBindables = ServerStorage:WaitForChild("Bindables"):WaitForChild("Data")
local setLeaderboard = dataBindables:WaitForChild("SetLeaderboard")


--// Functions
-- Internal
local editFunctions = {
	set = function(parentTable, key, value)
		parentTable[key] = value
	end,
	add = function(parentTable, key, value)
		parentTable[key] += value
	end,
	subtract = function(parentTable, key, value)
		parentTable[key] -= value
	end,
}

local function getPath(userId, route)
	local parent = serverData[userId]
	
	for i, key in pairs(route) do
		if #route > 1 and i == #route then continue end
		parent = parent[key]
		if not parent then return nil, nil end
	end
	
	return parent, route[#route]
end

local function setValue(userId, folder, valueName, value, method)
	local player = Players:GetPlayerByUserId(userId)
	if not player then return end
	
	local folder = player:FindFirstChild(folder)
	if not folder then return end
	
	local valueObject = folder:FindFirstChild(valueName)
	if not valueObject then return end
	
	--valueObject.Value = value
	editFunctions[method](valueObject, "Value", value)
end

-- Callable
function ActiveManager:open(userId, data)
	serverData[userId] = data
end

function ActiveManager:view(userId, fields)
	if fields == "all" then 
		return serverData[userId]
	elseif type(fields) == "table" then
		local toReturn = {}
		for i, field in pairs(fields) do
			repeat task.wait(0.25) until serverData[userId]
			toReturn[i] = serverData[userId][field].data
		end
		return toReturn
	else
		warn("Fields is not a valid type")
		warn("UserId: " .. userId .. " Field:")
		warn(fields)
		return false
	end
end

--[[
instruction = {
	path = "PATH", eg "level", "inventory.sword1.equipped"
	method = "METHOD", eg "set", "add", "subtract"
	data = "VALUE",
	
	leaderstat = true, *
	value = true, *
}
* = optional
]]
function ActiveManager:edit(userId, instructions)
	for _, instruction in pairs(instructions) do
		local route = string.split(instruction.path, ".")
		local parentTable, key = getPath(userId, route)
		if not parentTable or not key then continue end
		
		editFunctions[instruction.method](parentTable, key, instruction.data)
		if parentTable.leaderstat then
			setValue(userId, "leaderstats", route[1], instruction.data, instruction.method)
		elseif parentTable.value then
			setValue(userId, "values", route[1], instruction.data, instruction.method)
		end
		
		if parentTable.leaderboard then
			setLeaderboard:Fire(userId, route[1], parentTable[key])
		end
	end
end

function ActiveManager:close(userId)
	local data = serverData[userId]
	if data == nil then return false end
	serverData[userId] = nil
	return data
end


--// Main
return ActiveManager