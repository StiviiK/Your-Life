-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cLogHandler.lua		    	##
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

local logHandler = {
[1] = {[1] = "onClientDebugMessage", [2] = LogClientDebugMessages}
}

function startLogging ()
	for i, v in pairs(logHandler) do
		addEventHandler(v[1], getRootElement(), v[2])
	end
end
startLogging()