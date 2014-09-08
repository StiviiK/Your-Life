-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sElementData.lua		   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Maybe later usefull?
_setElementData = setElementData
_getElementData = getElementData

-- ElementData Storage
ElementData = {}
SyncData = {}
ClientReady = {}

function setElementData (element, data, value, share)
	outputChatBox("TRUE")
	if (isElement(element)) and (data ~= nil) and (value ~= nil) then
		if (not ElementData[element]) then
			ElementData[element] = {}
		end
			
		ElementData[element][data] = value;
			
		if share == true then
			for i, v in pairs(getElementsByType("player")) do
				if ClientReady[v] then
					outputChatBox("True2")
					triggerClientEvent(v, "SyncElementData", element, element, data, value)
				end
			end
			
			if (not SyncData[element]) then
				SyncData[element] = {}
			end
		
			SyncData[element][data] = value
		end
		
		if ElementData[element][data] ~= nil then
			triggerEvent("onElementDataChange", element, element, data, value)
			return true;
		else
			outputDebugString("Error while Setting ElemenetData for "..tostring(element)..", data "..tostring(data).." and value "..tostring(value))
			return false;
		end
	else
		return false;
	end
end

function getElementData (element, data)
	if (isElement(element)) and (data ~= nil) then
		if ElementData[element] ~= nil then
			if ElementData[element][data] ~= nil then
				return ElementData[element][data];
			else
				return false;
			end
		else
			return false;
		end
	else
		return false;
	end
end

function sendElementData ()
	triggerClientEvent(source, "SyncElementData2", source, SyncData)
	triggerClientEvent(source, "sendFactionVehicles", source, factionVehicles)
end
addEventHandler("onPlayerJoin", root, sendElementData)

function onClientReady ()
	if source ~= client then return false; end
	ClientReady[client] = true
	
	triggerClientEvent(client, "receivedata", client, factionMembers)
	triggerClientEvent(client, "sendFactionVehicles", client, factionVehicles)
	triggerClientEvent(client, "SyncElementData2", client, SyncData)
end
addEvent("s_onClientReady", true)
addEventHandler("s_onClientReady", root, onClientReady)

addEventHandler("onElementDataChange", root, function (element, data, value)
	if (data == "player.money") then
		setPlayerMoney(element, getPlayerMoney(element) + value)
		WatchDog.setPlayerMoney(element, amount)
	end
end)