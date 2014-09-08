-- player/spawn/cSpawn.lua

-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cSpawn.lua		            ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Draw the Text (for 3,5 Seconds)
function drawLoginText ()
	dxDrawRectangle(0*px, 0*py, 1600*px, 900*py, tocolor(0, 0, 0, 200), false)
	dxDrawText(text, 0*px, 0*py, 1596*px, 896*py, tocolor(255, 255, 255, 255), 0.50*px, fonts["handbig"], "center", "center", false, false, false, false, false)
end

-- Fade out the Text
local alpha = 255
local alpha2 = 200
function fadeLoginText ()
	alpha = alpha - 5
	alpha2 = alpha2 - 5

	dxDrawRectangle(0*px, 0*py, 1600*px, 900*py, tocolor(0, 0, 0, alpha2), false)
	dxDrawText(text, 0*px, 0*py, 1596*px, 896*py, tocolor(255, 255, 255, alpha), 0.50*px, fonts["handbig"], "center", "center", false, false, false, false, false)
	
	if alpha == 0 or alpha2 == 0 then
		removeEventHandler("onClientRender", root, fadeLoginText)
		toggleRadar(true)
		toggleChatbox(true)
		if gspawntype == "street" then
			setTimer(function () showInfoBox ("LoginSucess", "Willkommen zurück "..getPlayerName(getLocalPlayer())..",\nDu wurdest an deiner letzen\nPosition gespawnt!", 5000) end, 200, 1)
		elseif gspawntype == "register" then
			setTimer(function () showInfoBox ("RegisterSucess", "Willkommen "..getPlayerName(getLocalPlayer())..",\nDu hast dich erfolgreich\nRegistriert!", 5000) end, 200, 1)
		end
	end
end

-- Format String and start Drawing it
function FormatString (spawntype)
	local lp = getLocalPlayer()
	gspawntype = tostring(spawntype)
	
	text = spawnText[gspawntype][math.random(1, #spawnText[gspawntype])]
	
	-- Format Special Variables //
	if string.find(text, "{PLAYER}") then
		text = string.gsub(text, "{PLAYER}", getPlayerName(lp))
	end
	if string.find(text, "{TIMENAME}" ) then 
		-- Get current Timename (Server Time)
		local time = getRealTime()
		if time.hour <= 12 then
			timename = "Morgen"
		elseif time.hour <= 18 then
			timename = "Tag"
		else
			timename = "Abend"
		end
		text = string.gsub(text, "{TIMENAME}", timename ) 
	end
	if string.find(text, "{JAILTIME}") then
		if getElementData(lp, "player.jailtime") < 60 then
			text = string.gsub(text, "{JAILTIME}", ("%s Minuten"):format((getElementData(lp, "player.jailtime") - (math.floor(getElementData(lp, "player.jailtime")/60)*60))))
		elseif getElementData(lp, "player.jailtime") >= 120 then
			text = string.gsub(text, "{JAILTIME}", ("%s Stunden und %s Minuten"):format((math.floor(getElementData(lp, "player.jailtime")/60)), (getElementData(lp, "player.jailtime") - (math.floor(getElementData(lp, "player.jailtime")/60)*60))))
		elseif getElementData(lp, "player.jailtime") >= 60 then
			text = string.gsub(text, "{JAILTIME}", ("%s Stunde und %s Minuten"):format((math.floor(getElementData(lp, "player.jailtime")/60)), (getElementData(lp, "player.jailtime") - (math.floor(getElementData(lp, "player.jailtime")/60)*60))))
		end
	end
	-- \\
	
	
	addEventHandler("onClientRender", root, drawLoginText)
	setTimer (
		function ()  
			removeEventHandler("onClientRender", root, drawLoginText)
			addEventHandler("onClientRender", root, fadeLoginText)
		end, 5000, 1)
end
addEvent("c_SpawnHandler_INT", true)
addEventHandler("c_SpawnHandler_INT", root, FormatString)