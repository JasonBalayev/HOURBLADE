local settings = {
	waitBetweenTips = 5,
}

local tips = {
	"Want a VIP Chat Tag and a sword? Buy the 💎 VIP Gamepass!",
	"Join the discord server for game updates and concerns!",
	"Make sure to like & favorite the game for future updates!",
}
local lastTip;


local function changeTip()
	local tipNumber;
	repeat tipNumber = math.random(1, #tips)
	until tipNumber ~= lastTip
	
	lastTip = tipNumber
	script.Parent.Text = "Tip: " .. tips[tipNumber]
end

local function tipsManager()
	while true do
		changeTip()
		task.wait(settings.waitBetweenTips)
	end
end

tipsManager()