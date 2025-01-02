-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain



-- << CLIENT COMMANDS >>
local module = {
	
	----------------------------------------------------------------------
	["commandName1"] = {
		Function = function(speaker, args)
			
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["commandName2"] = {
		Function = function(speaker, args)
			
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	
};



-- << SETUP >>
for commandName, command in pairs(module) do
	command.Name = commandName
end



return module