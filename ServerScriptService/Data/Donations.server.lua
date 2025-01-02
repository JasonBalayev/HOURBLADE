local dataStoreService = game:GetService("DataStoreService")
local marketplaceService = game:GetService("MarketplaceService")

local donationData = dataStoreService:GetOrderedDataStore("DonationData")

local ids = {
	[2681900005] = 10,
	[2681900171] = 50,
	[2681900594] = 100,
	[2681900789] = 1000,
	[2681901036] = 10000
}

marketplaceService.ProcessReceipt = function(receiptInfo)
	if ids[receiptInfo.ProductId] then
		donationData:IncrementAsync(receiptInfo.PlayerId, ids[receiptInfo.ProductId])
	end
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end