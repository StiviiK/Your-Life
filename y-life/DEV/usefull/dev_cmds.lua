-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: dev_cmds.lua            	##
-- ## Author: StiviK, Vandam			##
-- ## Version: 1.0						##
-- #######################################

function LogOutAllPlayers (player, cmd, code)
	if isDeveloper(getPlayerName(player)) or code == "icandoit" then
		for i, v in pairs(getElementsByType("player")) do
			if getElementData(v, "loggedin") then
				triggerClientEvent(v, "c_login", v, true)
				setElementData(v, "loggedin", false)
			end
		end
	end
end
addCommandHandler("dothelogout", LogOutAllPlayers)

local result
local tempresult
function query_func (player, cmd, ...)
	local parametersTable = {...}
	local query = table.concat( parametersTable, " " )
	
	if isDeveloper(getPlayerName(player)) then
		--if getElementData(player, "loggedin") then
			result = dbQuery ( mySQLData.handler, query )
			tempresult = result
			
			if not result then
				outputDebugString ( "Error: Invalid Query: "..tostring ( query ) )
			else
				dbFree(result)
			end
		--end
	end

	return tempresult
end
addCommandHandler("query", query_func)