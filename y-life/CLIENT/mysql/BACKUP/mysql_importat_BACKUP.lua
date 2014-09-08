-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: important_settings.lua 	  	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Anti Table Manipulation
function setTableProtected (tbl)
	return setmetatable ({}, 
	{
	__index = tbl,
	__newindex = function (t, n, v)
		error ("attempting to change constant " ..tostring(n) .." to "..tostring(v), 2)
	end
	})
end

-- Protect the MySQL Table
mySQLData = setTableProtected(mySQLData)