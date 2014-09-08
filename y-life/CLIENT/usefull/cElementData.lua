-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cElementData.lua		   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Maybe later usefull?
-- [[ _setElementData = setElementData (Disabled because of Security Reason's) ]]
_getElementData = getElementData

ElementData = {}
local AllowedElementData = {
	["player.id"] = true,
	["player.socialstate"] = true,
	["player.playtime"] = true,
	["player.faction"] = true,
	["player.adminlvl"] = true,
	["rank"] = true,
	["player.jailtime"] = true,
	["vehicle.tank"] = true,
	["vehicle.autonummer"] = true,
	["vehicle.besitzer"] = true,
	["vehicle.beschlagnahmt"] = true,
	["vehicle.zerstoert"] = true,
	["vehicle.faction"] = true,
	["vehicle.damage"] = true,
	["vehicle.frank"] = true
}

function setElementData ()
	return "Wow. Nice!"
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

function SyncElementData_func (element, data, value)
	outputChatBox("TRUE")

	if (isElement(element)) and (data ~= nil) then
		
		if (not AllowedElementData[string.lower(data)]) then return false; end
		
		if (not ElementData[element]) then
			ElementData[element] = {}
		end
		
		ElementData[element][data] = value;
		
		if ElementData[element][data] ~= nil then
			return true;
		else
			outputDebugString("Error while Setting Client-ElemenetData for "..tostring(element).." and Data "..tostring(value))
			return false;
		end
	end
end
addEvent("SyncElementData", true)
addEventHandler("SyncElementData", root, SyncElementData_func)

function SplitElementData (SyncData)
	for element, _ in pairs(SyncData) do
		for data, value in pairs(SyncData[element]) do
			--outputChatBox("ELEMENT: ["..tostring(element).."]; INDEX: ["..tostring(data).."]; DATA: ["..tostring(value).."]") -- DEBUG
			
			if (not ElementData[element]) then
				ElementData[element] = {}
			end
			
			if AllowedElementData[string.lower(data)] then
				ElementData[element][data] = value
			end
		end
	end
end
addEvent("SyncElementData2", true)
addEventHandler("SyncElementData2", root, SplitElementData)