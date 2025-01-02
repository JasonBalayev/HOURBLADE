--[[

Author: ARCHIE0709
Last Edited: 30/12/2024
Description: Template for user data

]]

local dataTemplate = {
	-- leaderstats
	Time = {leaderstat = true, data = 0},
	["Best Time"] = {leaderstat = true, data = 0, leaderboard = true},
	Level = {leaderstat = true, data = 0, leaderboard = true},
	Kills = {leaderstat = true, data = 0, leaderboard = true},
	
	-- values
	Experience = {value = true, data = 0},
	
	-- other
	Donated = {data = 0, leaderboard = true},
	
	-- tables
	Equipped = {
		data = {},
	},
}

return dataTemplate