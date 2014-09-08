
--[[
function SetSocialState (player, ...)
	if (...) ~= nil then
		local parametersTable = {...}
		local status = table.concat( parametersTable, " " )
		for i, v in pairs (getElementsByType("player")) do
			triggerClientEvent(v, "c_UpdateSocialData", v, player, status)
		end
	else
		return false;
	end
end
--]]

function SetFriendState (player, name, bool)
	if name ~= nil and bool ~= nil then
		triggerClientEvent(player, "c_UpdateFriendData", player, name, bool)
	else
		return false;
	end
end

addEventHandler("onPlayerSpawn", root, function ()
	setPlayerNametagShowing(source, false)
end)