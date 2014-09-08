-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: admincmds.lua			   	##
-- ## Author: StiviK, Vandam			##
-- ## Version: 1.0						##
-- #######################################

-- Fun Command
function FunTextSpeech (player, cmd, ...)
	local message = table.concat({...}, " ")
	
	triggerClientEvent(root, "speech_c", root, message)
	outputDebugString(getPlayerName(player).." lies folgenden Text vorlesen: '"..message.."'")
end
addCommandHandler("rayban", FunTextSpeech)

-- Tables
AdminsIngame = {}
AdminRanks = {
	[1] = "Administrator",
	[2] = "Administrator",
	[3] = "Administrator"
}

AdminPermission = {
	["o"] = 1,
	["makeleader"] = 1,
	["setrank"] = 1,
	["banplayer"] = 1
}

-- Function's
function hasPermission (player, perm)
	if (isElement(player)) and (type(perm) == "string") then
		if (AdminPermission[perm:lower()] ~= nil) then
			if getElementData(player, "player.adminlvl") >= AdminPermission[perm:lower()] then
				return true;
			else
				return false;
			end
		else
			assert(AdminPermission[perm:lower()], "Bad Argument at 'hasPermission' (Expectet 'ADMINPERMISSION' at Argument 2, got nil)")
		end
	else
		assert(isElement(player), "Bad Argument at 'hasPermission' (Expectet player at Argument 1, got "..type(player)..")")
		assert(type(perm) == "string", "Bad Argument at 'hasPermission' (Expectet string at Argument 2, got "..type(perm)..")")
	end
end

function sendAdminMSG (message)
	if (message ~= nil) then
		if (type(message) == "string") then	
			for _, player in pairs(AdminsIngame) do
				chatboxMessage(player, player, "[[ "..message.." ]]", "custom", 255, 255, 0)
			end
		else
			assert("Bad Argument at 'sendAdminMSG' (Expectet string at Argument 1, got "..type(message)..")")
		end
	else
		assert("Bad Argument at 'sendAdminMSG' (Expectet 'MESSAGE' at Argument 1, got nil)")
	end
end

function oChat_func (player, cmd, ...)
	if isElement(player) then
		if getElementData(player, "loggedin") then
			if hasPermission(player, "o") then
				local message = table.concat({...}, " ")

				for _, element in pairs(getElementsByType("player")) do
					if getElementData(player, "loggedin") then
						chatboxMessage(element, element,"(( "..AdminRanks[getElementData(player, "adminlvl")].." "..getPlayerName(player)..": "..message.." ))" , "custom", 128, 128, 128)
					end
				end
			end
		end
	end
end
addCommandHandler("o", oChat_func)