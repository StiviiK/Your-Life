-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sLogJoinQuit.lua	    	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local month
local day
local text
function LogOnPlayerConnect ()
	local time = getRealTime()
	if time.month < 10 then month = "0"..(time.month + 1) else month = time.month end
	if time.monthday < 10 then day = "0"..time.monthday else day = time.monthday end
	if time.hour < 10 then hour = "0"..time.hour else hour = time.hour end
	if time.minute < 10 then minute = "0"..time.minute else minute = time.minute end
	if time.second < 10 then second = "0"..time.second else second = time.second end
	
	local logpath = "FILES/logs/"..day.."."..month.."."..(time.year-100).."/JoinQuitLog.log"
	
	if (not existsLog(logpath)) then
		WriteLog(getLog(logpath), "Log gestartet am "..day.."."..month.."."..(time.year+1900).." um "..hour..":"..minute..":"..second..".\n")
	end
	
	text = "["..hour..":"..minute..":"..second.."] Der Spieler "..getPlayerName(source).." hat den Server betreten! [IP: "..getPlayerIP(source).."] [Serial: "..getPlayerSerial(source).."] [Version: "..getPlayerVersion(source).."]"
	
	WriteLog(getLog(logpath), text)
end

function LogOnPlayerQuit (quitType, reason)
	local time = getRealTime()
	if time.month < 10 then month = "0"..(time.month + 1) else month = time.month end
	if time.monthday < 10 then day = "0"..time.monthday else day = time.monthday end
	if time.hour < 10 then hour = "0"..time.hour else hour = time.hour end
	if time.minute < 10 then minute = "0"..time.minute else minute = time.minute end
	if time.second < 10 then second = "0"..time.second else second = time.second end
	
	local logpath = "FILES/logs/"..day.."."..month.."."..(time.year-100).."/JoinQuitLog.log"
	
	if (not existsLog(logpath)) then
		WriteLog(getLog(logpath), "Log gestartet am "..day.."."..month.."."..(time.year+1900).." um "..hour..":"..minute..":"..second..".\n")
	end
	
	if quitType == "Kicked" or quitType == "Banned" then
		if reason then
			text = "["..hour..":"..minute..":"..second.."] Der Spieler "..getPlayerName(source).." hat den Server verlassen! [Reason: "..quitType.." ("..reason..")]"
		else
			text = "["..hour..":"..minute..":"..second.."] Der Spieler "..getPlayerName(source).." hat den Server verlassen! [Reason: "..quitType.."]"
		end
	else
		text = "["..hour..":"..minute..":"..second.."] Der Spieler "..getPlayerName(source).." hat den Server verlassen! [Reason: "..quitType.."]"
	end
	
	WriteLog(getLog(logpath), text)
end