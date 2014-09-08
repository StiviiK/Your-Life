-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: mysql_handler.lua   	  	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

function connect_db (licensestatus)
	mySQLData.handler = dbConnect(mySQLData.connectionType, "dbname="..mySQLData.dbName..";host="..mySQLData.host.."", mySQLData.username, mySQLData.password, mySQLData.options)

	if (mySQLData.handler) then	
		--// JUST FOR FUN
		local first = Developer[math.random(1,2)]
		local second
		if first == "Vandam" then
			second = Developer[2]
		else
			second = Developer[1]
		end
		--\\
		outputDebugString("//                                         \\\\")
		outputDebugString("||  Verbindung zur Datenbank hergestellt!  ||")
		outputDebugString("|| "..licensestatus.." ||")
		outputDebugString("||                                         ||")
		outputDebugString("||                YOUR LIFE                ||")
		outputDebugString("||                                         ||")
		outputDebugString("||    a Gamemode by "..first.." and "..second.."      ||")
		outputDebugString("\\\\                                         //")
		
		setGameType("Your Life")
	else
		outputDebugString("//                                          \\\\")
		outputDebugString("|| Verbindung zur Datenbank fehlgeschlagen! ||")
		outputDebugString("||    Bitte die Verbindung ueberpruefen!    ||")
		outputDebugString("|| "..licensestatus.."  ||")
		outputDebugString("||      Alle Spieler werden gekickt..       ||")
		outputDebugString("||      Die Resource wird gestoppt...       ||")
		outputDebugString("\\\\                                          //")
		
		for i, v in pairs(getElementsByType('player')) do
			kickPlayer(v, "ERROR: MySQL Connection failed! Please contact an Admin!")
		end
		
		stopResource(getThisResource())
		setGameType("Startup failure!")
	end
end