-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: bansys.lua				   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- global ban table
gBan = {}

-- backup global functions
gBan.ms_banIP = banIP
gBan.ms_banPlayer = banPlayer
gBan.ms_banSerial = banSerial

-- save the failed entry's
gBan.m_WEntry = {}

-- da functions
function gBan.log (message)
	triggerEvent("onAdminBanAction", getRootElement(), "[Y-Ban] "..message)
end

function gBan.initialize ()
	-- add da events
	addEventHandler("onPlayerConnect", root, gBan.onConnect)
	
	-- add da commands
	addCommandHandler("tban", gBan.tBan)
	
	-- call da startup functions
	gBan.checkBans()
	
	gBan.log("BanSystem initialized!")
end

function gBan.destructor ()
	-- remove da event
	removeEventHandler("onPlayerConnect", root, gBan.onConnect)
	
	-- remove da commands
	removeCommandHandler("failedbans")

	gBan.log("BanSystem has been shutdown")
end

function gBan.onConnect (playerNick, _, _, playerSerial)
	local query = dbQuery(mySQLData.handler, "SELECT * FROM `userdata_bans` WHERE `??` = ? AND `??` = ?;", "username", playerNick, "serial", md5(playerSerial):upper())
	local result, num_affected_rows = dbPoll(query, -1)
	
	if (num_affected_rows > 0) then	
		for _, row in ipairs(result) do
			if (row["type"] == "perm") then
				gBan.log("Permanent banned player "..playerNick.." tried to join the Server! [Ban-Reason: "..row["reason"].."; Banned by: "..row["admin"].."]")
				cancelEvent(true, "Du wurdest von "..row["admin"].." permanent gebannt!\nFür weitere Infos logge dich ins ControlPanel ein!")
			elseif (row["type"] == "temp") then
				if (row["e_bantime"] - getRealTime().timestamp) <= 0 then
					dbExec(mySQLData.handler, "DELETE FROM `userdata_bans` WHERE `??` = ? and `??` = ?;", "username", playerNick, "serial", md5(playerSerial):upper())
				else
					local time = ""
				
					if (row["e_bantime"] - getRealTime().timestamp) < 60 then
						time = ("%s Sekunden"):format(((row["e_bantime"] - getRealTime().timestamp) - (math.floor((row["e_bantime"] - getRealTime().timestamp)/60)*60)))
					elseif (row["e_bantime"] - getRealTime().timestamp) > 3600 then
						time = ("%s Stunden, %s Minuten und %s Sekunden"):format(math.floor(((row["e_bantime"] - getRealTime().timestamp)/60)/60), (math.floor((row["e_bantime"] - getRealTime().timestamp)/60) - (math.floor(((row["e_bantime"] - getRealTime().timestamp)/60)/60))*60), ((row["e_bantime"] - getRealTime().timestamp) - (math.floor((row["e_bantime"] - getRealTime().timestamp)/60)*60)))
					elseif (row["e_bantime"] - getRealTime().timestamp) >= 120 then
						time = ("%s Minuten und %s Sekunden"):format((math.floor((row["e_bantime"] - getRealTime().timestamp)/60)), ((row["e_bantime"] - getRealTime().timestamp) - (math.floor((row["e_bantime"] - getRealTime().timestamp)/60)*60)))
					elseif (row["e_bantime"] - getRealTime().timestamp) >= 60 then
						time = ("%s Minute und %s Sekunden"):format((math.floor((row["e_bantime"] - getRealTime().timestamp)/60)), ((row["e_bantime"] - getRealTime().timestamp) - (math.floor((row["e_bantime"] - getRealTime().timestamp)/60)*60)))
					end
					
					gBan.log("Temporarily banned player "..playerNick.." tried to join the Server! [Ban-Reason: "..row["reason"].."; Banned by: "..row["admin"].."; Restime "..(row["e_bantime"] - getRealTime().timestamp).."s ]")
					cancelEvent(true, "Du wurdest von "..row["admin"].." temporär gebannt!\nDu bist noch für "..time.." gebannt!\nFür weitere Infos logge dich ins ControlPanel ein!")
				end
			else
				gBan.log("While player "..playerNick.." tried to connect a error occured! [Error Code: '1'; Error Description: 'Invalid ban type!']")
				cancelEvent(true, "In der Datenbank wurde ein Fehler gefunden!\nBitte melde diesen Error einem Admin!\n[Error Code: '1'; Error Description: 'Invalid ban type!']")
			end
		end
	end
	
	dbFree(query)
end

function gBan.checkBans ()
	local query = dbQuery(mySQLData.handler, "SELECT * FROM `userdata_bans`;")
	local result, num_affected_rows = dbPoll(query, -1)
	local counter = 0
	local counter2 = 0
	
	if (num_affected_rows > 0) then
		for i, row in ipairs(result) do
			if (row["e_bantime"] - getRealTime().timestamp) <= 0 and (row["type"] == "temp") then
				dbExec(mySQLData.handler, "DELETE FROM `userdata_bans` WHERE `??` = ? and `??` = ?;", "username", row["username"], "serial", row["serial"])
				counter = counter + 1
			elseif (row["type"] ~= "temp") and (row["type"] ~= "perm") then
				gBan.m_WEntry[row["username"]] = {
					id = row["id"],
					btype = row["type"],
					restTime = row["e_bantime"]
				}
				counter2 = counter2 + 1
			end
		end
    end
	
	outputDebugString("Es wurden "..num_affected_rows.." gebannt"..(num_affected_rows == 1 and "er" or "e").." Spieler gefunden. "..counter.." Eintr"..(counter == 1 and "ag" or "äge").." wurden gelöscht!")
	if (counter2 > 0) then
		outputDebugString(counter2.." Eintr"..(counter == 1 and "ag" or "äge").." sind in der Ban-Datenbank fehlerhaft! Type '/failedbans' to show the wrong entry's!")
		addCommandHandler("failedbans", gBan.showFailedBans)
	end
	
	dbFree(query)
end

-- ban commands
	function gBan.rBan ()
	end

	function gBan.tBan (admin, _, player, time, ...)
		local reason = table.concat({...}, " ")
		
		if (player ~= nil and time ~= nil and reason ~= " ") then
			if (time:find("h") and time:find("m") and time:find("s")) then
				local bantime = 0
				
				for _, value in ipairs(split(time, ";")) do
					if (split(value, "=")[1] == "h") then
						bantime = bantime + (split(value, "=")[2]*60)*60
					elseif (split(value, "=")[1] == "m") then
						if (tonumber(split(value, "=")[2]) <= 60) then
							bantime = bantime + split(value, "=")[2]*60
						end
					elseif (split(value, "=")[1] == "s") then
						if (tonumber(split(value, "=")[2]) <= 60) then
							bantime = bantime + split(value, "=")[2]
						end
					end
                end

				if (getPlayerFromName(player)) then
					dbExec(mySQLData.handler, "INSERT INTO `userdata_bans`(`username`, `serial`, `admin`, `reason`, `type`, `s_bantime`, `e_bantime`) VALUES (?,?,?,?,?,?,?);", player, md5(getPlayerSerial(getPlayerFromName(player))) , getPlayerName(admin), reason, "temp", getRealTime().timestamp, (getRealTime().timestamp + bantime))
					kickPlayer(getPlayerFromName(player), getPlayerName(admin), "Du wurdest von "..getPlayerName(admin).." temporär gebannt!")
				else
					local query = dbQuery(mySQLData.handler, "SELECT `serial` FROM `userdata_serial` WHERE `??` = ?;", "username", player)
					local result, num_affected_rows = dbPoll(query, -1)

					if (num_affected_rows > 0) then
						for i, row in ipairs(result) do
							dbExec(mySQLData.handler, "INSERT INTO `userdata_bans`(`username`, `serial`, `admin`, `reason`, `type`, `s_bantime`, `e_bantime`) VALUES (?,?,?,?,?,?,?);", player, row["serial"], getPlayerName(admin), reason, "temp", getRealTime().timestamp, (getRealTime().timestamp + bantime))
						end
					else
						outputDebugString("Player not found!")
					end
				end
				
				gBan.log(getPlayerName(admin).." hat "..player.." für "..getRealTime().timestamp + bantime.."s gebannt!")
			end
		end
	end
--

function gBan.addBan ()
end

function gBan.removeBan ()
end

-- usefull commands

function gBan.showFailedBans ()
	outputChatBox("---------- Failure Information ----------")
	for username, _ in pairs(gBan.m_WEntry) do
		outputChatBox("[Failed Ban] ID: "..gBan.m_WEntry[username].id.." | Username: "..username.." | Type: "..gBan.m_WEntry[username].btype.." | Restime: "..gBan.m_WEntry[username].restTime)
	end
	outputChatBox("---------- Failure Information ----------")
end

-- initialize ban handler
gBan.initialize()