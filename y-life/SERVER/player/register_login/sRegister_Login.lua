-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: sRegister_Login.lua     	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local PlayTimer = {}

function decide_Register_or_login ()
	outputChatBox(getPlayerName(source))
	outputChatBox(getPlayerName(client))
	if source ~= client then return false; end

	local query = dbQuery( mySQLData.handler, "SELECT * FROM userdata WHERE username = '"..getPlayerName(source).."';" )
	local result, num_affected_rows, errms = dbPoll(query,-1)
	
	setElementData(source, "loggedin", false)
	if num_affected_rows > 0 then
		triggerClientEvent(source, "c_login", source, true)
	else
		triggerClientEvent(source, "c_register", source, true)
	end
	
	dbFree(query)
end
addEvent("s_RLStatus", true)
addEventHandler("s_RLStatus", root, decide_Register_or_login)

function genSalt (num)
	local salt = ""
	if tonumber(num) ~= nil then
		local i = 1
		while i <= tonumber(num) do
			i = i + 1
			
			if math.random(1,2) == 1 then
				salt = salt..""..ABCTable[math.random(1, 26)]
			else
				salt = salt..""..NumTable[math.random(1, 10)]
			end
		end
		
		return salt;
	else
		return false;
	end
end

function SaveRegisterData (user, pass, mail, day, month, year)
	local birth = day.."."..month.."."..year
	local usersalt = string.lower(genSalt(5))
    local time = getRealTime()
    local moneylog = "["..time.monthday.."."..(time.month + 1).."."..(time.year + 1900).." - "..time.hour..":"..time.minute.."] Einzahlung: 2000$\\n"
	dbExec( mySQLData.handler, "INSERT INTO userdata (`username`, `password`, `salt`, `health`, `armor`, `adminlvl`, `foodlvl`, `Mail`, `birth`, `spawntype`, `spawn_x`, `spawn_y`, `spawn_z`, `rot`, `interrior`, `dimension`, `skinid`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", getPlayerName(user), md5(pass..usersalt), usersalt, "100", "0", "0", "100", mail, birth, "street", spawnPoints["street"].x, spawnPoints["street"].y, spawnPoints["street"].z, spawnPoints["street"].rot, 0, 0, Skins[math.random(1, #Skins)])
	dbExec( mySQLData.handler, "INSERT INTO userdata_serial (`serial`, `username`) VALUES (?, ?);", md5(getPlayerSerial(user)), getPlayerName(user))
        local query = dbQuery( mySQLData.handler, "SELECT id FROM userdata WHERE `username` = ?", getPlayerName(user))
        local _, _, id = dbPoll(query, -1)
    dbExec( mySQLData.handler, "INSERT INTO userdata_bankaccounts (`id`, `username`, `money`, `log`) VALUES (?, ?, ?, ?);", id, getPlayerName(user), 2000, moneylog)
        dbFree(query)

	usersalt = ""
	pass = ""
	mail = ""
	day = ""
	month = ""
	year = ""
    moneylog = ""
    time = nil
	
	SetLoginData(user)
end
addEvent("s_SaveData", true)
addEventHandler("s_SaveData", root, SaveRegisterData)

local LoginVisible = {}
function check_Login (user, pass)
	if source ~= client then return false; end

	local query = dbQuery(mySQLData.handler, "SELECT * FROM userdata WHERE username = ?;", getPlayerName(user) )
	local result, num_affected_rows, errms = dbPoll(query, -1)
	
	for i, row in pairs (result) do
		--checkpw = row["Password"]
		--currsalt = row["salt"]
		
		local cpass = md5(pass..row["salt"])
		if cpass == row["password"] then
			LoginVisible[user] = true
			SetLoginData(user)
		else
			infoBox(user, "LoginError2", "Dein eingegebenes Passwort\nist falsch!", 3000)
		end
	end
	dbFree(query)
end
addEvent("s_CheckLogin", true)
addEventHandler("s_CheckLogin", root, check_Login)

function SetLoginData (user)
	local query = dbQuery(mySQLData.handler, "SELECT * FROM userdata WHERE username = ?;", getPlayerName(user) )
	local result, num_affected_rows, errms = dbPoll(query, -1)
	
	for i, row in pairs (result) do
		-- Spawn the Player
		if row["jailtime"] <= 0 then
			if row["spawntype"] ~= "street" then
				if row["faction"] > 0 and row["spawntype"] == "faction" then
					spawnPlayer(user, factionSpawns[row["faction"]].x, factionSpawns[row["faction"]].y, factionSpawns[row["faction"]].z, factionSpawns[row["faction"]].rot)
					--setElementFrozen(user, true)
					setElementInterior(user, factionSpawns[row["faction"]].int)
					setElementPosition(user, factionSpawns[row["faction"]].x, factionSpawns[row["faction"]].y, factionSpawns[row["faction"]].z)
					setElementRotation(user, 0, 0, factionSpawns[row["faction"]].rot)
					setElementData(user, "spawntype", row["spawntype"])
				--elseif
				else
					spawnPlayer(user, row["spawn_x"], row["spawn_y"], row["spawn_z"])
					--setElementFrozen(user, true)
					setElementInterior(user, row["interrior"])
					setElementDimension(user, row["dimension"])
					setElementPosition(user, row["spawn_x"], row["spawn_y"], row["spawn_z"])
					setElementData(user, "spawntype", "street")
				end
			else
				spawnPlayer(user, row["spawn_x"], row["spawn_y"], row["spawn_z"])
				--setElementFrozen(user, true)
				setElementInterior(user, row["interrior"])
				setElementDimension(user, row["dimension"])
				setElementPosition(user, row["spawn_x"], row["spawn_y"], row["spawn_z"])
				setElementData(user, "spawntype", "street")
			end
		else
			-- Jail Func
			setElementData(user, "spawntype", "jail")
            outputDebugString("FALSE!")
		end

		setElementModel(user, row["skinid"])
		
		-- Set the Player ElementData's
		setElementData(user, "player.id", row["id"], true)

            -- BANK ACCOUNT (WIP!)
            local query_bank = dbQuery(mySQLData.handler, "SELECT * FROM userdata_bankaccounts WHERE ?? = ? AND ?? = ?;", "id", row["id"], "username", getPlayerName(user))
            local result_bank = dbPoll(query_bank, -1)
            for i, row in pairs(result_bank) do
            end
            dbFree(query_bank)

		setElementData(user, "player.playtime", row["playtime"], true)
		PlayTimer[getPlayerName(user)] = setTimer(PlayTime, 60000, -1, user)
		setElementData(user, "player.jailtime", row["jailtime"], true)
		setElementData(user, "skinid", row["skinid"])
		setElementData(user, "player.faction", row["faction"], true)
			if row["faction"] > 0 then
				table.insert(onlineFactionMembers[row["faction"]], user)
			end
		setElementData(user, "rank", row["factionrank"], true)
		setElementData(user, "player.adminlvl", row["adminlvl"], true)
			if row["adminlvl"] > 0 then
				table.insert(AdminsIngame, user)
			end
		setElementData(user, "spawnpos_x", row["spawn_x"])
		setElementData(user, "spawnpos_y", row["spawn_y"])
		setElementData(user, "spawnpos_z", row["spawn_z"])
		setElementData(user, "spawnrot", row["rot"])
		setElementData(user, "spawnint", row["interrior"])
		setElementData(user, "spawndim", row["dimension"])
		setElementData(user, "mail", row["mail"])
		setElementData(user, "birth", row["birth"])
		setElementData(user, "loggedin", true)
		setElementData(user, "foodlvl", row["foodlvl"])
		setElementData(user, "salt", row["salt"])
		setPedArmor(user, row["armor"])
		
		-- Set the Friend's
		for i, v in pairs(split(row["friends"], '|')) do
			SetFriendState(user, v, true)
		end
		setElementData(user, "friends", row["friends"])
		
		-- Set the SocialState
		setElementData(user, "player.socialstate", row["socialstate"], true)
		
		if row["health"] <= 0 then
			setElementHealth(user, 25)
		else
			setElementHealth(user, row["health"])
		end
		--triggerClientEvent(source, "c_startHungerTimer", source, row["foodlvl"])
		
		-- Destroy the Login
		if LoginVisible[user] then
			triggerClientEvent(user, "c_login", user, false)
		
			-- Call the Spawnhandler
			--if (getElementData(user, "spawntype") == "street") then
				--triggerClientEvent(user, "c_SpawnHandler_NORMAL", user, row["spawn_x"], row["spawn_y"], row["spawn_z"], getElementData(user, "spawntype"), 700, 150)
			--else
				setCameraTarget(user, user)
				triggerClientEvent(user, "c_SpawnHandler_INT", user, getElementData(user, "spawntype"))
			--end
		
			LoginVisible[user] = false
		else
			setCameraTarget(user, user)
			triggerClientEvent(user, "c_SpawnHandler_INT", user, "register")
		end
	end
	
	dbFree(query)
end

-- SAVE DATA
function SavePlayerData_onStop ()
	for i, v in pairs(getElementsByType("player")) do
		if getElementData(v, "loggedin") then
			if isPedInVehicle(v) then
				setElementVelocity(getPedOccupiedVehicle(v), 0, 0, 0)
				removePedFromVehicle(v)
			end
			local health = getElementHealth(v)
			local armor = getPedArmor(v)
			local playtime = tonumber(getElementData(v, "player.playtime"))
			local jailtime = tonumber(getElementData(v, "player.jailtime"))
			local skin = tonumber(getElementData(v, "skinid"))
			local faction = tonumber(getElementData(v, "player.faction"))
			local rank = tonumber(getElementData(v, "rank"))
			local adminlvl = tonumber(getElementData(v, "player.adminlvl"))
			local foodlvl = tonumber(getElementData(v, "foodlvl"))
			local mail = tostring(getElementData(v, "mail"))
			local socialstate = tostring(getElementData(v, "player.socialstate"))
			local friends = tostring(getElementData(v, "friends"))
			local spawntype = tostring(getElementData(v, "spawntype") or "street")
			
			if getElementData(v, "player.faction") > 0 then
				removePlayerFromTable(onlineFactionMembers[getElementData(v, "player.faction")], v)
			end
			if getElementData(v, "player.adminlvl") > 0 then
				removePlayerFromTable(AdminsIngame, v)
            end

            local spawnposx, spawnposy, spawnposz
            local spawnposrot
            local spawnposin
            local spawnposdim
			
			if (spawntype ~= "street") then
			else
				spawnposx, spawnposy, spawnposz = getElementPosition(v)
				_, _, spawnposrot = getElementRotation(v)
				spawnposint = getElementInterior(v)
				spawnposdim = getElementDimension(v)
			end
			
			if getElementData(v, "updatepw") then
				local newpw = getElementData(v, "newpw")
				local salt = getElementData(v, "salt")
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "password", md5(newpw..salt), "username", getPlayerName(v))
				
				newpw = nil
				salt = nil
			end	
			
			-- UPDATE `y-life`.`userdata` SET `password` = '' WHERE `userdata`.`username` = 'StiviK'; (Beispiel Query)
			-- Health
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "health", health, "username", getPlayerName(v))
			-- Armor
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "armor", armor, "username", getPlayerName(v))
			-- Skin
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "skinid", skin, "username", getPlayerName(v))
			-- Faction
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "faction", faction, "username", getPlayerName(v))
			-- Faction Rank
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "factionrank", rank, "username", getPlayerName(v))
			-- AdminLVL
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "adminlvl", adminlvl, "username", getPlayerName(v))
			-- FoodLVL
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "foodlvl", foodlvl, "username", getPlayerName(v))
			-- Playtime
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "playtime", playtime, "username", getPlayerName(v))
			-- Jailtime
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "jailtime", jailtime, "username", getPlayerName(v))
			-- SocialState
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "socialstate", socialstate, "username", getPlayerName(v))	
			-- Friends
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "friends", friends, "username", getPlayerName(v))	
			-- Spawntype
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawntype", spawntype, "username", getPlayerName(v))
			if spawnposx ~= nil and spawnposy ~= nil and spawnposz ~= nil and spawnposrot ~= nil then
				-- Spawnpos_x
					dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawn_x", spawnposx, "username", getPlayerName(v))
				-- Spawnpos_y
					dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawn_y", spawnposy, "username", getPlayerName(v))
				-- Spawnpos_z
					dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawn_z", spawnposz, "username", getPlayerName(v))
				-- Spawnpos_rot
			end
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "rot", spawnposrot, "username", getPlayerName(v))
			-- Spawnpos_int
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "interrior", spawnposint, "username", getPlayerName(v))
			-- Spawnpos_dim
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "dimension", spawnposdim, "username", getPlayerName(v))	
				
			setElementData(v, "loggedin", false)
		end
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), SavePlayerData_onStop)

function SavePlayerData (player, disconnect)
	if getElementData(player, "loggedin") then
		if (disconnect) then
			killTimer(PlayTimer[getPlayerName(player)])
		end
	
		local health_d = getElementHealth(player)
		local armor_d = getPedArmor(player)
		local skin_d = tonumber(getElementData(player, "skinid"))
		local playtime_d = tonumber(getElementData(player, "player.playtime"))
		local jailtime_d = tonumber(getElementData(player, "player.jailtime"))
		local faction_d = tonumber(getElementData(player, "player.faction"))
		local rank_d = tonumber(getElementData(player, "rank"))
		local adminlvl_d = tonumber(getElementData(player, "player.adminlvl"))
		local foodlvl_d = tonumber(getElementData(player, "foodlvl"))
		local socialstate = tostring(getElementData(player, "player.socialstate"))
		local friends = tostring(getElementData(player, "friends"))
		local mail_d = tostring(getElementData(player, "mail"))
		local spawntype_d = tostring(getElementData(player, "spawntype") or "street")
		
		if getElementData(player, "player.faction") > 0 then
			removePlayerFromTable(onlineFactionMembers[getElementData(player, "player.faction")], player)
		end
		if getElementData(player, "player.adminlvl") > 0 then
			removePlayerFromTable(AdminsIngame, player)
        end

        local spawnposx, spawnposy, spawnposz
        local spawnposrot
        local spawnposin
        local spawnposdim
		
		if (spawntype_d ~= "street") then
		else
			spawnposx_d, spawnposy_d, spawnposz_d = getElementPosition(player)
			_, _, spawnposrot_d = getElementRotation(player)
			spawnposint_d = getElementInterior(player)
			spawnposdim_d = getElementDimension(player)
		end
		
		if tostring(getElementData(player, "updatepw")) == "true" then
			local newpw_d = getElementData(player, "newpw")
			local salt_d = getElementData(player, "salt")
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "password", md5(newpw_d..salt_d), "username", getPlayerName(player))
			
			newpw_d = nil
			salt_d = nil
		end	
			
		-- UPDATE `y-life`.`userdata` SET `password` = '' WHERE `userdata`.`username` = 'StiviK'; (Beispiel Query)
		-- Health
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "health", health_d, "username", getPlayerName(player))
		-- Armor
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "armor", armor_d, "username", getPlayerName(player))
		-- Playtime
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "playtime", playtime_d, "username", getPlayerName(player))
		-- Jailtime
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "jailtime", jailtime_d, "username", getPlayerName(player))
		-- Skin
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "skinid", skin_d, "username", getPlayerName(player))
		-- Faction
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "faction", faction_d, "username", getPlayerName(player))
		-- Faction
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "factionrank", rank_d, "username", getPlayerName(player))
		-- AdminLVL
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "adminlvl", adminlvl_d, "username", getPlayerName(player))
		-- FoodLVL
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "foodlvl", foodlvl_d, "username", getPlayerName(player))
		-- SocialState
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "socialstate", socialstate, "username", getPlayerName(player))
		-- Friends
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "friends", friends, "username", getPlayerName(player))			
		-- Spawntype
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawntype", spawntype_d, "username", getPlayerName(player))
		if spawnposx_d ~= nil and spawnposy_d ~= nil and spawnposz_d ~= nil and spawnposrot_d ~= nil then
			-- Spawnpos_x
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawn_x", spawnposx_d, "username", getPlayerName(player))
			-- Spawnpos_y
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawn_y", spawnposy_d, "username", getPlayerName(player))
			-- Spawnpos_z
				dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "spawn_z", spawnposz_d, "username", getPlayerName(player))
			-- Spawnpos_rot
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "rot", spawnposrot_d, "username", getPlayerName(player))
		end
		-- Spawnpos_int
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "interrior", spawnposint_d, "username", getPlayerName(player))
		-- Spawnpos_dim
			dbExec(mySQLData.handler, "UPDATE ?? SET ?? = ? WHERE ?? = ?;", "userdata", "dimension", spawnposdim_d, "username", getPlayerName(player))
	end
end
addEventHandler("onPlayerQuit", root, function ()
	SavePlayerData(source, true)
end)







