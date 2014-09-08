-- //
-- || Resource: License Setting's for Y-Life Gamemode
-- || Author: StiviK
-- || Date of creation: 13.04.14
--  \\

License = {
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {},
	licenseColum = {}
}
function LicenseGUI (result)
	fadeCamera(true)
	setCameraMatrix(1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)
	
	if isElement(License.window[1]) then destroyElement(License.window[1]) end
	showCursor(true)
	
	local screenW, screenH = guiGetScreenSize()
	License.window[1] = guiCreateWindow((screenW - 786) / 2, (screenH - 563) / 2, 786, 563, "Y-Life Lizenz Verwaltung (by StiviK)", false)
	guiWindowSetSizable(License.window[1], false)
	
	-- License Gridlist
	License.gridlist[1] = guiCreateGridList(10, 26, 378, 527, false, License.window[1])
	guiGridListClear(License.gridlist[1])
	License.licenseColum[1] = guiGridListAddColumn(License.gridlist[1], "Lizenz", 0.9)

	for i, row in pairs(result) do
		local gridrow = guiGridListAddRow (License.gridlist[1])
		Key = tostring(row["Key"])
		guiGridListSetItemText ( License.gridlist[1], gridrow, License.licenseColum[1], Key, false, false )
	end
	
	-- Info Text
	License.label[1] = guiCreateLabel(398, 25, 375, 257, "Willkommen bei der Y-Life Lizenz Verwaltung,\n\nhier koennen alle Lizenzen die fuer diesen\n Gamemode erstellt wurden, eingesehen\noder veraendert werden!\nDesweiteren kann man auch neue Lizenzen\nhinzufuegen. Aus Sicherheitsgruenden, geben sie die \nDaten fuer diese Verwaltung nie weiter! Da sonst unbefugte an\ndie Lizenzen fuer das Script kommen koennten!", false, License.window[1])
	guiSetFont(License.label[1], "default-bold-small")
	guiLabelSetHorizontalAlign(License.label[1], "center", false)
	guiLabelSetVerticalAlign(License.label[1], "center")
	
	-- Information's of the current selected License
	License.label[2] = guiCreateLabel(398, 282, 375, 20, "Infos zur Aktuellen Lizenz:", false, License.window[1])
	guiSetFont(License.label[2], "default-bold-small")
	guiLabelSetHorizontalAlign(License.label[2], "center", false)
	guiLabelSetVerticalAlign(License.label[2], "center")
	License.label[3] = guiCreateLabel(398, 301, 375, 64, "Lizenz Schluessel: none\nLizenz Status: none\nLizenz Besitzer: none", false, License.window[1])
	guiSetFont(License.label[3], "default-bold-small")
	guiLabelSetVerticalAlign(License.label[3], "center")
	
	-- Update Information
	License.button[1] = guiCreateButton(397, 365, 105, 15, "Update", false, License.window[1])
	addEventHandler("onClientGUIClick", License.button[1], sendClientInformationUpdateRequest, false)
	
	-- Update List
	License.button[2] = guiCreateButton(512, 365, 105, 15, "Update List", false, License.window[1])
	addEventHandler("onClientGUIClick", License.button[2], UpdateGridlist, false)
	
	-- Update Owner
	License.label[4] = guiCreateLabel(398, 410, 269, 18, "Neuer Besitzer:", false, License.window[1])
	guiSetFont(License.label[4], "default-bold-small")
	License.edit[1] = guiCreateEdit(397, 429, 270, 25, "", false, License.window[1])
	License.button[3] = guiCreateButton(677, 428, 96, 26, "Update Besitzer", false, License.window[1])
	addEventHandler("onClientGUIClick", License.button[3], UpdateOwner, false)
	
	-- Update License Status
	License.label[5] = guiCreateLabel(398, 459, 269, 18, "Neuer Lizenz Status: (true/false)", false, License.window[1])
	guiSetFont(License.label[5], "default-bold-small")
	License.edit[2] = guiCreateEdit(397, 477, 270, 25, "", false, License.window[1])
	License.button[4] = guiCreateButton(677, 477, 96, 26, "Update Status", false, License.window[1])
	addEventHandler("onClientGUIClick", License.button[4], UpdateStatus, false)
	
	License.button[5] = guiCreateButton(392, 518, 384, 35, "Schliessen (No Auto-Save!)", false, License.window[1])
end
addEvent("ShowLicenseGUI", true)
addEventHandler("ShowLicenseGUI", root, LicenseGUI)

-- //
-- Update Gridlist
function reFillLicenseGrind (result)
	guiGridListClear(License.gridlist[1])
	for i, row in pairs(result) do
		local gridrow = guiGridListAddRow (License.gridlist[1])
		Key = tostring(row["Key"])
		guiGridListSetItemText ( License.gridlist[1], gridrow, License.licenseColum[1], Key, false, false )
	end
end
addEvent("c_updateGridList", true)
addEventHandler("c_updateGridList", root, reFillLicenseGrind)
--\\

-- //
-- Update Gridlist
function UpdateGridlist ()
	triggerServerEvent("s_updateGridList", getLocalPlayer())
end

-- Update Information
function sendClientInformationUpdateRequest ()
	local row = guiGridListGetSelectedItem(License.gridlist[1])
	local key = guiGridListGetItemText(License.gridlist[1], row, License.licenseColum[1])
	
	if key ~= "" then
		triggerServerEvent("getKeyInformation", getLocalPlayer(), key)
	else
		guiSetText(License.label[3], "Lizenz Schluessel: none\nLizenz Status: none\nLizenz Besitzer: none")
	end
end

local cKeyTable = {}
function getClientKeyInformations (key, status, owner)
	cKeyTable[key] = {}
	cKeyTable[key]["status"] = status
	cKeyTable[key]["owner"] = owner
	
	guiSetText(License.label[3], "Lizenz Schluessel: "..key.."\nLizenz Status: "..cKeyTable[key]["status"].."\nLizenz Besitzer: "..cKeyTable[key]["owner"])
end
addEvent("c_updateKeyData", true)
addEventHandler("c_updateKeyData", root, getClientKeyInformations)
-- \\

--//
-- Update Owner
function UpdateOwner ()
	local row = guiGridListGetSelectedItem(License.gridlist[1])
	local key = guiGridListGetItemText(License.gridlist[1], row, License.licenseColum[1])
	
	if key ~= "" then
		local newOwner = guiGetText(License.edit[1])
		if newOwner ~= "" then 
			triggerServerEvent("s_updateOwner", getLocalPlayer(), key, newOwner)
			sendClientInformationUpdateRequest()
		
			destroyElement(License.edit[1])
			License.edit[1] = guiCreateEdit(397, 429, 270, 25, "", false, License.window[1])
		else
			outputChatBox("Bitte gebe einen neuen Besitzer ein!", 125, 0, 0) 
		end
	else
		outputChatBox("Bitte wähle einen Lizenz Schlüssel!", 125, 0, 0)
	end
end

-- Update Status
function UpdateStatus ()
	local row = guiGridListGetSelectedItem(License.gridlist[1])
	local key = guiGridListGetItemText(License.gridlist[1], row, License.licenseColum[1])
	
	if key ~= "" then
		local newStatus = guiGetText(License.edit[2])
		if newStatus == "true" or newStatus == "false" then 
			triggerServerEvent("s_updateStatus", getLocalPlayer(), key, newStatus)
			sendClientInformationUpdateRequest()
		
			destroyElement(License.edit[2])
			License.edit[2] = guiCreateEdit(397, 477, 270, 25, "", false, License.window[1])
		else
			outputChatBox("Bitte gebe einen neuen Status ein!", 125, 0, 0) 
		end
	else
		outputChatBox("Bitte wähle einen Lizenz Schlüssel!", 125, 0, 0)
	end
end