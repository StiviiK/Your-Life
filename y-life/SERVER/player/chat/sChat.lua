-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sChat.lua				   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Tabels
local chatcol_small = {}
local chatcol_normal = {}
local chatcol_big = {}
local x
local y
local z

-- Settings
local chatcol_small_size = 5
local chatcol_normal_size = 15
local chatcol_big_size = 25

function localChat_func (message, msgtype)
	cancelEvent()
	
	if msgtype == 1 then 
		outputChatBox("This function is disabled!", source, 125, 0, 0)
		return false; 
	end
	
	if msgtype == 2 then
		return false;
	end
	
	if getElementData(source, "loggedin") then
		local tempCol = addChatCol(source, "normal")
		
		-- DEBUG
		--outputChatBox(table.getn(getElementsWithinColShape(chatcol_normal[source])))
	
		for i, v in ipairs(getElementsWithinColShape(chatcol_normal[source], "player")) do
			--outputChatBox(getPlayerName(source).." sagt: "..message, v, 255, 255, 255, false)
			chatboxMessage(v, source, message)
		end
	
		destroyElement(tempCol)
		triggerEvent("onPlayerCustomChat", source, message, msgtype)
	else
		outputChatBox("You can't Chat until you are logged in!", source, 125, 0, 0)
	end
end
addEventHandler("onPlayerChat", root, localChat_func)

function shoutChat_func (player, cmd, ...)
	local parameters = {...}
	local message = table.concat(parameters, " ")
	
	if getElementData(player, "loggedin") then
		local tempCol = addChatCol(player, "big")
	
		-- DEBUG
		--outputChatBox(table.getn(getElementsWithinColShape(chatcol_big[player], "player")))
	
		for i, v in ipairs(getElementsWithinColShape(chatcol_big[player], "player")) do
			--outputChatBox(getPlayerName(player).." schreit: "..message.."!!!", v, 255, 255, 255, false)
			chatboxMessage(v, player, message, "schreit")
		end
	
		destroyElement(tempCol)
		triggerEvent("onPlayerCustomChat", player, message, 2)
	else
		outputChatBox("You can't Chat until you are logged in!", player, 125, 0, 0)
	end
end
addCommandHandler("s", shoutChat_func)
addCommandHandler("Schreien", shoutChat_func)
--addCommandHandler("shout", shoutChat_func)

function whisperChat_func (player, cmd, ...)
	local parameters = {...}
	local message = table.concat(parameters, " ")
	
	if getElementData(player, "loggedin") then
		local tempCol = addChatCol(player, "small")

		-- DEBUG
		--outputChatBox(table.getn(getElementsWithinColShape(chatcol_small[player], "player")))
		
		for i, v in ipairs(getElementsWithinColShape(chatcol_small[player])) do
			--outputChatBox(getPlayerName(player).." flüstert: "..message, v, 255, 255, 255, false)
			chatboxMessage(v, player, message, "flüstert")
		end
	
		destroyElement(tempCol)
		triggerEvent("onPlayerCustomChat", player, message, 3)
	else
		outputChatBox("You can't Chat until you are logged in!", player, 125, 0, 0)
	end
end
addCommandHandler("w", whisperChat_func)
addCommandHandler("Flüstern", whisperChat_func)

function addChatCol (element, coltype)
	if coltype == "small" then
		if isElement(chatcol_small[element]) then destroyElement(chatcol_small[element]) end;
	
		x, y, z = getElementPosition(element)
		chatcol_small[element] = createColSphere(x, y, z, chatcol_small_size)
		
		return chatcol_small[element];
	elseif coltype == "normal" then
		if isElement(chatcol_normal[element]) then destroyElement(chatcol_normal[element]) end;
	
		x, y, z = getElementPosition(element)
		chatcol_normal[element] = createColSphere(x, y, z, chatcol_normal_size)
		
		return chatcol_normal[element];
	elseif coltype == "big" then
		if isElement(chatcol_big[element]) then destroyElement(chatcol_big[element]) end;
	
		x, y, z = getElementPosition(element)
		chatcol_big[element] = createColSphere(x, y, z, chatcol_big_size)

		return chatcol_big[element];
	end
end

-- Bind the Chatkey's
addEventHandler("onPlayerSpawn", root, function ()
	bindKey(source, "i", "down", "chatbox", "Schreien")
	bindKey(source, "u", "down", "chatbox", "Flüstern")
	bindKey(source, "y", "down", "chatbox", "Fraktion")
end)

-- Voice Chat