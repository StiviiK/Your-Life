-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sPoliceRadio.lua	    	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- //
-- || Created: 15.04.14
-- \\

-- Avoid all Players using the Voice Chat
for i, v in pairs(getElementsByType("player")) do
	setPlayerVoiceBroadcastTo(v, nil)
end

local isPlayerPoliceMuted = {}
local CurrPoliceChannel = {}
local CurrPoliceChannelNumber = {}

-- Define the Police Radio Chat
local PoliceRadio = {
	[1] = {}, -- SFPD
	[2] = {}, -- SWAT
	[3] = {}, -- Army
	[4] = {}, -- Special
}
	
local SFPDRadioVeh = {
	[523] = true,
	[596] = true,
	[598] = true,
	[599] = true,
	[597] = true,
	[497] = true,
	[411] = true
	--[601] = true
}
	
local FBIRadioVeh = {
	[427] = true,
	[490] = true,
	[528] = true
}
	
local ARMYRadioVeh = {
	[433] = true,
	[470] = true,
	--[432] = true,
	--[520] = true,
	--[425] = true

}

local SpecialRadioVeh = {
	[601] = true,
	[432] = true,
	[520] = true,
	[425] = true
}

function UpdateClientTable (currtable, number)
	triggerClientEvent(getRootElement(), "UpdateClientTables", getRootElement(), currtable, number)
end

function removePlayerFromRadio (element)
	if isElement(element) then
		-- Remove the Player from CurrentPoliceChannel
		removePlayerFromTable(CurrPoliceChannel[element], element)
		UpdateClientTable(CurrPoliceChannel[element], CurrPoliceChannelNumber[element])
		
		-- Avoid the Player of hearing the Voice of the ohters
		for i, v in pairs (CurrPoliceChannel[element]) do
			setPlayerVoiceBroadcastTo(v, CurrPoliceChannel[element])
		end
			
		-- Clear the CurrentPoliceChannel
		CurrPoliceChannel[element] = nil
		CurrPoliceChannelNumber[element] = nil
		
		-- Disable the Voice Chat for the Player
		setPlayerVoiceBroadcastTo(element, nil)
		
		-- Clear the Current Channel on Client
		triggerClientEvent(element, "UpdateClientCurChannel", element, nil)
	end
end

function setPoliceRadioChannel (player, ChannelNumber)
	if isElement(player) and ChannelNumber ~= nil and PoliceRadio[ChannelNumber] ~= nil then
		local ChannelNumber = tonumber(ChannelNumber)
		if (not isPlayerPoliceMuted[player]) then
			
			if CurrPoliceChannel[player] ~= nil then
				removePlayerFromTable(CurrPoliceChannel[player], player)
				UpdateClientTable(CurrPoliceChannel[player], CurrPoliceChannelNumber[player])
				
				for i, v in pairs (CurrPoliceChannel[player]) do
					setPlayerVoiceBroadcastTo(v, CurrPoliceChannel[player])
				end
			end
			
			table.insert(PoliceRadio[ChannelNumber], player)
			CurrPoliceChannel[player] = PoliceRadio[ChannelNumber]
			CurrPoliceChannelNumber[player] = ChannelNumber
			
			for i, v in pairs (PoliceRadio[ChannelNumber]) do
				setPlayerVoiceBroadcastTo(v, PoliceRadio[ChannelNumber])
			end
			
			UpdateClientTable(CurrPoliceChannel[player], CurrPoliceChannelNumber[player])
			triggerClientEvent(player, "UpdateClientCurChannel", player, ChannelNumber)
			
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function isRadioVeh (veh)
	if SFPDRadioVeh[getElementModel(veh)] or FBIRadioVeh[getElementModel(veh)] or ARMYRadioVeh[getElementModel(veh)] or SpecialRadioVeh[getElementModel(veh)] then
		return true;
	else
		return false;
	end
end

function getRadioVehChannel (veh)
	if SFPDRadioVeh[getElementModel(veh)] then
		return tonumber(1);
	elseif FBIRadioVeh[getElementModel(veh)] then
		return tonumber(2);
	elseif ARMYRadioVeh[getElementModel(veh)] then
		return tonumber(3);
	elseif SpecialRadioVeh[getElementModel(veh)] then
		return tonumber(4);
	end
end

-- Add the Eventhandlers
function addPlayerPolice (player)
	player = player
	--if not isOnDuty(player) then return; end -- Currently not Aviable!
	if isRadioVeh(source) then
		setPoliceRadioChannel(player, getRadioVehChannel(source))
		
		addEventHandler("onVehicleStartExit", source, remPlayerPolice)
		addEventHandler("onVehicleExplode", source, function ()
			remPlayerPolice(player)
		end)
		addEventHandler("onPlayerQuit", player, onDisconnect)
		addEventHandler("onPedWasted", player, remPlayerPoliceOnDeath)
	end
end
addEventHandler("onVehicleEnter", root, addPlayerPolice)

function remPlayerPolice (player)
	if isRadioVeh(source) then
		removePlayerFromRadio(player)

		removeEventHandler("onVehicleStartExit", source, remPlayerPolice)
		removeEventHandler("onVehicleExplode", source, remPlayerPolice)
		removeEventHandler("onPlayerQuit", player, onDisconnect)
		removeEventHandler("onPlayerWasted", player, remPlayerPoliceOnDeath)
	end
end

function remPlayerPoliceOnDeath ()
	removePlayerFromRadio(source)

	removeEventHandler("onPlayerQuit", source, onDisconnect)
	removeEventHandler("onPlayerWasted", source, remPlayerPoliceOnDeath)
end

function onDisconnect ()
	if isPedInVehicle(source) then
		if isRadioVeh(source) then
			removePlayerFromRadio(source)
		end
	end
end

function SwitchChannel (player, cmd, number)
	setPoliceRadioChannel(player, tonumber(number))
end
addCommandHandler("sch", SwitchChannel)




function testblabla (player)
	veh = createVehicle(569, 0, 0, 0)
	veh2 = createVehicle(470, 0, 0, 0)
	veh3 = createVehicle(470, 0, 0, 0)
	veh4 = createVehicle(470, 0, 0, 0)
	
	warpPedIntoVehicle(player, veh)
	attachElements(veh2, veh, 0, -5.5, -0)
	attachElements(veh3, veh, 0, 0, -0)
	attachElements(veh4, veh, 0, 5.5, -0)
	
	addEventHandler("onElementClicked", veh2, testdetach)
	addEventHandler("onElementClicked", veh3, testdetach)
	addEventHandler("onElementClicked", veh4, testdetach)
	addEventHandler("onElementClicked", veh, function (_, state, player) if state == "down" then warpPedIntoVehicle(player, source) end end)
end
addCommandHandler("testb", testblabla)

function testdetach (theButton, theState, thePlayer) 
	if (source == veh2) or (source == veh3) or (source == veh4) then
		if theState ~= "down" then return false end 
		
		detachElements(source) 
		warpPedIntoVehicle(thePlayer, source)
		
		removeEventHandler("onElementClicked", source, testdetach)
	end
end
