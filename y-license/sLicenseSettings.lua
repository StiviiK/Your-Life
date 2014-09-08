-- //
-- || Resource: License Setting's for Y-Life Gamemode
-- || Author: StiviK
-- || Date of creation: 13.04.14
--  \\

function ConnectDB (player)
	handler = dbConnect("mysql", "dbname=db_698;host=84.200.85.2", "db_698", "hsg2014", "share=1")
	
	if (not handler) then
	
	else
		getLicenseKeys(player, false)
	end
end
addCommandHandler("testgui", ConnectDB)

function getLicenseKeys (player, state)
	local query = dbQuery(handler, "SELECT * FROM `license` WHERE 1;")
	local result = dbPoll(query, -1)
	if state then
		triggerClientEvent(player, "c_updateGridList", player, result)
	else
		triggerClientEvent(player, "ShowLicenseGUI", player, result)
	end
	dbFree(query)
end

-- //
-- Update Information
local KeyTable = {}
function getLicenseKeyInformations (key)
	local query = dbQuery( handler, "SELECT * FROM `license` WHERE `Key` = '"..key.."';")
	local result = dbPoll(query, -1)
	
	for i, row in pairs(result) do
		status = row["used"]
		owner = row["Owner"]
	end
	
	triggerClientEvent(source, "c_updateKeyData", source, key, status, owner)
end
addEvent("getKeyInformation", true)
addEventHandler("getKeyInformation", root, getLicenseKeyInformations)

-- Update GridList
function updateGridList ()
	getLicenseKeys(source, true)
end
addEvent("s_updateGridList", true)
addEventHandler("s_updateGridList", root, updateGridList)
-- \\

-- //
-- Update Data
-- (Update Owner)
function UpdateOwner (key, newOwner)
	dbExec(handler, "UPDATE `license` SET `Owner`='"..newOwner.."' WHERE `Key`='"..key.."'")
end
addEvent("s_updateOwner", true)
addEventHandler("s_updateOwner", root, UpdateOwner)

-- (Update Owner)
function UpdateOwner (key, newStatus)
	dbExec(handler, "UPDATE `license` SET `used`='"..newStatus.."' WHERE `Key`='"..key.."'")
end
addEvent("s_updateStatus", true)
addEventHandler("s_updateStatus", root, UpdateOwner)