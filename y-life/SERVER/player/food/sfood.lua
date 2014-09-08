-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sfood.lua     	            ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local WarningTimer = {}

function getFoodData (source, flvl, warning)
	if warning then
		if flvl == 15 or flvl == 10 or flvl == 5 then
			outputChatBox("Du fängst an zu verhungern! Du musst dir schnell was zu essen besorgen! (Hunger Level: "..flvl.."%)", source, 125, 0, 0)
		end
	end

	setElementData(source, "foodlvl", tonumber(flvl))
end
addEvent("s_getFoodData", true)
addEventHandler("s_getFoodData", root, getFoodData)

function addFoodLVL (source, flvl)
	if flvl > 0 and flvl <= 100 then
		setElementData(source, "foodlvl", getElementData(source, "foodlvl") + tonumber(flvl))
	
		if getElementData(source, "foodlvl") < 100 then
			setElementData(source, "foodlvl", 100)
		end
	
		triggerClientEvent(source, "c_updatefoodlvl", source, getElementData(source, "foodlvl"))
		
		return true
	else
		return false
	end
end

function remFoodLVL (source, flvl)
	if flvl > 0 and flvl <= 100 then
		setElementData(source, "foodlvl", tonumber(getElementData(source, "foodlvl") - flvl))
		
		if getElementData(source, "foodlvl") <= 0 then
			setElementData(source, "foodlvl", 0)

		end
		
		triggerClientEvent(source, "c_updatefoodlvl", source, getElementData(source, "foodlvl"))
		
		return true
	else
		return false
	end
end

function setFoodLVL (source, flvl)
	if flvl > 0 and flvl <= 100 then
		setElementData(source, "foodlvl", tonumber(flvl))
		
		if getElementData(source, "foodlvl") <= 0 then
			setElementData(source, "foodlvl", 0)
		elseif getElementData(source, "foodlvl") < 100 then
			setElementData(source, "foodlvl", 100)
		end
		
		triggerClientEvent(source, "c_updatefoodlvl", source, getElementData(source, "foodlvl"))
		
		return true
	else
		return false
	end
end

local AminationRunning = {}
function SlowlyKillPlayer (source, foodlvl)
	local loss = (50/foodlvl)/2
	local health = getElementHealth(source) - loss
	
	if health >= 10 then
		setElementHealth(source, health)
	else
		--if isPedInVehicle(source) then
		--	removePedFromVehicle(source)
		--	local x, y, z = getElementPosition(source)
		--	setElementPosition(source, x + 2 , y + 2, z)
		--end
		if AminationRunning[source] ~= true then
			if isPedInVehicle(source) then
				removePedFromVehicle(source)
			end
			setElementHealth(source, 10)
			setPedAnimation (source, "CRACK", "crckdeth4" , -1, false)
			AminationRunning[source] = true
			triggerClientEvent(source, "c_rPowerlessness", source, true)
			setTimer(function () triggerClientEvent(source, "c_rPowerlessness", source, false) end, 5000, 1)
			setTimer(function () AminationRunning[source] = false end, 1050 * foodlvl, 1)
			--triggerClientEvent(source, "c_startHungerTimer", source, 97)
			
			-- Spawn Class
		end
	end
end
addEvent("s_skillLowHungerPlayer", true)
addEventHandler("s_skillLowHungerPlayer", root, SlowlyKillPlayer)