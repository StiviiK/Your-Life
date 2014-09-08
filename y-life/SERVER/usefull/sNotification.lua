-- #######################################
-- ## Project: MTA Your-Life     	    ##
-- ## Name: sNotification.lua			##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

function infoBox (sendto, boxname, boxtext, boxtime)
	if isElement(sendto) and boxname ~= nil and boxtext ~= nil and tonumber(boxtime) ~= nil then
		boxname = tostring(boxname)
		boxtext = tostring(boxtext)
		boxtime = tonumber(boxtime)
		
		triggerClientEvent(sendto, "infoBox", sendto, boxname, boxtext, boxtime)
		
		return true;
	else
		return false;
	end
end

function textbox (player)
	infoBox(player, "hi", "hallo", 4000)
end
addCommandHandler("testbox", textbox)