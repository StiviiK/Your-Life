-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sLogHandler.lua		    	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

function getLog (path)
	if (not fileExists(path)) then
		fileClose(fileCreate(path))
	end
	
	return fileOpen(path)
end

function existsLog (log)
	if fileExists(log) then
		return true;
	else
		return false;
	end
end

function WriteLog (log, text)
	if (log ~= nil) and (text ~= nil) then
		local size = fileGetSize ( log )
		fileSetPos ( log, size )
		fileWrite ( log, text.."\n" )
		fileClose ( log )
	end
end

-- Add Custom Events
addEvent("onPlayerCustomChat", true)
addEvent("onFactionCustomChat", true)
--addEvent("onFactionDataChange", true)
addEvent("onAdminBanAction", true)

local logHandler = {
	[1] = {[1] = "onDebugMessage", [2] = LogDebugMessages},
	[2] = {[1] = "onPlayerJoin", [2] = LogOnPlayerConnect},
	[3] = {[1] = "onPlayerQuit", [2] = LogOnPlayerQuit},
	[4] = {[1] = "onPlayerWasted", [2] = LogOnPlayerWasted},
	[5] = {[1] = "onPlayerCustomChat", [2] = LogOnPlayerCustomChat},
	[6] = {[1] = "onFactionCustomChat", [2] = LogOnFactionCustomChat},
	[7] = {[1] = "onAdminBanAction", [2] = LogOnAdminBanAction}
	--[7] = {[1] = "onFactionDataChange", [2] = LogOnFactionDataChange}
}

function startLogging ()
	for i, v in pairs(logHandler) do
		addEventHandler(v[1], getRootElement(), v[2])
	end
end
startLogging()