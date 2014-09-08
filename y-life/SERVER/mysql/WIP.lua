-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: // n. v	//				   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local LicenseVar
function checkLicenseFile ()
	if fileExists("license.xml") then
		local XMLHandler = dbConnect("mysql", "dbname=db_698;host=84.200.85.2", "db_698", "hsg2014", "share=1")
		if (not XMLHandler) then
			connect_db("  Can't connect to the License Server  ")
			return false;
		end
		local query = dbQuery( XMLHandler, "SELECT * FROM `license` WHERE 1;")
		local result = dbPoll(query, -1)
		XMLFile = xmlLoadFile("license.xml")
		
		for i, row in pairs (result) do
			if row["Key"] == xmlNodeGetValue (xmlFindChild( XMLFile, "Key", 0 )) then
				dbFree(query)
				LicenseVar = true
				break
			end
		end
		
		if LicenseVar ~= true and (not LicenseVar) then
			outputDebugString(" ")
			outputDebugString(" ")
			outputDebugString("//                                          \\\\")
			outputDebugString("||   Die verwendete Lizenz ist ungueltig!   ||")
			outputDebugString("||      Alle Spieler werden gekickt..       ||")
			outputDebugString("||      Die Resource wird gestoppt...       ||")
			outputDebugString("\\\\                                          //")
			outputDebugString(" ")
			outputDebugString(" ")
		
			for i, v in pairs(getElementsByType('player')) do
				kickPlayer(v, "Unknown License! Please report it to StiviK or Vandam!")
			end
			
			--deleteResource(getResourceName(getThisResource()))
			stopResource(getThisResource())
			setGameType("Startup failure!")
		else
			LicenseVar = false
			local query = dbQuery( XMLHandler, "SELECT * FROM `license` WHERE `Key` = '"..xmlNodeGetValue (xmlFindChild( XMLFile, "Key", 0 )).."';")
			local result = dbPoll(query, -1)
				
			for i, row1 in pairs(result) do
				if row1["used"] == "true" then
					LicenseVar = true
				end
			end
			
			dbFree(query)
			
			if LicenseVar ~= true then
				outputDebugString(" ")
				outputDebugString(" ")
				outputDebugString("//                                          \\\\")
				outputDebugString("||   Die verwendete Lizenz ist ungueltig!   ||")
				outputDebugString("||      Alle Spieler werden gekickt..       ||")
				outputDebugString("||      Die Resource wird gestoppt...       ||")
				outputDebugString("\\\\                                          //")
				outputDebugString(" ")
				outputDebugString(" ")
			
				for i, v in pairs(getElementsByType('player')) do
					kickPlayer(v, "Unknown License! Please report it to StiviK or Vandam!")
				end
				
				--deleteResource(getResourceName(getThisResource()))
				stopResource(getThisResource())
				setGameType("Startup failure!")
			else
				connect_db("Es wurde eine gueltige Lizenz gefunden!")
			end
		end
	else
		outputDebugString(" ")
		outputDebugString(" ")
		outputDebugString("//                                          \\\\")
		outputDebugString("||  Die Lizenz Datei wurde nicht gefunden!  ||")
		outputDebugString("||           Datei wird erstelt...          ||")
		outputDebugString("||      Alle Spieler werden gekickt..       ||")
		outputDebugString("||      Die Resource wird gestoppt...       ||")
		outputDebugString("\\\\                                          //")
		outputDebugString(" ")
		outputDebugString(" ")
	
		local lfile = xmlCreateFile("license.xml", "License")
		xmlCreateChild(lfile, "Key")
		xmlSaveFile(lfile)
		
		for i, v in pairs(getElementsByType('player')) do
			kickPlayer(v, "Unknown License! Please report it to StiviK or Vandam!")
		end
		
		stopResource(getThisResource())
		setGameType("Startup failure!")
	end
end
--checkLicenseFile()
connect_db("Es wurde eine gueltige Lizenz gefunden!")

-- Langeweile ;)
local obj
local veh
function testfall (player)
	if isElement(obj) then destroyElement(obj) destroyElement(veh) destroyElement(obj2) destroyElement(obj3) destroyElement(obj4) destroyElement(obj5) destroyElement(obj6) destroyElement(veh2) destroyElement(veh3) destroyElement(veh4) end
	local x, y, z = getElementPosition(player)
	local var = 1
	obj = createObject(980, x, y, z + var)
	obj2 = createObject(980, x, y, z + var)
	obj3 = createObject(980, x, y, z + var)
	obj4 = createObject(980, x, y, z + var)
	obj5 = createObject(980, x, y, z + var)
	obj6 = createObject(980, x, y, z + var)
	blip = createBlip(x, y, z, 35)
	veh = createVehicle(getVehicleModelFromName("Rancher"), x, y, z + var)
	veh2 = createVehicle(getVehicleModelFromName("Rhino"), x, y, z + var)
	veh3 = createVehicle(getVehicleModelFromName("Rhino"), x, y, z + var)
	veh4 = createVehicle(getVehicleModelFromName("Rhino"), x, y, z + var)

	bindKey(player, "enter", "down", function () 
		--killTimer(speedtimer)
		
		removePedFromVehicle(getPedOccupiedVehicle(player)) 
		unbindKey(player, "enter", "down")
		unbindKey(player, "num_add", "down")
		
		destroyElement(obj) 
		destroyElement(veh) 
		destroyElement(obj2) 
		destroyElement(obj3) 
		destroyElement(obj4) 
		destroyElement(obj5) 
		destroyElement(obj6)
		destroyElement(blip)
		destroyElement(veh2)
		destroyElement(veh3)
		destroyElement(veh4)
		
		setElementAlpha(player, 255)
	end)
	
	warpPedIntoVehicle(player, veh)
	warpPedIntoVehicle(getPlayerFromName("StiviK"), veh)
	setElementHealth(veh, 1000000)
	setElementAlpha(veh, 0)
	setElementAlpha(player, 0)
	attachElements(obj, veh, 0 - 5.8, 0, 0, 0, 0, 90)
	attachElements(obj2, veh, 0 + 5.8, 0, 0, 0, 0, 90)
	attachElements(obj3, veh, 0, 0 + 5.8, 0, 0, 0, 0)
	attachElements(obj4, veh, 0, 0 - 5.8, 0, 0, 0, 0)
	attachElements(obj5, veh, 0, 0, 0, 0, 0, 90)
	attachElements(obj6, veh, 0, 0, 0, 0, 0, 0)
	attachElements(veh2, veh, 0 - 5, 0, 3.5, 0, 0, 0)
	attachElements(veh3, veh, 0, 0, 3.5, 0, 0, 0)
	attachElements(veh4, veh, 0 + 5, 0, 3.5, 0, 0, 0)
	attachElements(blip, veh)
end
addCommandHandler("testnicefallbitch", testfall)