-- #######################################
-- ## Project: MTA Your-Life     	    ##
-- ## Name: cFunc.lua                   ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Debugging Fix
local _error = error
function error (err, level)
	setTimer(function (err, level) _error(err:gsub("string ", ""):gsub("%[", ""):gsub("%]", ""):gsub('"', ''), level) end, 50, 1, err, level)
	return;
end

-- Math Extension
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

-- GLOBAL
 sWidth, sHeight = guiGetScreenSize()
 Auflosung_x = 1600
 Auflosung_y = 900
 px = sWidth/Auflosung_x
 py = sHeight/Auflosung_y

-- Is Eventhandler added
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

-- Text to Speech
local speech
function GoogleSpeech (message)
	if (type(message) == "string") or (type(message) == "number") then
		if isElement(speech) then
			if getElementType(speech) == "sound" then stopSound(speech) end
		end
		
		speech = playSound("http://translate.google.com/translate_tts?ie=utf-8&tl=de&q="..message)
	else
		outputDebugString("Bad Argument @ 'GoogleSpeech' [Expected string @ Argument 1 got "..type(message).."]", 1)
		return false;
	end
end
addEvent("speech_c", true)
addEventHandler("speech_c", root, GoogleSpeech)

-- ShowPlayerHudComponent
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function ()
	showPlayerHudComponent("all", false)
	showPlayerHudComponent("crosshair", true)
end
)

-- // Old!
function cScreenPosition ( position, xy ) 
	-- Define required Arguments
	local sWidth, sHeight = guiGetScreenSize()
	local Auflosung_x = 1600
	local Auflosung_y = 900
	local px = sWidth/Auflosung_x
	local py = sHeight/Auflosung_y
	
	-- Calculate Position and return it
	if xy == true then
		return tonumber(position*px);
	elseif xy == false then
		return tonumber(position*py);
	else
		return false;
	end
end
--\\

function cScreenResolution ()
	-- define recommended Resolution
	local recWidth, recHeight = 1024, 768
	-- get Screen Size
	local resWidth, resHeight = guiGetScreenSize()
	if recWidth > resWidth and recHeight > resHeight then
		cShowResolutionError()
	end
end
addEventHandler("onClientResourceStart", root, cScreenResolution)

-- Low-Resuloution Warning
function cShowResolutionError ()
	-- define recommended Resolution
	local recWidth, recHeight = 1024, 768
	-- get Screen Size
	local resWidth, resHeight = guiGetScreenSize()
	
	local sWidth, sHeight = guiGetScreenSize()
	local Auflosung_x = 1024
	local Auflosung_y = 768
	local px = sWidth/Auflosung_x
	local py = sHeight/Auflosung_y
	
LowResWarning = {
    button = {},
    label = {}
}

    LowResWarning.button[1] = guiCreateButton(402, 361, 217, 50, "Bestätigen und Schließen", false)
	addEventHandler("onClientGUIClick", LowResWarning.button[1], 
		function () 
			removeEventHandler("onClientRender", root, cResolutionError)
			addEventHandler("onClientRender", root, fadeoutResolutionError) 
		end, false)

    LowResWarning.label[2] = guiCreateLabel(404, 20, 215, 38, "WARNUNG!", false)
    guiSetFont(LowResWarning.label[2], "default-bold-small")
    guiLabelSetColor(LowResWarning.label[2], 159, 0, 0)
    guiLabelSetHorizontalAlign(LowResWarning.label[2], "center", false)
    guiLabelSetVerticalAlign(LowResWarning.label[2], "center")

    LowResWarning.label[3] = guiCreateLabel(403, 78, 216, 202, "Deine Bildschirmauflösung "..resWidth.."x"..resHeight.." \nist zu  niedrig! Es wird empohlen \nmidestens mit einer Auflösung von \n"..recWidth.."x"..recHeight.." zu spielen!\n\nDa sonst einige GUI- bzw. dxDraw- \nElemente falsch oder unleserlich \ndargestellt werden!\n\n(Falls du keine höhere Auflösung \nwählen kannst wende dich an \neinen Admin!)\n\n- [Y-Life]StiviK", false)
    guiLabelSetColor(LowResWarning.label[3], 159, 0, 0)

    LowResWarning.label[5] = guiCreateLabel(398, 300, 226, 56, "Wenn du es gelesen und akzeptiert hast,\ndrücken auf  den Button!", false)
    guiLabelSetColor(LowResWarning.label[5], 159, 0, 0)
    guiLabelSetHorizontalAlign(LowResWarning.label[5], "center", false)
    guiLabelSetVerticalAlign(LowResWarning.label[5], "center")    

	showCursor(true)
	showChat(false)
	addEventHandler("onClientRender", root, cResolutionError)
end

function cResolutionError ()
	dxDrawRectangle(394, 10, 235, 280, tocolor(0, 0, 0, 211), false)
    dxDrawRectangle(394, 300, 235, 125, tocolor(0, 0, 0, 211), false)
end

local alpha = 210
function fadeoutResolutionError ()
	local alpha = alpha - 10
	setElementAlpha(LowResWarning.label[2], alpha)
	setElementAlpha(LowResWarning.label[3], alpha)
	setElementAlpha(LowResWarning.label[5], alpha)
	dxDrawRectangle(394, 10, 235, 280, tocolor(0, 0, 0, alpha), false)
    dxDrawRectangle(394, 300, 235, 125, tocolor(0, 0, 0, alpha), false)
	if isElement(LowResWarning.button[1]) then destroyElement(LowResWarning.button[1]) end
	
	if alpha == 0 then
		destroyElement(LowResWarning.label[2])
		destroyElement(LowResWarning.label[3])
		destroyElement(LowResWarning.label[5])
		removeEventHandler("onClientRender", root, fadeoutResolutionError)
		showChat(true)
		showCursor(false)
	end
end

-- 