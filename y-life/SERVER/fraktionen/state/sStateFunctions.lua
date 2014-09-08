-- #######################################
-- ## Project: 	MTA Your-Life		    ##
-- ## Name: 	sStateFunctions.lua   	##
-- ## Author: 	StiviK					##
-- ## Version: 	1.0						##
-- #######################################

-- Settings
local tazerTime = 20000 -- How long should the player be tazerd?
local Autotie = false -- Should the player be automatically tied?
local tazerRange = 10

function isOnDuty (player)
	if (isCop(player)) then
		return not (getElementData(player, "player.onduty") == nil) and (getElementData(player, "player.onduty"));
	else
		return false;
	end
end

function isCop ()
	return true;
end



-- Duty Function
function setPlayerOnDuty (player)
	if (getElementType(player) == "player") then
		if (isCop(player)) then
			if (not isOnDuty(player)) then
				setElementData(player, "player.onduty", true)
				setElementData(player, "zivskin", getElementModel(player))
				setElementModel(player, factionSkins[getElementData(player, "player.faction")][math.random(#factionSkins[1])])
				setElementHealth(player, 100)
				setPedArmor(player, 100)
				
				setFoodLVL(player, 100)
				
				takeAllWeapons(player)
				
				sendFactionMSG(getElementData(player, "player.faction"), getPlayerName(player).." meldet sich bereit für den Dienst!", 0, 125, 0)
				
				chatboxMessage(player, player, "[[ Du bist nun im Dienst! Geh oben ins Büro um deine Waffen zu erhalten! ]]", "custom", 0, 125, 0)	
			--[[
			else
				takeAllWeapons(player)
				
				setElementData(player, "player.onduty", false)
				setElementModel(player, getElementData(player, "zivskin"))
			--]]
			else
				outputChatBox("FALSE1")
			end
		else
			outputChatBox("FALSE2")
		end
	else
		outputChatBox("FALSE3")
	end
end

local DutyMarkers = {
	[1] = {254.41655, 79.61057, 1003.64063, 6}
}

for _, table in pairs(DutyMarkers) do
	local pickup = createPickup(table[1], table[2], table[3], 3, 1275, 1000)
	setElementInterior(pickup, table[4])
	
	addEventHandler("onPickupHit", pickup, setPlayerOnDuty)
end



-- Duty Equip
function equipDutyPlayer (player)
	if isCop(player) then	
		if isOnDuty(player) then
			takeAllWeapons(player)
		
			for _, table in pairs(factionDutyWeapons[getElementData(player, "player.faction")][getElementData(player, "rank")]) do
				giveWeapon(player, table[1], table[2], false)
			end
		else
			infoBox(player, "DutyEquipError2", "Du bist nicht im Dienst!\nGehe erst in den Dienst damit\ndu deine Waffen erhältst!", 3000)
		end
	else
		infoBox(player, "DutyEquipError1", "Dazu bist du nicht berrechtigt!", 3000)
	end
end

local EquipMarkers = {
	[1] = {239.91585, 72.60307, 1005.03906, 6}
}

for _, table in pairs(EquipMarkers) do
	local pickup = createPickup(table[1], table[2], table[3], 3, 347, 1000)
	setElementInterior(pickup, table[4])
	
	addEventHandler("onPickupHit", pickup, equipDutyPlayer)
end



-- Police Deparments
local PolicePlaces = {
	--["NAME"] = {x, y, z}
	["LS-in"] = {6, 246.48758, 64.70996, 1003.64063},
	["LS-out"] = {0, 1554.22595, -1675.60522, 16.19531},
	["LSGarage-in"] = {6, 246.41289, 85.42316, 1003.64063},
	["LSGarage-out"] = {0, 1568.73596, -1692.31042, 5.89063}
}

local PoliceDepartments = {
	--["NAME"] = {int, x, y, z, rot, polint, restricted)
	["LS-in"] = {0, 1555.50183, -1675.60767, 16, 0, "LS-in", false},
	["LS-out"] = {6, 246.78220, 62.64849, 1003.64063, 90, "LS-out", false},
	["LSGarage-in"] = {0, 1568.60876, -1689.97656, 6.21875, 180, "LSGarage-in", true},
	["LSGarage-out"] = {6, 246.33716, 87.72676, 1003.64063, 180, "LSGarage-out", true}
}

createBlip(1555.50183, -1675.60767, 16, 30)

for _, table in pairs(PoliceDepartments) do
	local marker = createMarker(table[2], table[3], table[4], "corona", 1.0, 0, 0, 153)
	setElementInterior(marker, table[1])
	
	addEventHandler("onMarkerHit", marker, function (player)
		if (not table[7]) then
			if (getElementType(player) == "player") and (not getPedOccupiedVehicle(player)) then
				if string.find(table[6], "in") then
					if isCop(player) then
						setElementData(player, "spawntype", "faction")
					end
				elseif string.find(table[6], "out") then
					if isCop(player) then
						setElementData(player, "spawntype", "street")
					end
				end
			
				fadeCamera(player, false, 0)
				setTimer(function (player) fadeCamera(player, true) end, 100, 1, player)
		
				setElementInterior(player, unpack(PolicePlaces[table[6]]))
				setElementRotation(player, 0, 0, table[5])
				setCameraTarget(player, player)
			end
		else
			if (getElementType(player) == "player") and (not getPedOccupiedVehicle(player)) then
				if (isCop(player)) then
					if string.find(table[6], "in") then
						if isCop(player) then
							setElementData(player, "spawntype", "faction")
						end
					elseif string.find(table[6], "out") then
						if isCop(player) then
							setElementData(player, "spawntype", "street")
						end
					end
				
					fadeCamera(player, false, 0)
					setTimer(function (player) fadeCamera(player, true) end, 100, 1, player)
			
					setElementInterior(player, unpack(PolicePlaces[table[6]]))
					setElementRotation(player, 0, 0, table[5])
					setCameraTarget(player, player)
				end
			end
		end
	end)
end

-- Tazer
function onPlayerTazerd (pol, tazergun, part, loss)
	--if source ~= client then return false; end
	
	if (tazergun == 23) and (isElement(pol)) and (isElement(source)) and (isOnDuty(pol)) and ((not getElementData(source, "isTazerd")) or (getElementData(source, "isTazerd") == nil)) then
			local x, y, z = getElementPosition(pol)
			local tx, ty, tz = getElementPosition(source)
		if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) <= tazerRange) then
			if getPedOccupiedVehicle(source) then
				--local rx, ry, rz = getElementRotation(getPedOccupiedVehicle(source))
				--local x, y, z = getElementPosition(getPedOccupiedVehicle(source))
				--setVehicleDoorOpenRatio(getPedOccupiedVehicle(source), 2, 1)
				--removePedFromVehicle(source)
				setControlState(source,"enter_exit",true)
				setTimer(function(player)
					setElementFrozen(player, true)
					setElementData(player, "isTazerd", true)
					setPedAnimation(player, "crack", "crckdeth2", tazerTime, false, true, false)
					setControlState(player,"enter_exit",false)
				end,1000,1,source)
			else
				setElementFrozen(source, true)
				setElementData(source, "isTazerd", true)
				setPedAnimation(source, "crack", "crckdeth2", tazerTime, false, true, false)
			end
			
			if (part == 9) then
				outputChatBox("Headshot.")
				setElementHealth(source, (getElementHealth(source) - 10))
			else
				setElementHealth(source, (getElementHealth(source) - 2))
			end
					
			setTimer(function (player)
				setElementData(player, "isTazerd", false)
				setElementFrozen(player, false)
				setElementPosition(player, getElementPosition(player))
				
				if (Autotie) then
					-- Work in Progress
				end
			end, tazerTime, 1, source)
			
			triggerClientEvent(getRootElement(), "c_onPlayerTazerd", source)
			
			outputConsole("DEBUG: [Tazer: Du wurdest von "..getPlayerName(pol).." getazert]", source)
			outputConsole("DEBUG: [Tazer: Du hast "..getPlayerName(source).." getazert!]", pol)
		else
			outputConsole("DEBUG: [Tazer: Du bist von "..getPlayerName(source).." zu weit entfernt!]", pol)
		end
	end
end
addEvent("s_TazerPlayer", true)
addEventHandler("s_TazerPlayer", root, onPlayerTazerd)