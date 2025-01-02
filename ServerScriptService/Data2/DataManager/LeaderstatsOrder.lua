--[[

Author: ARCHIE0709
Last Edited: 30/12/2024
Description: Ensures leaderstats are created in the correct order

Notes: 
 *	- This module can safely be deleted, main will continue to function if it is deleted
 *	- If not deleted, then table must be filled out completely with all leaderstat names
	- Numbers in the table determine the order in which leaderstats appear on the leaderboard
	- Duplicate numbers/names are not allowed
	- If a leaderstat name is not found, then it will not appear on the leaderboard
]]

local module = {
	[1] = "Best Time",
	[2] = "Time",
	[3] = "Level",
	[4] = "Kills",
}

return module
