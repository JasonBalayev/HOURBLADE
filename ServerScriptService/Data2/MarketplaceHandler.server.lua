--[[

Author: ARCHIE0709
Last Modified: 31/12/2024

Description: Manager for giving out rewards after purchase

]]

--// Variables
-- Services
local MarketPlaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local data2 = ServerScriptService:WaitForChild("Data2")
local activeManager = require(data2:WaitForChild("ActiveManager"))

-- Tables
local valueProducts = {
	-- Donations
	[2681900005] = {path = "Donated.data", amount = 10},
	[2681900171] = {path = "Donated.data", amount = 50},
	[2681900594] = {path = "Donated.data", amount = 100},
	[2681900789] = {path = "Donated.data", amount = 1000},
	[2681901036] = {path = "Donated.data", amount = 10000},
	[2686745199] = {path = "Donated.data", amount = 25000},
}

local eventProducts = {
	
}


--// Functions


--// Main
MarketPlaceService.ProcessReceipt = function(receiptInfo)
	local valueInfo = valueProducts[receiptInfo.ProductId]
	if valueInfo then
		activeManager:edit(receiptInfo.PlayerId, {{path = valueInfo.path, method = "add", data = valueInfo.amount}})
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	
	local eventInfo = eventProducts[receiptInfo.ProductId]
	if eventInfo then
		warn("add the event shi")
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end