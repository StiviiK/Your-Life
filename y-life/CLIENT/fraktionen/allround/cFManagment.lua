-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cFManagement.lua		   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local fManagement = {
	button = {},
	memo = {}
}

function SaveFactionVehicles (table)
	for id, _ in pairs(validFactionID) do
		factionVehicles[id] = table[id]
	end
end
addEvent("sendFactionVehicles", true)
addEventHandler("sendFactionVehicles", root, SaveFactionVehicles)

local sName
local sFaction
local sPlaytime
local sFPlayTime = "-//-"
local sFRank

function guiFManagement ()
	sName = getPlayerName(getLocalPlayer())
	sFaction = factionNames[getElementData(getLocalPlayer(), "player.faction")]
	sPlaytime = math.floor(getElementData(getLocalPlayer(), "player.playtime") / 60)..":"..getElementData(getLocalPlayer(), "player.playtime") - (math.floor(getElementData(getLocalPlayer(), "player.playtime") / 60) * 60)
	sFPlayTime = "-//-"
	sFRank = factionRanks[getElementData(getLocalPlayer(), "player.faction")][getElementData(getLocalPlayer(), "rank")].." ("..getElementData(getLocalPlayer(), "rank")..")"

	fManagement.memo.message = guiCreateMemo(1026, 193, 233, 256, "Noch nicht implementiert!", false) -- Nachricht
	guiMemoSetReadOnly(fManagement.memo.message, true) 
	fManagement.caredit = guiCreateEdit(949, 861, 370, 25, "", false) -- Fahrzeug
		
	fManagement.carlist = guiCreateGridList(14, 555, 509, 331, false) -- Fahrzeug Liste	
	fManagement.gridID = guiGridListAddColumn(fManagement.carlist, "ID", 0.05)
	fManagement.gridModel = guiGridListAddColumn(fManagement.carlist, "Fahrzeugname", 0.2)
	fManagement.gridRank = guiGridListAddColumn(fManagement.carlist, "Rang", 0.2)
	fManagement.gridPlace = guiGridListAddColumn(fManagement.carlist, "Standort", 0.2)
	fManagement.gridHealth = guiGridListAddColumn(fManagement.carlist, "Fahrzeug Schaden", 0.2)
	for _, veh in pairs(factionVehicles[getElementData(getLocalPlayer(), "player.faction")]) do
		local row = guiGridListAddRow(fManagement.carlist)
		
		if (row) then
			local pos = {getElementPosition(veh)}
			guiGridListSetItemText(fManagement.carlist, row, fManagement.gridID, getElementData(veh, "vehicle.autonummer"), false, true)
			guiGridListSetItemText(fManagement.carlist, row, fManagement.gridModel, getVehicleName(veh), false, false)
			guiGridListSetItemText(fManagement.carlist, row, fManagement.gridRank, getElementData(veh, "vehicle.frank"), false, true)
			guiGridListSetItemText(fManagement.carlist, row, fManagement.gridPlace, getZoneName(pos[1], pos[2], pos[3]), false, false)
			guiGridListSetItemText(fManagement.carlist, row, fManagement.gridHealth, math.floor((((1000 - getElementHealth(veh))/100)*1000)/100).." %", false, false)
		end
	end
	
		
	fManagement.playerList = guiCreateComboBox(1026, 58, 233, 182, "", false) -- Player Select
	for _, player in pairs(getElementsByType("player")) do
		guiComboBoxAddItem(fManagement.playerList, getPlayerName(player))
	end
	guiComboBoxSetSelected(fManagement.playerList, 0)
	
	fManagement.newrank = guiCreateComboBox(1026, 128, 233, 182, "", false) -- Neuer Rang
	for rankid, rank in ipairs(factionRanks[getElementData(getLocalPlayer(), "player.faction")]) do
		guiComboBoxAddItem(fManagement.newrank, rank.." | "..rankid)
	end
	guiComboBoxSetSelected(fManagement.newrank, (#factionRanks[getElementData(getLocalPlayer(), "player.faction")] - 1))
	
	fManagement.memo.errorlog = guiCreateMemo(1026, 486, 560, 34, "", false)
    guiMemoSetReadOnly(fManagement.memo.errorlog, true)    
	
	fManagement.button.close = dxCreateButton(1333*px, 861*py, 257*px, 25*py, "Schließen", 0.6, "bankgothic", 254, 139, 0, 212, false, closeGUI)
	
	fManagement.button.invite = dxCreateButton(1280, 88, 140, 26, "Invite", 0.6, "bankgothic", 254, 139, 0, 212, false, function () outputChatBox("It works!") end)
	fManagement.button.uninvite = dxCreateButton(1441, 88, 140, 26, "Uninvite", 0.6, "bankgothic", 254, 139, 0, 212, false, function () outputChatBox("It works!") end)
	
	fManagement.button.promote = dxCreateButton(1280, 156, 140, 26, "Befördern", 0.6, "bankgothic", 254, 139, 0, 212, false,
		function ()
			local rank
			local target = getPlayerFromName(guiComboBoxGetItemText(fManagement.playerList, guiComboBoxGetSelected(fManagement.playerList)))
			
			if (target) and (getPlayerName(target) ~= getPlayerName(getLocalPlayer())) then
				if getElementData(getLocalPlayer(), "player.faction") == getElementData(target, "player.faction") then
					rank = tonumber(split(guiComboBoxGetItemText(fManagement.newrank, guiComboBoxGetSelected(fManagement.newrank)), '|')[2])
					
					if (getElementData(target, "rank") <= rank) and (getElementData(target, "rank") ~= rank) and (getElementData(target, "rank") ~= 0) then
						triggerServerEvent("s_giveRank", getLocalPlayer(), getLocalPlayer(), "", target, rank)
					else
						if (getElementData(target, "rank")) == 0 then
							guiSetText(fManagement.memo.errorlog, "[ERROR] Du kannst den Spieler nicht befördern!")
						elseif (getElementData(target, "rank")) == rank then
							guiSetText(fManagement.memo.errorlog, "[ERROR] Der Spieler hat bereits diesen Rang!")
						else
							guiSetText(fManagement.memo.errorlog, "[ERROR] Du kannst den Spieler nicht auf diesen Rang befördern!")
						end
					end
				end
			else
				guiSetText(fManagement.memo.errorlog, "[ERROR] Du kannst nicht deinen eigenen Rang ändern!")
			end
		end
	)
	fManagement.button.degrade = dxCreateButton(1441, 156, 140, 26, "Degradieren", 0.6, "bankgothic", 254, 139, 0, 212, false, 
		function ()
			local rank
			local target = getPlayerFromName(guiComboBoxGetItemText(fManagement.playerList, guiComboBoxGetSelected(fManagement.playerList)))
			
			if (target) and (getPlayerName(target) ~= getPlayerName(getLocalPlayer())) then
				if getElementData(getLocalPlayer(), "player.faction") == getElementData(target, "player.faction") then
					rank = tonumber(split(guiComboBoxGetItemText(fManagement.newrank, guiComboBoxGetSelected(fManagement.newrank)), '|')[2])

					if (getElementData(target, "rank") >= rank) and (getElementData(target, "rank") ~= rank) and (getElementData(target, "rank") ~= 0) then
						triggerServerEvent("s_giveRank", getLocalPlayer(), getLocalPlayer(), "", target, rank)
					else
						if (getElementData(target, "rank")) == 0 then
							guiSetText(fManagement.memo.errorlog, "[ERROR] Du kannst den Spieler nicht degradieren!")
						elseif (getElementData(target, "rank")) == rank then
							guiSetText(fManagement.memo.errorlog, "[ERROR] Der Spieler hat bereits diesen Rang!")
						else
							guiSetText(fManagement.memo.errorlog, "[ERROR] Du kannst den Spieler nicht auf diesen Rang degradieren!")
						end
					end
				end
			else
				guiSetText(fManagement.memo.errorlog, "[ERROR] Du kannst nicht deinen eigenen Rang ändern!")
			end
		end
	)
	fManagement.button.updateinfo = dxCreateButton(1278, 416, 293, 27, "Informationen Updaten", 0.6, "bankgothic", 254, 139, 0, 212, false, 
		function ()
			local target = getPlayerFromName(guiComboBoxGetItemText(fManagement.playerList, guiComboBoxGetSelected(fManagement.playerList)))
			
			if getElementData(getLocalPlayer(), "player.faction") == getElementData(target, "player.faction") then
				sName = getPlayerName(target)
				sFaction = factionNames[getElementData(target, "player.faction")]
				sPlaytime = math.floor(getElementData(target, "player.playtime") / 60)..":"..getElementData(target, "player.playtime") - (math.floor(getElementData(target, "player.playtime") / 60) * 60)
				sFPlayTime = "-//-"
				sFRank = factionRanks[getElementData(target, "player.faction")][getElementData(target, "rank")].." ("..getElementData(target, "rank")..")"
			
				guiSetText(fManagement.memo.errorlog, "[INFO] Die Informationen für "..getPlayerName(target).." werden angezeigt!")
			else
				sName = getPlayerName(getLocalPlayer())
				sFaction = factionNames[getElementData(getLocalPlayer(), "player.faction")]
				sPlaytime = math.floor(getElementData(getLocalPlayer(), "player.playtime") / 60)..":"..getElementData(getLocalPlayer(), "player.playtime") - (math.floor(getElementData(getLocalPlayer(), "player.playtime") / 60) * 60)
				sFPlayTime = "-//-"
				sFRank = factionRanks[getElementData(getLocalPlayer(), "player.faction")][getElementData(getLocalPlayer(), "rank")].." ("..getElementData(getLocalPlayer(), "rank")..")"
				
				guiSetText(fManagement.memo.errorlog, "[ERROR] Can't show Information for "..getPlayerName(target).." (Access denied!)")
			end
		end
	)
end

function dxFManagement ()
	dxDrawRectangle(0, 0, 1600, 20, tocolor(254, 139, 0, 212), false)
	dxDrawText("Fraktions-Management:", -7, 0, 1593, 20, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "top", false, false, false, false, false)

	dxDrawRectangle(10, 533, 517, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(10, 552, 517, 338, tocolor(0, 0, 0, 210), false)
	dxDrawText("Fraktions-Fahrzeuge:", 20, 533, 517, 548, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(537, 626, 398, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(537, 646, 398, 244, tocolor(0, 0, 0, 210), false)
	dxDrawText("Fahrzeug-Optionen:", 547, 626, 925, 641, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(945, 838, 378, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(945, 856, 378, 34, tocolor(0, 0, 0, 210), false)
	dxDrawText("Fahrzeug-Eingabebox:", 955, 837, 1313, 852, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(1329, 838, 265, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(1329, 856, 265, 34, tocolor(0, 0, 0, 210), false)
	dxDrawText("Schliessen:", 1339, 838, 1579, 851, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
		
	dxDrawRectangle(10, 35, 318, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(10, 54, 318, 403, tocolor(0, 0, 0, 210), false)
	dxDrawText("Memberliste:", 20, 35, 318, 50, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(1272, 30, 318, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(1272, 50, 318, 403, tocolor(0, 0, 0, 210), false)
	dxDrawText("Member Verwaltung:", 1282, 30, 1580, 45, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(1021, 30, 241, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(1022, 50, 241, 39, tocolor(0, 0, 0, 210), false)
	dxDrawText("Spieler:", 1026, 30, 1247, 45, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(1021, 99, 241, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(1022, 119, 241, 39, tocolor(0, 0, 0, 210), false)
	dxDrawText("Neuer Rang:", 1028, 99, 1249, 114, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawRectangle(1022, 168, 241, 15, tocolor(254, 139, 0, 212), false)
	dxDrawRectangle(1022, 189, 241, 264, tocolor(0, 0, 0, 210), false)
	dxDrawText("Nachricht:", 1028, 168, 1249, 183, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
	
	dxDrawText("Invite / Uninvite:", 1276, 58, 1581, 84, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "center", false, false, false, false, false)
	
	dxDrawText("Befördern / Degradieren:", 1276, 124, 1581, 150, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "center", false, false, false, false, false)
	
	dxDrawText("Spieler-Informationen:", 1276, 220, 1581, 230, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "center", false, false, false, false, false)
	dxDrawText("Name: "..sName, 1276, 240, 1581, 256, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawText("Fraktion: "..sFaction, 1276, 256, 1581, 272, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawText("Spielstunden: "..sPlaytime, 1276, 272, 1581, 288, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawText("Fraktions-Stunden: "..sFPlayTime, 1276, 288, 1581, 304, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawText("Fraktions-Rang: "..sFRank, 1276, 304, 1581, 320, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawText("Skin:", 1276, 320, 1310, 336, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawImage(1315, 320, 81, 80, ":admin/client/images/flags/us.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
	dxDrawRectangle(1022, 461, 568, 15, tocolor(254, 139, 0, 212), false)
    dxDrawRectangle(1022, 482, 568, 42, tocolor(0, 0, 0, 210), false)
    dxDrawText("Information/Error Box:", 1032, 461, 1576, 476, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, true, false, false)
end

addCommandHandler("testf", function ()
	toggleRadar(false)
	toggleChatbox(false)
	showCursor(true)
	--showChat(false)
	addEventHandler("onClientRender", root, dxFManagement)
	guiFManagement()
end)

function closeGUI ()
	toggleRadar(true)
	toggleChatbox(true)
	
	showCursor(false)
	showChat(true)
	
	removeEventHandler("onClientRender", root, dxFManagement)
	
	guiComboBoxClear(fManagement.playerList)
	guiGridListClear(fManagement.carlist)
	
	destroyElement(fManagement.caredit)
	destroyElement(fManagement.newrank)
	destroyElement(fManagement.carlist)
	destroyElement(fManagement.playerList)
	
	for _, memo in pairs(fManagement.memo) do
		destroyElement(memo)
	end
	
	for _, button in pairs(fManagement.button) do
		dxRemoveButton(button)
	end
	
	sName = getPlayerName(getLocalPlayer())
	sFaction = factionNames[getElementData(getLocalPlayer(), "player.faction")]
	sPlaytime = math.floor(getElementData(getLocalPlayer(), "player.playtime") / 60)..":"..getElementData(getLocalPlayer(), "player.playtime") - (math.floor(getElementData(getLocalPlayer(), "player.playtime") / 60) * 60)
	sFPlayTime = "-//-"
	sFRank = factionRanks[getElementData(getLocalPlayer(), "player.faction")][getElementData(getLocalPlayer(), "rank")].." ("..getElementData(getLocalPlayer(), "rank")..")"
end