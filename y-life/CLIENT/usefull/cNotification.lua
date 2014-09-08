-- usefull/client/cNotification.lua

-- #######################################
-- ## Project: MTA Your-Life     	    ##
-- ## Name: cNotification.lua			##
-- ## Author: StiviK					##
-- ## Version: 1.1						##
-- #######################################

local sx, sy = guiGetScreenSize()
local InfoBox = {}
local boxnumber = 0
function showInfoBox (boxname, boxtext, boxtime)
	boxtime = 10000
	if (InfoBox[boxname]) then 
		boxnumber = boxnumber + 1
		boxname = tostring(boxname..boxnumber)
		outputChatBox(boxname)
	end
	
	local sound = playSound("FILES/sounds/Notification/sound.mp3")
	setSoundVolume(sound, 0.5)
	--playSound("sounds/Notification/pop.mp3")
	
	InfoBox[boxname] = {}
	InfoBox[boxname].text = boxtext
	InfoBox[boxname].time = boxtime
	InfoBox[boxname].currx = 20
	InfoBox[boxname].curry = 597
	InfoBox[boxname].rely = 597
	InfoBox[boxname].alpha = 255
	
	-- Infobox Function
	InfoBox[boxname].func = function ()
		dxDrawImage(InfoBox[boxname].currx*px, InfoBox[boxname].curry*py, 410*px, 150*py, "FILES/images/Notification/infobox.png", 0, 0, 0, tocolor(255, 255, 255, InfoBox[boxname].alpha), false)						-- 3
		dxDrawText(InfoBox[boxname].text, (InfoBox[boxname].currx + 50)*px, (InfoBox[boxname].curry + 50)*py, 100*px, 20*py, tocolor(61, 61, 61, InfoBox[boxname].alpha), 1.40, "default", "left", "top", false, false, false, false, false)
	end
	addEventHandler("onClientRender", root, InfoBox[boxname].func)
	
	-- Remove Function
	InfoBox[boxname].rem = function ()		
		if InfoBox[boxname].alpha > 0 then
			InfoBox[boxname].alpha = InfoBox[boxname].alpha - 15
		else
			removeEventHandler("onClientRender", root, InfoBox[boxname].func)
			removeEventHandler("onClientRender", root, InfoBox[boxname].rem)
			InfoBox[boxname] = nil
		end
	end
	
	-- Fade out Timer
	setTimer(function (boxname) 
		addEventHandler("onClientRender", root, InfoBox[boxname].rem)
	end, InfoBox[boxname].time, 1, boxname)
	
	-- Box Movement (Unreal Position)
	for i, v in pairs(InfoBox) do
		InfoBox[i].rely = InfoBox[i].rely - 150
	end
	
	-- Box Movement (Real Position)
	if (not isEventHandlerAdded("onClientPreRender", root, moveFunc)) then
		addEventHandler("onClientPreRender", root, moveFunc)
	end
end
addEvent("infoBox", true)
addEventHandler("infoBox", root, showInfoBox)

function moveFunc ()
	for i, v in pairs(InfoBox) do
		if InfoBox[i].curry > InfoBox[i].rely then
			InfoBox[i].curry = InfoBox[i].curry - 10
		end
	end
end

i = 0
function box (player)
	showInfoBox("LoginError1", "Baum", 5000)
end
addCommandHandler("box", box)