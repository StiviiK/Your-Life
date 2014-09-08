-- #######################################
-- ## Project: 	MTA Your-Life		    ##
-- ## Name: 	sPlayerTime.lua		   	##
-- ## Author: 	StiviK					##
-- ## Version: 	1.0						##
-- #######################################	

local PlayingTime = {}
function PlayTime (player)
	if isElement(player) then
		if getElementData(player, "player.playtime") and getElementData(player, "loggedin") and getElementData(player, "afk") == false then
			if (not PlayingTime[player]) then
				PlayingTime[player] = {}
			end
			
			PlayingTime[player].hoursold = math.floor(getElementData(player, "player.playtime") / 60)
			
			setElementData(player, "player.playtime", (getElementData(player, "player.playtime") + 1), true)
			
			PlayingTime[player].comp = getElementData(player, "player.playtime")
			PlayingTime[player].hours = math.floor(getElementData(player, "player.playtime") / 60)
			PlayingTime[player].minutes = (PlayingTime[player].comp - (PlayingTime[player].hours * 60))
			
			if PlayingTime[player].hours - PlayingTime[player].hoursold == 1 then
				SavePlayerData(player, false)
				outputDebugString("Die Daten wurden für den Spieler "..getPlayerName(player).." gespeichert!", 3)
			end
			
			if tonumber(getElementData(player, "player.jailtime")) > 0 then
				setElementData(player, "player.jailtime", (getElementData(player, "player.jailtime") - 1))
				
				if getElementData(player, "player.jailtime") == 0 then
					setElementData(player, "player.jailtime", 0)
					
					outputChatBox(getPlayerName(player).." is out of the jail!")
				end
			end
			
			-- Achievments ?
		end
	end
end