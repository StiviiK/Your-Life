-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cfood.lua     	            ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local source = getLocalPlayer()
local lossperMinute = 1
local losetime = 60000

function updateFoodLVL (flvl)
	foodlvl = tonumber(flvl)
end
addEvent("c_updatefoodlvl", true)
addEventHandler("c_updatefoodlvl", root, updateFoodLVL)

--[[ DEV
function testxy (cmd, test)
	foodlvl = tonumber(test)
end
addCommandHandler("testxy", testxy)
--]]

function Hunger()
	if getElementDimension(source) > 0 and getElementInterior(source) > 0 then
	else
		foodlvl = foodlvl - 1
		--if foodlvl < 1 then
			--	triggerServerEvent("s_skillLowHungerPlayer", source, source)
		--else
			outputChatBox(tostring(foodlvl))
		if foodlvl <= 0 then
			killTimer(HungerTimer)
		end
		if foodlvl <= 15 then
			triggerServerEvent("s_getFoodData", source, source, foodlvl, true)
			if foodlvl <= 10 then
				triggerServerEvent("s_skillLowHungerPlayer", source, source, foodlvl)
			end
		else
			triggerServerEvent("s_getFoodData", source, source, foodlvl, false)
		end
		--end
	end
end

function createHungerTimer (lvl)
	if isTimer(HungerTimer) then
		killTimer(HungerTimer)
	end
	if lvl ~= nil then
		foodlvl = tonumber(lvl)
	else
		foodlvl = 100
	end
	HungerTimer = setTimer(Hunger, losetime, 0)
end
addEvent("c_startHungerTimer", true)
addEventHandler("c_startHungerTimer", root, createHungerTimer)

local alpha = 0
function renderPowerlessnessInfo ()
	if alpha ~= 255 then
		alpha = alpha + 5
	end
	dxDrawRectangle(0*px, 0*py, 1600*px, 900*py, tocolor(0, 0, 0, alpha), false)
    dxDrawText("Du bist Ohmächtig geworden!\n\nPass lieber auf das du immer genug isst!", 10*px, 208*py, 1590*px, 679*py, tocolor(255, 255, 255, alpha), 3.00, "pricedown", "center", "center", false, false, false, false, false)
end

function Powerlessness (state)
	if state then
		addEventHandler("onClientRender", root, renderPowerlessnessInfo)
	else
		removeEventHandler("onClientRender", root, renderPowerlessnessInfo)
	end
end
addEvent("c_rPowerlessness", true)
addEventHandler("c_rPowerlessness", root, Powerlessness)