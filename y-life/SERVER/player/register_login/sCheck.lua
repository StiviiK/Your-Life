-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sCheck.lua     	   	        ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local Serial = {}
function Anti_MultiAccount (playerNick)
	local player = getPlayerFromName(playerNick)
	Serial[player] = md5(getPlayerSerial(player))
	local result, num_affected_rows, errms = dbPoll(dbQuery( mySQLData.handler, "SELECT * FROM userdata_serial WHERE serial = '"..Serial[player].."';" ), -1)
	Serial[player] = nil
	
	if num_affected_rows > 0 then
		for i, row in pairs ( result ) do
			checkname = row["username"]
		end
		
		if not (checkname == getPlayerName(player)) then
			--kickPlayer(source, "Anti Multiaccount System", "(Multiaccounts sind Verboten!)\n(Original Account: "..checkname..")")
			cancelEvent(true, "Es wurde bereits ein Registrierter Account gefunden!\nAccount Name: "..checkname.."\n\nBei Fragen wende dich an das Team.\nTS IP: NIL")
		end
	end
end
addEventHandler("onPlayerConnect", getRootElement(), Anti_MultiAccount)