-- #######################################
-- ## Project: MTA Y-Updater    	    ##
-- ## Name: ResourceHandler.lua		   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

function handleRemoteResource (stype, resourcename)
	if stype then
		if getResourceState(getResourceFromName(resourcename)) == "loaded" then
			startResource(getResourceFromName(resourcename))
		end
	else
		if getResourceState(getResourceFromName(resourcename)) == "running" then
			stopResource(getResourceFromName(resourcename))
		end
	end
end