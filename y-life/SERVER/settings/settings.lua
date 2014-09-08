-- ## Project: MTA Your-Life    	    ##
-- ## Name: config.lua   			  	##
-- ## Author: StiviK, Vandam			##
-- ## Version: 1.0						##
-- #######################################

-- read MySQL Data Config (IMPORTANT)
local file = fileOpen("SERVER/mysql/mysql_data.config")
if (file) then
	local status, errmsg = pcall(loadstring(fileRead(file, fileGetSize(file))))
	if (not status) then
		error(errmsg, 0)
	end
else
	outputDebugString("MySQL Data Config not found!", 2)
	stopResource(getThisResource())
	setGameType("Startup failure!")
end
--

-- Usefull
function isNumber (st)
	if tonumber(st) ~= nil then
		return true;
	end
	
	return false;
end

function isBoolean (st)
	if type(st) == "string" then
		if (st:lower():find("true")) or (st:lower():find("false")) then
			return true;
		end
	elseif type(st) == "boolean" then
		return true;
	end
	
	return false;
end

function toboolean (st)
	if (st:lower():find("true")) then
		return true;
	elseif (st:lower():find("false")) then
		return false;
	end
		
	return nil;
end

-- MySQL
Developer = {
[1] = "Vandam",
[2] = "StiviK"
}

-- Developer
local isDeveloperName = {
["Vandam"] = true,
["StiviK"] = true
}

-- Anti Nickchange
function backchange ( oldnick, newnick )
	infoBox (getPlayerFromName ( oldnick ), "small", "Error", "Du darfst deinen Namen nicht ändern!", 3000)
	--outputChatBox ( "Du darfst deinen Namen nicht ändern!", getPlayerFromName ( oldnick ), 125, 0, 0 )
	cancelEvent()
end
addEventHandler ( "onPlayerChangeNick", getRootElement(), backchange )

-- isDeveloper Function
function isDeveloper (value)
	if isDeveloperName[value] then
		return true
	else
		return false
	end
end

-- Is Eventhanlder added
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 
		type( sEventName ) == 'string' and 
		isElement( pElementAttachedTo ) and 
		type( func ) == 'function' 
	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end
 
	return false
end

-- Remove Player from Table
function removePlayerFromTable (currtable, value)
	for k, v in pairs(currtable) do 
		if value == v then
			table.remove(currtable, k )
		end
	end
end