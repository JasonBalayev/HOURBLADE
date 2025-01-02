local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local webhook = "https://discord.com/api/webhooks/822074361141395507/DDlkpYnr5lpkBpWkQjJ4UVW1c1-dcesopzLQ-874Uq77KMSYWuAjBTJqiHWGIo_EHU_3"

Players.PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(msg)
		local data = {
			content = msg;
			username = plr.Name .. " - (#" .. plr.UserId .. ")";
			avatar_url = "http://www.roblox.com/Thumbs/Avatar.a...​"..plr.UserId
		}
		HttpService:PostAsync(webhook, HttpService:JSONEncode(data))
	end)
end)
