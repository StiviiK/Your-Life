-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: allround.lua			   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Count Members in all Factions (Resource Start)
function getFactionMembers ()
	for ID, _ in pairs(validFactionID) do
		local query = dbQuery(mySQLData.handler, "SELECT * FROM `userdata` WHERE `faction` = '"..tonumber(ID).."'")
		local result = dbPoll(query, -1)
		for i, row in pairs(result) do
			if (not factionMembers[ID]) then
				factionMembers[ID] = {}
			end
			
			if (not factionMembers[ID][row["username"]]) then
				factionMembers[ID][row["username"]] = {
                    rank = row["factionrank"]
                }
			end
		end
	end
end
getFactionMembers()

-- Admin Command: /makeleader
function fmakeLeader_func (player, cmd, target, faction)
	if target ~= nil and getPlayerFromName(target) and isElement(player) and tonumber(faction) ~= nil then
		if getElementData(getPlayerFromName(target), "loggedin") == true then
			if hasPermission(player, "makeleader") then
					target = getPlayerFromName(target)
					faction = tonumber(faction)
				if validFactionID[faction] then
					if faction == 0 then
						if getElementData(target, "player.faction") > 0 then
							removePlayerFromTable(onlineFactionMembers[getElementData(player, "player.faction")], target)
							local tempfaction = getElementData(target, "player.faction")
							setElementData(target, "player.faction", faction, true)
							setElementData(target, "rank", tonumber(-1), true)
							
							infoBox(target, "makeleaderInfo1", "Du wurdest von Admin "..getPlayerName(player).."\nzum Zivilisten gemacht!", 3000)
							sendFactionMSG(tempfaction, getPlayerName(target).." wurde von dem Admin "..getPlayerName(player).." aus der Fraktion entfernt!", 0, 125, 0)
							sendAdminMSG(getPlayerName(player).." hat "..getPlayerName(target).." zum Zivilisten gemacht!")
							
							tempfaction = nil
							return true;
						else
							infoBox(player, "makeleaderError5", "Der Spieler ist in keiner Fraktion!", 3000)
							return false;
						end
					else
						if getElementData(target, "player.faction") == 0 then
							infoBox(target, "makeleaderInfo2", "Du wurdest von Admin "..getPlayerName(player).."\nzum "..factionNames[faction].." Leader gemacht!", 3000)
							sendFactionMSG(faction, getPlayerName(target).." wurde von dem Admin "..getPlayerName(player).." zu dem Leader der Fraktion gemacht!", 0, 125, 0)
							sendAdminMSG(getPlayerName(player).." hat "..getPlayerName(target).." zum Leader der Fraktion "..factionNames[faction].." gemacht!")
						
							table.insert(onlineFactionMembers[faction], target)
							setElementData(target, "player.faction", faction, true)
							setElementData(target, "rank", 0, true)

							return true;
						else
							infoBox(player, "makeleaderError4", "Der Spieler ist bereits in einer Fraktion!", 3000)
							return false;
						end
					end
				else
					infoBox(player, "makeleaderError3", "Du hast eine ungültige Fraktion's ID eingeben!", 3000)
					return false;
				end
			else
				infoBox(player, "makeleaderError2", "Dein Adminlevel ist zu niedrig!", 3000)
				return false;
			end
		else
			infoBox(player, "makeleaderError2", "Der Spieler ist nicht eingeloggt!", 3000)
		end
	else
		infoBox(player, "makeleaderError1", "Syntax:\n/makeleader <Spieler> <Fraktion>", 3000)
		return false;
	end
end
addCommandHandler("makeleader", fmakeLeader_func)

-- Leader Command: /invite
function fInvite_func (player, cmd, target)
	if isElement(player) and target ~= nil and getPlayerFromName(target) then
		if getElementData(getPlayerFromName(target), "loggedin") then
			if getElementData(player, "player.faction") > 0 then
				if getElementData(player, "rank") == 0 then
					target = getPlayerFromName(target)
				
					if player == target then
						infoBox(player, "InviteError5", "Du kannst dich nicht selbst inviten!", 3000)
						return false;
					end
				
					if getElementData(target, "player.faction") == 0 then
						sendFactionMSG(getElementData(player, "player.faction"), getPlayerName(target).." wurde von "..getPlayerName(player).." in die Fraktion aufgenommen!", 0, 125, 0)
						infoBox(target, "InviteInfo1", "Du wurdest von "..getPlayerName(player).." in die Fraktion\n"..factionNames[getElementData(player, "player.faction")].." aufgenommen!\nSchreibe mit /t <Nachricht>", 3000)
						
						setElementData(target, "player.faction", getElementData(player, "player.faction"), true)
						setElementData(target, "rank", 1, true)
						table.insert(onlineFactionMembers[getElementData(target, "player.faction")], target)
						
					else
						infoBox(player, "InviteError5", "Der Spieler ist bereits in einer Fraktion", 3000)
					end
				else
					infoBox(player, "InviteError4", "Dazu bist du nicht befugt!", 3000)
				end
			else
				infoBox(player, "InviteError3", "Du bist in keiner Fraktion!", 3000)
			end
		else
			infoBox(player, "InviteError2", "Der Spieler ist nicht eingeloggt!", 3000)
		end
	else
		infoBox(player, "InviteError1", "Syntax:\n/invite <Spieler>", 3000)
	end
end
addCommandHandler("invite", fInvite_func)

-- Leader Command: /uninvite
function fUninvite_func (player, cmd, target)
	if isElement(player) and target ~= nil and getPlayerFromName(target) then
		if getElementData(getPlayerFromName(target), "loggedin") then
			if getElementData(player, "player.faction") > 0 then
				if getElementData(player, "rank") == 0 then
					target = getPlayerFromName(target)
				
					--if player == target then
					--	infoBox(player, "InviteError5", "Du kannst dich nicht selbst uninviten!\nNutze /leavefaction", 3000)
					--	return false;
					--end
				
					if getElementData(target, "player.faction") == getElementData(player, "player.faction") then
						if (getElementData(target, "rank") ~= 0) then
							removePlayerFromTable(onlineFactionMembers[getElementData(target, "player.faction")], target)
							setElementData(target, "player.faction", 0, true)
							setElementData(target, "rank", -1, true)
							
							infoBox(target, "UnInviteInfo1", "Du wurdest von "..getPlayerName(player).." aus der\nFraktion geworfen!", 3000)
							infoBox(player, "UnInviteInfo2", "Du hast "..getPlayerName(target).." erfolgreich aus der\nFraktion entfernt!", 3000)
							
						else
							infoBox(player, "UnInviteError6", "Du kannst keine Leader aus\nder Fraktion entfernen!", 3000)
						end
					else
						infoBox(player, "UnInviteError5", "Der Spieler ist nicht mit dir ein einer Fraktion!", 3000)
					end
				else
					infoBox(player, "UnInviteError4", "Dazu bist du nicht befugt!", 3000)
				end
			else
				infoBox(player, "UnInviteError3", "Du bist in keiner Fraktion!", 3000)
			end
		else
			infoBox(player, "UnInviteError2", "Der Spieler ist nicht eingeloggt!", 3000)
		end
	else
		infoBox(player, "UnInviteError1", "Syntax:\n/uninvite <Spieler>", 3000)
	end
end
addCommandHandler("uninvite", fUninvite_func)

function fgiveRank (player, cmd, target, rank) -- Leader Command
	if (client) then 
		if (client ~= source) then
			return false;
		end
	end

	if isElement(player) and target ~= nil and rank ~= nil then
		if (not isElement(target)) then
			target = getPlayerFromName(target)
		end
		
		if (player ~= target) then
			if getElementData(player, "player.faction") > 0 then
				if getElementData(player, "rank") == 0 then
					if getElementData(target, "player.faction") > 0 then
						if getElementData(target, "player.faction") == getElementData(player, "player.faction") then
							if (getElementData(target, "rank") ~= 0) then
								rank = tonumber(rank)
								if (rank ~= 0) then
									if (rank <= #factionRanks[getElementData(target, "player.faction")]) and (rank > 0) then
										if (rank ~= getElementData(target, "rank")) then
											if rank > getElementData(target, "rank") and getElementData(target, "rank") ~= 0 then
												infoBox(target, "giveRankInfo1", "Du wurdest von "..getPlayerName(player).." zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") befördert!", 3000)
												infoBox(player, "giveRankInfo2", "Du hast "..getPlayerName(target).." erfolgreich zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") befördert!", 3000)
											else
												infoBox(target, "giveRankInfo1", "Du wurdest von "..getPlayerName(player).." zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") degradiert!", 3000)
												infoBox(player, "giveRankInfo2", "Du hast "..getPlayerName(target).." erfolgreich zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") degradiert!", 3000)
											end
												
											setElementData(target, "rank", rank, true)
										else
											infoBox(player, "giveRankError10", "Der Spieler hat bereits diesen Rang!", 3000)
										end
									else
										infoBox(player, "giveRankError9", "Du hast einen ungültigen Rang eingeben!", 3000)
									end
								else
									infoBox(player, "giveRankError8", "Du kannst keine Leader ernennen!", 3000)
								end
							else
								infoBox(player, "giveRankError7", "Du kannst keinen Leader defördern/degradieren!", 3000)
							end
						else
							infoBox(player, "giveRankError6", "Der Spieler ist nicht mit dir in einer Fraktion!", 3000)
						end
					else
						infoBox(player, "giveRankError5", "Der Spieler ist in keiner Fraktion!", 3000)
					end
				else
					infoBox(player, "giveRankError4", "Dazu bist du nicht berechtigt!", 3000)
				end
			else
				infoBox(player, "giveRankError3", "Du bist in keiner Fraktion!", 3000)
			end
		else
			infoBox(player, "giveRankError2", "Du kannst nicht deinen\neigenen Rang ändern!", 3000)
		end
	else
		infoBox(player, "giveRankError1", "Synatax:\n/giveRank <Spieler> <Rang>", 3000)
	end
end
addCommandHandler("giveRank", fgiveRank)
addEvent("s_giveRank", true)
addEventHandler("s_giveRank", root, fgiveRank)

function fsetRank (player, cmd, target, rank) -- Admin Command
	if isElement(player) and target ~= nil and rank ~= nil then
		target = getPlayerFromName(target)
		
		if hasPermission(player, "setrank") then
			if getElementData(target, "player.faction") > 0 then
				rank = tonumber(rank)
				if (rank <= #factionRanks[getElementData(target, "player.faction")]) and (rank > 0) or (rank == 0) then
					if (rank ~= getElementData(target, "rank")) then
						if (rank ~= 0) then
							if rank > getElementData(target, "rank") and getElementData(target, "rank") ~= 0 then
								infoBox(target, "giveRankInfo1", "Du wurdest von Admin "..getPlayerName(player).." zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") befördert!", 3000)
								infoBox(player, "giveRankInfo2", "Du hast "..getPlayerName(target).." erfolgreich zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") befördert!", 3000)
							else
								infoBox(target, "giveRankInfo3", "Du wurdest von Admin "..getPlayerName(player).." zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") degradiert!", 3000)
								infoBox(player, "giveRankInfo4", "Du hast "..getPlayerName(target).." erfolgreich zum\n"..factionRanks[getElementData(target, "player.faction")][rank].." ("..rank..") degradiert!", 3000)
							end
						else
							infoBox(target, "giveRankInfo5", "Du wurdest von Admin "..getPlayerName(player).." zum\nLeader der Fraktion befördert!", 3000)
							infoBox(player, "giveRankInfo6", "Du hast "..getPlayerName(target).." erfolgreich zum\nLeader der Fraktion befördert!", 3000)
							sendFactionMSG(getElementData(target, "player.faction"), getPlayerName(target).." wurde von Admin "..getPlayerName(player).." zum Leader der Fraktion befördert!", 125, 0, 0)
							sendAdminMSG(getPlayerName(player).." hat "..getPlayerName(target).." zum Leader der Fraktion "..factionNames[getElementData(target, "player.faction")].." befördert!")
						end			
							
						setElementData(target, "rank", rank, true)
						
					else
						infoBox(player, "giveRankError12", "Der Spieler hat bereits diesen Rang!", 3000)
					end
				else
					infoBox(player, "giveRankError11", "Du hast einen ungültigen Rang eingeben!", 3000)
				end
			else
				infoBox(player, "giveRankError5", "Der Spieler ist in keiner Fraktion!", 3000)
			end
		else
			infoBox(player, "giveRankError2", "Dazu bist du nicht berechtigt!", 3000)
		end
	else
		infoBox(player, "giveRankError1", "Synatax:\n/giveRank <Spieler> <Rang>", 3000)
	end
end
addCommandHandler("setRank", fsetRank)

-- Leave Faction Command
function fleaveFaction_func (player)
	if getElementData(player, "rank") == 0 then
		if isElement(player) then
			if getElementData(player, "player.faction") > 0 then
				removePlayerFromTable(onlineFactionMembers[getElementData(player, "player.faction")], player)
				setElementData(player, "player.faction", 0, true)
				setElementData(player, "rank", -1, true)
				
				infoBox(player, "leaveFactionInfo1", "Du hast die Fraktion erfolgreich verlassen!", 3000)
			else
				infoBox(player, "leaveFactionError1", "Du bist in keiner Fraktion!", 3000)
			end
		end
	else
		outputChatBox("This function is disabled!", player)
	end
end
--addCommandHandler("leaveFaction", fleaveFaction_func, false, false)

-- Faction MSG
function sendFactionMSG (faction, message, c1, c2, c3)
	if (faction ~= nil) and (message ~= nil) then
		if (type(faction) == "number") and (type(message) == "string") then
			if validFactionID[faction] then
				if (c1 == nil) and (c2 == nil) and (c3 == nil) then
					local c1, c2, c3 = 0, 255, 128
				end
				
				for _, player in pairs(onlineFactionMembers[faction]) do
					chatboxMessage(player, player, "[[ "..message.." ]]", "custom", 255, 128, 0)
				end
					
				triggerEvent("onFactionCustomChat", root, tonumber(faction), root, tostring(message), "fmsg") -- Chatlog
			else
				return false;
			end
		else
			return false;
		end
	else
		return false;
	end
end

-- Faction Chat
function ftChat (player, cmd, ...)
	local messagetable = {...}
	local message = table.concat(messagetable, " ")
	
	if getElementData(player, "loggedin") then
		if getElementData(player, "player.faction") > 0 then
			local faction = getElementData(player, "player.faction")
			local rank = getElementData(player, "rank")
		
			for _, element in pairs(onlineFactionMembers[faction]) do				
				chatboxMessage(element, element, "[ "..factionRanks[faction][rank].." "..getPlayerName(player)..": "..message.." ]", "custom", factionColors[faction].r, factionColors[faction].g, factionColors[faction].b)
				--outputChatBox("[ "..factionRanks[faction][rank].." "..getPlayerName(player)..": "..message.." ]", element, factionColors[faction].r, factionColors[faction].g, factionColors[faction].b)
			end
			
			--[[for _, element in pairs(AdminsIngame) do
				outputConsole("[("..factionNames[faction]..") "..factionRanks[faction][rank].." "..getPlayerName(element)..": "..message.."]", element)
			end]]
			
			triggerEvent("onFactionCustomChat", player, tonumber(faction), player, tostring(message)) -- Chatlog
		else
			infoBox(player, "ftChatError1", "Du bist in keiner Fraktion!", 3000)
		end
	end
end
addCommandHandler("t", ftChat)
addCommandHandler("Fraktion", ftChat)

-- /s Chat (Squad)

--[[
-- /g Chat
function fgChat (player, cmd, ...)
	local messagetable = {...}
	local message = table.concat(messagetable, " ")
	
	if getElementData(player, "loggedin") then
		if getElementData(player, "player.faction") > 0 then
			if StateFactions[getElementData(player, "player.faction")] then
				local faction = getElementData(player, "player.faction")
				local rank = getElementData(player, "rank")

				for id, _ in pairs(StateFactions) do
					for _, element in pairs(onlineFactionMembers[id]) do
						chatboxMessage(element, element, "[("..factionNames[faction]..") "..factionRanks[faction][rank].." "..getPlayerName(player)..": "..message.."]", "custom", 125, 0, 0)
						--outputChatBox("[ "..factionNames[faction].." "..factionRanks[faction][rank].." "..getPlayerName(player)..": "..message.." ]", element, 125, 0, 0)
					end
				end
			else
				infoBox(player, "fgChatError2", "Du bist in einer ungültigen Fraktion!", 3000)
			end
		else
			infoBox(player, "fgChatError1", "Du bist in keiner Fraktion!", 3000)
		end
	end
end
addCommandHandler("g", fgChat)
--]]

function createFactionVehicle (faction, rank, model, x, y, z, rx, ry, rz, c1, c2, c3, damage, carnumber, fuel, numberplate, dbVehicle)
	if type(faction) == "number" and type(rank) == "number" and type(model) == "number" and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(rx) == "number" and type(ry) == "number" and type(rz) == "number" and type(c1) == "number" and type(c2) == "number" and type(c3) == "number" and type(damage) == "number" and type(carnumber) == "number" and type(fuel) == "number" and type(numberplate) == "string" and type(dbVehicle) == "boolean" then
		if validFactionID[faction] then
			if isValidVehicle(model) then
			
				--if (numberplate == "") then
				--	numberplate = factionNames[faction]
				--end
				
				local veh = createVehicle(model, x, y, z, rx, ry, rz, numberplate)
							setVehicleColor(veh, c1, c2, c3)
							setVehiclePaintjob(veh, 3)
							toggleVehicleRespawn(veh, true)
							setVehicleRespawnDelay(veh, 5000)
						
						--[[if (dbVehicle) then
							table.insert(factionDBVehicles[faction], veh) -- Table for DB Save!
						end]]
					
						table.insert(factionVehicles[faction], veh)
						for _, player in pairs(getElementsByType("player")) do
							if ClientReady[player] then
								triggerClientEvent(player, "sendFactionVehicles", player, factionVehicles)
							end
						end
						
						setElementData(veh, "vehicle.besitzer", factionNames[faction], true)
						setElementData(veh, "vehicle.faction", faction, true)
						setElementData(veh, "vehicle.tank", fuel, true)
						setElementData(veh, "vehicle.damage", damage, true)
						setElementData(veh, "vehicle.autonummer", carnumber, true)
						setElementData(veh, "vehicle.frank", rank, true)
						
						setElementHealth(veh, damage)
						
					addEventHandler("onVehicleExplode", veh, function ()
						setTimer(function (veh) setElementPosition(veh, 0, 0, 0) end, 50, 1, veh)
					end)
				
				if StateFactions[faction] then
					addEventHandler("onVehicleStartEnter", veh, function (player, seat)
						if (seat == 0) then
							if (getElementData(player, "player.faction") ~= getElementData(veh, "vehicle.faction")) then
								cancelEvent()
								infoBox(player, "fVehEnterError1", "Du bist kein Beamter!", 3000)
							else
								if (getElementData(veh, "vehicle.frank") == 0) and (getElementData(player, "rank") == 0) then -- Leader Car
									-- Nothing.
									-- Todo Police Computer
								elseif (getElementData(player, "rank") >= getElementData(veh, "vehicle.frank")) and (getElementData(veh, "vehicle.frank") ~= 0) or (getElementData(player, "rank") == 0) then
									-- Nothing.
									-- Todo Police Computer
								else
									cancelEvent()
									infoBox(player, "fVehEnterError2", "Du darfst dieses Fahrzeug nicht fahren!", 3000)
								end
							end
						end
					end)
					
					-- Work in Progress!
					--[[addEventHandler("onVehicleEnter", veh, function (player)
						--if not isOnDuty(player) then return; end -- Currently not Aviable!
						if isRadioVeh(source) then
							setPoliceRadioChannel(player, getRadioVehChannel(source))
		
							addEventHandler("onVehicleStartExit", source, remPlayerPolice)
							addEventHandler("onVehicleExplode", source, function ()
								remPlayerPolice(player)
							end)
							addEventHandler("onPlayerQuit", player, onDisconnect)
							addEventHandler("onPedWasted", player, remPlayerPoliceOnDeath)
						end
					end)--]]
				elseif EvilFactions[faction] then
					addEventHandler("onVehicleStartEnter", veh, function (player, seat)
						if (seat == 0) then
							if (getElementData(player, "player.faction") ~= getElementData(veh, "vehicle.faction")) then
								cancelEvent()
								infoBox(player, "fVehEnterError1", "Du bist kein Mitglied der "..factionNames[faction].."!", 3000)
							else
								if (getElementData(veh, "vehicle.frank") == 0) and (getElementData(player, "rank") == 0) then -- Leader Car
									-- Nothing.
								elseif (getElementData(player, "rank") >= getElementData(veh, "vehicle.frank")) and (getElementData(veh, "vehicle.frank") ~= 0) or (getElementData(player, "rank") == 0) then
									-- Nothing.
								else
									cancelEvent()
									infoBox(player, "fVehEnterError2", "Du darfst dieses Fahrzeug nicht fahren!", 3000)
								end
							end
						end
					end)
				end
				
			return veh;
			else
				assert(isValidVehicle(model), "Bad Argument @ 'createFactionVehicle' [Expectet valid Model ID, got invalid Model]")
			end
		else
			assert(validFactionID[faction], "Bad Argument @ 'createFactionVehicle' [Expected faction @ Argument 1, got invalid faction]")
		end
	else
		--outputDebugString("Bad Argument @ 'GoogleSpeech' [Expected string @ Argument 1 got "..type(message).."]", 1)
		assert(type(faction) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 1, got "..type(faction).."]")
		assert(type(rank) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 2, got "..type(rank).."]")
		assert(type(model) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 3, got "..type(model).."]")
		assert(type(x) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 4, got "..type(x).."]")
		assert(type(y) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 5, got "..type(y).."]")
		assert(type(z) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 6, got "..type(z).."]")
		assert(type(rx) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 7, got "..type(rx).."]")
		assert(type(ry) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 8, got "..type(ry).."]")
		assert(type(rz) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 9, got "..type(rz).."]")
		assert(type(c1) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 10, got "..type(c1).."]")
		assert(type(c2) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 11, got "..type(c2).."]")
		assert(type(c3) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 12, got "..type(c3).."]")
		assert(type(damage) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 13, got "..type(damage).."]")
		assert(type(carnumber) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 14, got "..type(carnumber).."]")
		assert(type(fuel) == "number", "Bad Argument @ 'createFactionVehicle' [Expected number @ Argument 15, got "..type(fuel).."]")
		assert(type(numberplate) == "string", "Bad Argument @ 'createFactionVehicle' [Expected string @ Argument 16, got "..type(numberplate).."]")
		assert(type(dbVehicle) == "boolean", "Bad Argument @ 'createFactionVehicle' [Expected boolean @ Argument 17, got "..type(dbVehicle).."]")
		
		--return "Invalid Arguments";
	end
end

function SpawnFactionVehicles ()
	local query = dbQuery(mySQLData.handler, "SELECT * FROM `vehicledata_faction`")
	local result = dbPoll(query, -1)
	
	for i, row in pairs(result) do
		if validFactionID[row["faction"]] then
			for _, veh in pairs(factionVehicles[row["faction"]]) do
				if (getElementData(veh, "vehicle.autonummer") == row["carnumber"]) and (getElementData(veh, "vehicle.faction") == row["faction"]) then
					removePlayerFromTable(factionVehicles[row["faction"]], veh)
					destroyElement(veh)
				end
			end
			
			local veh = createFactionVehicle(row["faction"], row["rank"], row["model"], row["spawn_x"], row["spawn_y"], row["spawn_z"], row["rot_x"], row["rot_y"], row["rot_z"], row["color1"], row["color2"], row["color3"], row["damage"], row["carnumber"], row["fuel"], row["numberplate"], true)
		else
			assert(validFactionID[row["faction"]], "Bad Argument @ 'SpawnFactionVehicles' [Expected valid faction, got invalid faction]")
		end
    end

    dbFree(query)
end
SpawnFactionVehicles()

local validfCarData = {
	["spawn_x"] = true,
	["spawn_y"] = true,
	["spawn_z"] = true,
	["rot_x"] = true,
	["rot_y"] = true,
	["rot_z"] = true,
	["rank"] = true
}

function UpdateFactionVehicleData (faction, carnumber, data, value)
	if type(faction) == "number" and type(carnumber) == "number" and type(data) == "string" then
		if validFactionID[faction] then
			if validfCarData[data:lower()] then
                return dbExec(mySQLData.handler, "UPDATE vehicledata_faction SET "..tostring(data).."='"..value.."' WHERE faction='"..faction.."' AND carnumber='"..carnumber.."';");
			else
				return false;
			end
		else
			return false;
		end
	else
		return false;
	end
end
addEvent("s_UpdatefCarData", true)
addEventHandler("s_UpdatefCarData", root, UpdateFactionVehicleData)

function fSkin_func (player)
	if getElementData(player, "player.faction") > 0 then
		if (getElementData(player, "player.currfskin")) then
			if factionSkins[getElementData(player, "player.faction")][getElementData(player, "player.currfskin") + 1] ~= nil then
				setElementModel(player, factionSkins[getElementData(player, "player.faction")][getElementData(player, "player.currfskin") + 1])
				setElementData(player, "player.currfskin", getElementData(player, "player.currfskin") + 1)
			else
				setElementModel(player, factionSkins[getElementData(player, "player.faction")][1])
				setElementData(player, "player.currfskin", 1)
			end
		else
			setElementModel(player, factionSkins[getElementData(player, "player.faction")][1])
			setElementData(player, "player.currfskin", 1)
		end
	else
	end
end
--addCommandHandler("fskin", fSkin_func)

function testcmd (player, cmd, faction, ...)
	--[[
	if hasPermission(player, "o") then
		local message = table.concat({...}, " ")
		sendFactionMSG(tonumber(faction), AdminRanks[getElementData(player, "adminlvl")].." "..getPlayerName(player)..": "..message)
	else
		outputChatBox("ERRROR")
	end
	--]]
	SpawnFactionVehicles()
end
addCommandHandler("ftest", testcmd)

function ftest2 (player)
	local pos = {getElementPosition(player)}
	local rot = {getElementRotation(player)}
	outputChatBox("Exec "..tostring(UpdateFactionVehicleData(1, 1, "spawn_x", pos[1])))
	outputChatBox("Exec "..tostring(UpdateFactionVehicleData(1, 1, "spawn_y", pos[2])))
	outputChatBox("Exec "..tostring(UpdateFactionVehicleData(1, 1, "spawn_z", pos[3])))
	outputChatBox("Exec "..tostring(UpdateFactionVehicleData(1, 1, "rot_x", rot[1])))
	outputChatBox("Exec "..tostring(UpdateFactionVehicleData(1, 1, "rot_y", rot[2])))
	outputChatBox("Exec "..tostring(UpdateFactionVehicleData(1, 1, "rot_z", rot[3])))
end
addCommandHandler("ftest2", ftest2)