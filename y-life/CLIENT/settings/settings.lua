-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: config.lua   			  	##
-- ## Author: StiviK, Vandam			##
-- ## Version: 1.0						##
-- #######################################

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

-- Fonts
fonts = {
	["handsmall"] = dxCreateFont("FILES/fonts/testfont.ttf", 30),
	["hand"] = dxCreateFont("FILES/fonts/testfont.ttf", 60),
	["handbig"] = dxCreateFont("FILES/fonts/testfont.ttf", 120),
	["dxedit"] = dxCreateFont("FILES/fonts/dxedit.ttf", 30)
}

-- Smooth Move Camera
local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil
 
local function camRender ()
	local x1, y1, z1 = getElementPosition ( sm.object1 )
	local x2, y2, z2 = getElementPosition ( sm.object2 )
	setCameraMatrix ( x1, y1, z1, x2, y2, z2 )
end

local function removeCamHandler ()
	if(sm.moov == 1) then
		sm.moov = 0
		removeEventHandler ( "onClientPreRender", root, camRender )
	end
end
 
function smoothMoveCamera ( x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time )
	if(sm.moov == 1) then return false end
	sm.object1 = createObject ( 1337, x1, y1, z1 )
	sm.object2 = createObject ( 1337, x1t, y1t, z1t )
	setElementAlpha ( sm.object1, 0 )
	setElementAlpha ( sm.object2, 0 )
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject ( sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad" )
	moveObject ( sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad" )
 
	addEventHandler ( "onClientPreRender", root, camRender )
	sm.moov = 1
	setTimer ( removeCamHandler, time, 1 )
	setTimer ( destroyElement, time, 1, sm.object1 )
	setTimer ( destroyElement, time, 1, sm.object2 )
	return true
end