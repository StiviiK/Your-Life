-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: WatchDog.lua  	            ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

WatchDog = {};
WatchDog.ms_Settings = {
	DisabledWeapons = {
		[38] = true
	},
	MaxHealth 		= 200,
	MaxArmor		= 200, 
	MaxSpeed 		= 30,
	MaxVehicleSpeed = 260,
	MoneySettings	= {
		MaxMoneyIncrease 	= 250000,
		MoneyIncreaseTime	= 10000
	}
}

WatchDog.ms_Functions = {
	--_setPlayerMoney = setPlayerMoney
}

function WatchDog.initialize ()
	-- important tables
	WatchDog.m_Players = {}
	
	-- important functions
	for _, player in ipairs(getElementsByType("player")) do
		WatchDog.m_Players[player] = {
			abuse 			  = 0,
			lastMoneyTick 	  = getTickCount(),
			lastMoneyIncrease = 0,
			lastMoneyAmount   = 0
		}
	end
	
	addEventHandler("onPlayerJoin", root, function ()
		if (WatchDog.m_Players[source] == nil) then
			WatchDog.m_Players[source] = {
				abuse 			  = 0,
				lastMoneyTick	  = getTickCount(),
				latsMoneyIncrease = 0,
				lastMoneyAmount   = 0
			}
		end
	end)
	addEventHandler("onPlayerQuit", root, function ()
		if (WatchDog.m_Players[source] ~= nil) then
			WatchDog.m_Players[source] = nil
			WatchDog.m_Players[source] = nil
		end
	end)
	
	-- watchdog check handler
	addEventHandler("onPlayerSpawn", root, WatchDog.onPlayerSpawn)
	addEventHandler("onPlayerWeaponSwitch", root, WatchDog.onWeaponSwitch)
	
	-- watchdog check functions
	--setPlayerMoney = function (player, amount, ...) WatchDog.setPlayerMoney(player, amount, ...) end
end

function WatchDog.sleep () -- The WatchDog must go sleeping ;)
	-- remove watchdog player table
	WatchDog.m_Players = nil;
	
	-- remove watchdog check handler
	removeEventHandler("onPlayerSpawn", root, WatchDog.onPlayerSpawn)
	removeEventHandler("onPlayerWeaponSwitch", root, WatchDog.onWeaponSwitch)
	
	-- remove watchdog check functions
	--setPlayerMoney = WatchDog.ms_Functions._setPlayerMoney
end

function WatchDog.reportAbuse (player)
	if (WatchDog.m_Players[player] ~= nil) then
		outputChatBox("ABUSE FOUND! "..getPlayerName(player))
	
		if ((WatchDog.m_Players[player].abuse + 1) < 3) then
			WatchDog.m_Players[player].abuse = WatchDog.m_Players[player].abuse + 1
			return true;
		else
			kickPlayer(player, "WatchDog", "Cheating is not allowed!")
			return false;
		end
	end
end

function WatchDog.onPlayerSpawn ()
	if (WatchDog.m_Players[source] ~= nil) then
		if (getPedArmor(source) >= WatchDog.ms_Settings.MaxArmor) then
			WatchDog.reportAbuse(source)
		end
		
		if (getElementHealth(source) >= WatchDog.ms_Settings.MaxHealth) then
			WatchDog.reportAbuse(source)
		end
	end
end

function WatchDog.onWeaponSwitch (previousWeaponID, currentWeaponID)
	if (WatchDog.m_Players[source] ~= nil) then
		if (WatchDog.ms_Settings.DisabledWeapons[currentWeaponID]) then
			WatchDog.reportAbuse(source)
			takeWeapon(source, currentWeaponID)
		end
	end
end

function WatchDog.setPlayerMoney (player, amount, ...)
	if (WatchDog.m_Players[player] ~= nil) then
		WatchDog.m_Players[player].lastMoneyAmount = WatchDog.m_Players[player].lastMoneyAmount + amount
			--outputChatBox("Curr Amount: "..WatchDog.m_Players[player].lastMoneyAmount)
		if (WatchDog.m_Players[player].lastMoneyAmount >= WatchDog.ms_Settings.MoneySettings.MaxMoneyIncrease) then
			--outputChatBox("LastMoneyTick: "..WatchDog.m_Players[player].lastMoneyTick)
			--outputChatBox("Increase Time: "..(getTickCount() - WatchDog.m_Players[player].lastMoneyTick))
			if ((getTickCount() - WatchDog.m_Players[player].lastMoneyTick) <= WatchDog.ms_Settings.MoneySettings.MoneyIncreaseTime) then
				if (WatchDog.reportAbuse(player)) then
					WatchDog.m_Players[player].lastMoneyTick = getTickCount()
					WatchDog.m_Players[player].lastMoneyAmount = 0
				end
			else
				WatchDog.ms_Functions._setPlayerMoney(player, amount, ...)
				WatchDog.m_Players[player].lastMoneyTick = getTickCount()
				WatchDog.m_Players[player].lastMoneyAmount = 0
			end
		end
	end
end 

-- initialize WatchDog
WatchDog.initialize()





function callWebserver_callBack (response)
    if (response ~= "ERROR") and (response ~= nil) then
        outputDebugString("callWebserver response:"..response)
    end
end

function callWebserver (player, cmd, url)
        outputDebugString("Hallo")
    callRemote(url, callWebserver_callback)
end
addCommandHandler("callWebserver", callWebserver_callBack)