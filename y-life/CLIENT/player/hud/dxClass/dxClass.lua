-- #######################################
-- ## Project: 	MTA Your-Life	  	    ##
-- ## Name: 	dxClass.lua    	        ##
-- ## Author: 	StiviK					##
-- ## Version: 	1.1						##
-- #######################################

local screenX,screenY = guiGetScreenSize()

-- Class Tables
dxButton = {}
dxEdit = {}

-- Usefull Functions
function genIndex (len)
	local index = ""
	for i = 1, len, 1 do
		if (math.random(1, 2) == 1) then
			if (math.random(1, 2) == 2) then
				index = index..string.char(math.random(97, 122))
			else
				index = index..string.char(math.random(65, 90))
			end
		else
			index = index..string.char(math.random(48, 57))
		end
	end
	
	return index;
end

-- Class Functions
function dxCreateEdit (x, y, w, h, text, size, font, c1, c2, c3, a, pg, masked)
	if type(x) == "number" and type(y) == "number" and type(w) == "number" and type(h) == "number" and type(text) == "string" and type(size) == "number" and type(c1) == "number" and type(c2) == "number" and type(c3) == "number" and type(a) == "number" and type(pg) == "boolean" and type(masked) == "boolean" then
		local EditIndex = genIndex(10)
		
		dxEdit[EditIndex] = {
			x = x,
			y = y,
			w = w,
			h = h,
			t = text,
			mt = "",
			tmt = "",
			s = size,
			f = font,
			c1 = c1,
			c2 = c2,
			c3 = c3,
			a = a,
			pg = pg,
			m = masked,
			editable = true,
			sh = false,
			backTimer = false
		}
		
		dxEdit[EditIndex].func = function ()
			dxDrawRectangle(dxEdit[EditIndex].x, dxEdit[EditIndex].y, dxEdit[EditIndex].w, dxEdit[EditIndex].h, tocolor(dxEdit[EditIndex].c1, dxEdit[EditIndex].c2, dxEdit[EditIndex].c3, dxEdit[EditIndex].a), dxEdit[EditIndex].pg)
		
			if dxEdit[EditIndex].m then
				for i = 1, #dxEdit[EditIndex].t do
					dxEdit[EditIndex].mt = "*"..dxEdit[EditIndex].mt
					dxEdit[EditIndex].tmt = dxEdit[EditIndex].mt
				end
				
				if dxEdit[EditIndex].tactv then
					dxDrawText(dxEdit[EditIndex].mt.."|", dxEdit[EditIndex].x + 2, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), dxEdit[EditIndex].x, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), tocolor(0, 0, 0, 255), size, font, "left", "center", false, false, pg)
				else
					dxDrawText(dxEdit[EditIndex].mt, dxEdit[EditIndex].x + 2, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), dxEdit[EditIndex].x, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), tocolor(0, 0, 0, 255), size, font, "left", "center", false, false, pg)
				end
				
				dxEdit[EditIndex].mt = ""
			else
				if dxEdit[EditIndex].tactv then
					dxDrawText(dxEdit[EditIndex].t.."|", dxEdit[EditIndex].x + 2, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), dxEdit[EditIndex].x, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), tocolor(0, 0, 0, 255), size, font, "left", "center", false, false, pg)
				else
					dxDrawText(dxEdit[EditIndex].t, dxEdit[EditIndex].x + 2, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), dxEdit[EditIndex].x, (dxEdit[EditIndex].y+(dxEdit[EditIndex].h/2)), tocolor(0, 0, 0, 255), size, font, "left", "center", false, false, pg)
				end
			end
		end
		
		dxEdit[EditIndex].onClick = function (button, state) dxOnEditClick(EditIndex, button, state) end
		dxEdit[EditIndex].onCharacter = function (character, press) dxOnCharacter(EditIndex, character, press) end
		addEventHandler("onClientClick", root, dxEdit[EditIndex].onClick)
		addEventHandler("onClientKey", root, dxEdit[EditIndex].onCharacter)
		addEventHandler("onClientRender", root, dxEdit[EditIndex].func)
		
		return EditIndex;
	else
		outputDebugString("Bad Argument @ 'dxCreateEdit'", 1)
		return false;
	end
end

local validKeys = {
	'a',
	'b',
	'c',
	'd',
	'e',
	'f',
	'g',
	'h',
	'i',
	'j',
	'l',
	'k',
	'm',
	'n',
	'o',
	'p',
	'q',
	'r',
	's',
	't',
	'u',
	'v',
	'w',
	'x',
	'y',
	'z',
	'backspace',
	'space',
	'lshift',
	'-',
	'.',
	',',
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9',
	'<'
}

local specialKeys = {
	["q"] = "@"
}

function dxIsValidKey (character)
	for _, key in ipairs(validKeys) do
		if key:lower() == character:lower() then
			return true;
		end
	end
		
	return false;
end

function dxIsCursorOverEdit (EditIndex)
	if dxEdit[EditIndex] ~= nil then
		local cX, cY = getCursorPosition()
		
		if isCursorShowing() then
			return ((cX*screenX > dxEdit[EditIndex].x) and (cX*screenX < dxEdit[EditIndex].x+dxEdit[EditIndex].w)) and ( (cY*screenY > dxEdit[EditIndex].y) and (cY*screenY < dxEdit[EditIndex].y+dxEdit[EditIndex].h));
		else
			return false;
		end
	end
end

function dxOnEditClick (EditIndex, button, state)
	if dxEdit[EditIndex] ~= nil then
		if (button == "left") and (state == "down") then
			if dxIsCursorOverEdit(EditIndex) then
				dxEdit[EditIndex].tactv = true;
			else
				dxEdit[EditIndex].tactv = false;
			end
		end
	end
end

function dxOnCharacter (EditIndex, character, press)
	if dxEdit[EditIndex].tactv and (dxEdit[EditIndex].editable) then
		if (press) then
			if (character == "lshift") then
				dxEdit[EditIndex].sh = true
				return;
			elseif (character == "ralt") then
				dxEdit[EditIndex].ralt = true
				return;
			elseif (character == "backspace") then
				dxEdit[EditIndex].backTimer = setTimer(
					function (EditIndex)
						dxEdit[EditIndex].t = string.sub(dxEdit[EditIndex].t, 1, #dxEdit[EditIndex].t - 1)
						return;
					end, 100, -1, EditIndex)
				return;
			end	
		
			if dxIsValidKey(character) and (not isChatBoxInputActive()) and (not isConsoleActive()) and (not isMainMenuActive()) then
				if (not dxEdit[EditIndex].m) then
					if (character == "space") and (dxGetTextWidth(dxEdit[EditIndex].t, dxEdit[EditIndex].s, dxEdit[EditIndex].f) <= (dxEdit[EditIndex].w) - 14) then
						dxEdit[EditIndex].t = dxEdit[EditIndex].t.." "
						return;
					end
					
					--[[if (character == "backspace") and (#dxEdit[EditIndex].t > 0) then
						dxEdit[EditIndex].t = string.sub(dxEdit[EditIndex].t, 1, #dxEdit[EditIndex].t - 1)
						return;
					end--]]
					
					if (character ~= "backspace") and (dxGetTextWidth(dxEdit[EditIndex].t, dxEdit[EditIndex].s, dxEdit[EditIndex].f) <= (dxEdit[EditIndex].w) - 14) then
						if (dxEdit[EditIndex].sh) then
							dxEdit[EditIndex].t = dxEdit[EditIndex].t..character:upper()
						elseif (dxEdit[EditIndex].ralt) then
							dxEdit[EditIndex].t = dxEdit[EditIndex].t..specialKeys[character:lower()]
						else
							dxEdit[EditIndex].t = dxEdit[EditIndex].t..character
						end
					end
				else
					if (character == "space") and (dxGetTextWidth(dxEdit[EditIndex].tmt, dxEdit[EditIndex].s, dxEdit[EditIndex].f) <= (dxEdit[EditIndex].w) - 14) then
						dxEdit[EditIndex].t = dxEdit[EditIndex].t.." "
						return;
					end
					
					--[[if (character == "backspace") and (#dxEdit[EditIndex].t > 0) then
						dxEdit[EditIndex].t = string.sub(dxEdit[EditIndex].t, 1, #dxEdit[EditIndex].t - 1)
						return;
					end--]]
						
					if (character ~= "backspace") and (dxGetTextWidth(dxEdit[EditIndex].tmt, dxEdit[EditIndex].s, dxEdit[EditIndex].f) <= (dxEdit[EditIndex].w) - 14) then
						if (dxEdit[EditIndex].sh) then
							dxEdit[EditIndex].t = dxEdit[EditIndex].t..character:upper()
						elseif (dxEdit[EditIndex].ralt) then
							dxEdit[EditIndex].t = dxEdit[EditIndex].t..specialKeys[character:lower()]
						else
							dxEdit[EditIndex].t = dxEdit[EditIndex].t..character
						end
					end
				end
			end
		else
			if (character == "lshift") then
				dxEdit[EditIndex].sh = false
				return;
			elseif (character == "ralt") then
				dxEdit[EditIndex].ralt = false
				return;
			elseif (character == "backspace") then
				if (isTimer(dxEdit[EditIndex].backTimer)) then
					killTimer(dxEdit[EditIndex].backTimer)
				end
			end	
		end
	end
end

function dxSetEditText (EditIndex, text)
	if dxEdit[EditIndex] ~= nil then
		if type(text) == "string" then
			dxEdit[EditIndex].t = text;
			
			outputConsole("DEBUG: [Edit: "..tostring(EditIndex).."; Text: "..text.."]", getLocalPlayer())
			
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function dxEditGetText (EditIndex)
	if dxEdit[EditIndex] ~= nil then
		return dxEdit[EditIndex].t;
	end
end

function dxSetEditColor (EditIndex, c1, c2, c3, alpha)
	if dxEdit[EditIndex] ~= nil then
		if type(c1) == "number" and type(c2) == "number" and type(c3) == "number" and type(alpha) == "number" then
			dxEdit[EditIndex].c1 = c1
			dxEdit[EditIndex].c2 = c2
			dxEdit[EditIndex].c3 = c3
			dxEdit[EditIndex].a = alpha
			
			outputConsole("DEBUG: [Edit: "..tostring(EditIndex).."; Color: "..c1..", "..c2..", "..c3..", "..alpha.."]", getLocalPlayer())
			
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function dxRemoveEdit (EditIndex)
	if dxEdit[EditIndex] ~= nil then
		removeEventHandler("onClientClick", root, dxEdit[EditIndex].onClick)
		removeEventHandler("onClientKey", root, dxEdit[EditIndex].onCharacter)
		removeEventHandler("onClientRender", root, dxEdit[EditIndex].func)
		
		dxEdit[EditIndex] = nil
	end
end

function dxCreateButton (x, y, w, h, text, size, font, c1, c2, c3, a, pg, funcname, hover, click, image, ...)
	if type(x) == "number" and type(y) == "number" and type(w) == "number" and type(h) == "number" and type(text) == "string" and type(size) == "number" and type(c1) == "number" and type(c2) == "number" and type(c3) == "number" and type(funcname) == "function" then
		local arg = {...}
		local ButtonIndex = genIndex(10)
			if (hover == nil) then
				hover = true
			end
			
			if (click == nil) then
				click = true
			end
			
			if (click and (not hover)) then	-- Hover needs to be true for click
				hover = true 
			end
			
		dxButton[ButtonIndex] = {
			x = x,
			y = y,
			w = w,
			h = h,
			t	= text,
			c1 = c1,
			c2 = c2,
			c3 = c3,
			a = a,
			click = click,
			hover = hover,
			image = image,
			cfunc = funcname,
		}
		
		dxButton[ButtonIndex].func = function ()
			if not (image) then
				if isCursorOverButton(ButtonIndex) then
					dxDrawRectangle(dxButton[ButtonIndex].x, dxButton[ButtonIndex].y, dxButton[ButtonIndex].w, dxButton[ButtonIndex].h, tocolor(dxButton[ButtonIndex].c1 + 50, dxButton[ButtonIndex].c2 + 50, dxButton[ButtonIndex].c3 + 50, dxButton[ButtonIndex].a), pg)
				else
					dxDrawRectangle(dxButton[ButtonIndex].x, dxButton[ButtonIndex].y, dxButton[ButtonIndex].w, dxButton[ButtonIndex].h, tocolor(dxButton[ButtonIndex].c1, dxButton[ButtonIndex].c2, dxButton[ButtonIndex].c3, dxButton[ButtonIndex].a), pg)
				end
				
				dxDrawText(dxButton[ButtonIndex].t, (dxButton[ButtonIndex].x+(dxButton[ButtonIndex].w/2)), (dxButton[ButtonIndex].y+(dxButton[ButtonIndex].h/2)), (dxButton[ButtonIndex].x+(dxButton[ButtonIndex].w/2)), (dxButton[ButtonIndex].y+(dxButton[ButtonIndex].h/2)), tocolor(255, 255, 255, dxButton[ButtonIndex].a), size, font, "center", "center", false, false, pg)
			else
				dxDrawImage(dxButton[ButtonIndex].x, dxButton[ButtonIndex].y, dxButton[ButtonIndex].w, dxButton[ButtonIndex].h, dxButton[ButtonIndex].image, 0, 0, 0, tocolor(255, 255, 255, dxButton[ButtonIndex].a), pg)
				dxDrawText(dxButton[ButtonIndex].t, dxButton[ButtonIndex].x + (50)*px, dxButton[ButtonIndex].y + (120)*py, dxButton[ButtonIndex].x, dxButton[ButtonIndex].y, tocolor(255, 255, 255, 255), size, font, "center", "center", false, false, pg)
			end
		end
		
		dxButton[ButtonIndex].onclick = function (button, state) onClickOnButton(ButtonIndex, arg, button, state) end
		addEventHandler("onClientClick", root, dxButton[ButtonIndex].onclick)
		
		for i, v in pairs(dxButton) do
			if isEventHandlerAdded("onClientRender", root, dxButton[ButtonIndex].func) then
				--removeEventHandler("onClientRender", root, dxButton[ButtonIndex].func)
			else
				addEventHandler("onClientRender", root, dxButton[ButtonIndex].func)
			end
		end
		
		return ButtonIndex;
	else
		outputDebugString("Bad Argument @ 'dxCreateButton'", 1)
		return false;
	end
end

function isCursorOverButton (ButtonIndex)
	if dxButton[ButtonIndex] ~= nil then
		local cX, cY = getCursorPosition()
		
		if isCursorShowing() and dxButton[ButtonIndex].hover then
			return ((cX*screenX > dxButton[ButtonIndex].x) and (cX*screenX < dxButton[ButtonIndex].x+dxButton[ButtonIndex].w)) and ( (cY*screenY > dxButton[ButtonIndex].y) and (cY*screenY < dxButton[ButtonIndex].y+dxButton[ButtonIndex].h));
		else
			return false;
		end
	end
end

function onClickOnButton (ButtonIndex, arg, button, state)
	if (button == "left") and (state == "down") and dxButton[ButtonIndex] ~= nil then		
		if isCursorOverButton(ButtonIndex) and dxButton[ButtonIndex].click then
			setSoundVolume(playSound("FILES/sounds/Notification/pop.mp3"), 0.3)
			
			outputConsole("DEBUG: [Button: "..tostring(ButtonIndex).."; called Function: "..tostring(dxButton[ButtonIndex].cfunc).."; Argument Count: "..#arg.."]", getLocalPlayer())
		
			if #arg >= 1 then
				getButtonFunction(ButtonIndex)(unpack(arg))
			else
				getButtonFunction(ButtonIndex)()
			end
		end
	end
end

function getButtonFunction (ButtonIndex)
	if dxButton[ButtonIndex] ~= nil then
		return dxButton[ButtonIndex].cfunc;
	else
		return false;
	end
end

function dxRemoveButton (ButtonIndex)
	if dxButton[ButtonIndex] ~= nil then
		removeEventHandler("onClientRender", root, dxButton[ButtonIndex].func)
		removeEventHandler("onClientClick", root, dxButton[ButtonIndex].onclick)
		
		outputConsole("DEBUG: [Button: "..tostring(ButtonIndex).."; Status: destroyed]", getLocalPlayer())
		
		dxButton[ButtonIndex] = nil
		
		return true;
	else
		return false;
	end
end

function dxSetButtonColor (ButtonIndex, c1, c2, c3, alpha)
	if dxButton[ButtonIndex] ~= nil then
		if type(c1) == "number" and type(c2) == "number" and type(c3) == "number" and type(alpha) == "number" then
			dxButton[ButtonIndex].c1 = c1
			dxButton[ButtonIndex].c2 = c2
			dxButton[ButtonIndex].c3 = c3
			dxButton[ButtonIndex].a = alpha
			
			outputConsole("DEBUG: [Button: "..tostring(ButtonIndex).."; Color: "..c1..", "..c2..", "..c3..", "..alpha.."]", getLocalPlayer())
			
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function dxSetButtonPosition (ButtonIndex, x, y, w, h)
	if dxButton[ButtonIndex] ~= nil then
		if type(x) == "number" and type(y) == "number" and type(w) == "number" and type(h) == "number" then
			dxButton[ButtonIndex].x = x
			dxButton[ButtonIndex].y = y
			dxButton[ButtonIndex].w = w
			dxButton[ButtonIndex].h = h
			
			outputConsole("DEBUG: [Button: "..tostring(ButtonIndex).."; Position: "..x..", "..y.."; Size: "..w..", "..h.."]", getLocalPlayer())
			
			return true;
		else
			return false;
		end
	else
		return false;
	end	
end

function dxSetButtonText (ButtonIndex, text)
	if dxButton[ButtonIndex] ~= nil then
		if type(text) == "string" then
			dxButton[ButtonIndex].t = text
		else
			return false;
		end
	else
		return false;
	end
end

function dxSetButtonHoverEnabled (ButtonIndex, boolean)
	if dxButton[ButtonIndex] ~= nil then
		if type(boolean) == "boolean" then
			dxButton[ButtonIndex].hover = boolean
		else
			return false;
		end
	else
		return false;
	end
end

function dxSetButtonClickable (ButtonIndex, boolean)
	if dxButton[ButtonIndex] ~= nil then
		if type(boolean) == "boolean" then
			dxButton[ButtonIndex].click = boolean
			
			if (not dxButton[ButtonIndex].hover) and (boolean == true) then
				dxButton[ButtonIndex].hover = true
			end
		else
			return false;
		end
	else
		return false;
	end
end

function dxButtonSetVisible(ButtonIndex, bool)
    if dxButton[ButtonIndex] ~= nil then
		if type(bool) == "boolean" then
            dxButton[ButtonIndex].a = (bool and 250) or 0
            dxButton[ButtonIndex].hover = bool
			dxButton[ButtonIndex].click = bool
        else
			return false
		end
	else
		return false
	end
end



--[[
local screenx, screeny = guiGetScreenSize()
local sx, sy = 0, 0
local ld = true
local dr = false
local ru = false
local ul = false
local run = true
local added = false
local sound

dxCustomization = dxCreateButton(0, 0, 200*px, 38*py, "I am a Easter Egg ;)", 0.6*px, "bankgothic", 254, 135, 0, 212, true, 
	function ()
		if (not added) then
			addEventHandler("onClientRender", root, function () 
				if (not run) then
					if ld then
						sy = sy + 1
					end
					
					if (sy*py) >= (screeny - (38*py)) and ld then
						ld = false
						dr = true
					end
					
					if dr then
						sx = sx + 1
					end
					
					if (sx*px) >= (screenx - (200*px)) and dr then
						dr = false
						ru = true
					end
					
					if ru then
						sy = sy - 1
					end
					
					if sy <= 0 then
						ru = false
						ul = true
					end
					
					if ul then
						sx = sx - 1
					end
					
					if sx <= 0 then
						ul = false
						ld = true
					end
					
					dxSetButtonPosition(dxCustomization, sx*px, sy*py, 200*px, 38*py)
					dxSetButtonColor(dxCustomization, math.random(255), math.random(255), math.random(255), 255)
					dxSetButtonText(dxCustomization, tostring(ABCTable[math.random(1,26)]..math.random(1,26)..ABCTable[math.random(1,26)]..math.random(1,26)..ABCTable[math.random(1,26)]..math.random(1,26)..ABCTable[math.random(1,26)]))
				end
			end)
			
			added = true
		end
		
		run = (not run)
		end
	end)
--]]