-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sLogOnPlayerWasted.lua	    ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

function LogOnPlayerWasted (ammo, attacker, weapon, bodypart)
	local time = getRealTime()
	if time.month < 10 then month = "0"..(time.month + 1) else month = time.month end
	if time.monthday < 10 then day = "0"..time.monthday else day = time.monthday end
	if time.hour < 10 then hour = "0"..time.hour else hour = time.hour end
	if time.minute < 10 then minute = "0"..time.minute else minute = time.minute end
	if time.second < 10 then second = "0"..time.second else second = time.second end
	
	local logpath = "FILES/logs/"..day.."."..month.."."..(time.year-100).."/KillLog.log"
	
	if (not existsLog(logpath)) then
		WriteLog(getLog(logpath), "Log gestartet am "..day.."."..month.."."..(time.year+1900).." um "..hour..":"..minute..":"..second..".\n")
	end
	
	if attacker then
		text = "["..hour..":"..minute..":"..second.."] Der Spieler "..getPlayerName(source).." wurde von "..getPlayerName(attacker).." getötet! [Weapon: "..getWeaponNameFromID(weapon).."] [Bodypart: "..getBodyPartName(bodypart).."]" 
	else
		text = "["..hour..":"..minute..":"..second.."] Der Spieler "..getPlayerName(source).." ist gestorben!"
	end
	
	WriteLog(getLog(logpath), text)
end