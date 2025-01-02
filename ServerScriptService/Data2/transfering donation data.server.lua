--[[

NEVER ENABLE THIS SCRIPT

IF YOU DO IM GETTING YOU FIRED

----------

NEVER ENABLE THIS SCRIPT

IF YOU DO IM GETTING YOU FIRED

----------

NEVER ENABLE THIS SCRIPT

IF YOU DO IM GETTING YOU FIRED

----------

NEVER ENABLE THIS SCRIPT

IF YOU DO IM GETTING YOU FIRED

----------

NEVER ENABLE THIS SCRIPT

IF YOU DO IM GETTING YOU FIRED

----------

NEVER ENABLE THIS SCRIPT

IF YOU DO IM GETTING YOU FIRED

]]

local settings = {
	previous = "",
}

local dss = game:GetService("DataStoreService")
local sss = game:GetService("ServerScriptService")
local d2 = sss:WaitForChild("Data2")
local dm = require(d2:WaitForChild("DataManager"))
local am = require(d2:WaitForChild("ActiveManager"))

local dataTemplate = require(sss:WaitForChild("Data2"):WaitForChild("DataManager"):WaitForChild("DataTemplate"))

if settings.previous == "" then return end

local orderedDataStore;
local s, e = pcall(function()
	orderedDataStore = dss:GetOrderedDataStore(settings.previous)
end)

local pages = orderedDataStore:GetSortedAsync(false, 100)
local ranks = pages:GetCurrentPage()

for rank, data in pairs(ranks) do
	local pId = data.key
	
	local pdata = dss:GetDataStore(pId):GetAsync("DEVELOPMENT-0.0.1") or dataTemplate
	
	am:open(pId, pdata)
	
	am:edit(pId, {{path="Donated.data", method="set", data=data.value}})
	
	am:close(pId)
end