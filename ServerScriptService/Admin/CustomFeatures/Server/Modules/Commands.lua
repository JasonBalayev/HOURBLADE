-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local settings = main.settings



-- << COMMANDS >>
local module = {
	
	-----------------------------------
	{
	Name = "";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {};
	--
	Args = {};
	Function = function(speaker, args)
		
	end;
	UnFunction = function(speaker, args)
		
	end;
	--
	};
	
	
	
	
	-----------------------------------
	{
	Name = "";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {};
	--
	Args = {};
	--[[
	ClientCommand = true;
	FireAllClients = true;
	BlockWhenPunished = true;
	PreFunction = function(speaker, args)
		
	end;
	Function = function(speaker, args)
		wait(1)
	end;
	--]]
	--
	};
	
	
	
	
	-----------------------------------
	
};



return module
