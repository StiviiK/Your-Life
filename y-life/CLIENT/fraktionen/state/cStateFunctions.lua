-- #######################################
-- ## Project: 	Your Life			    ##
-- ## Name: 	cStateFunctions.lua   	##
-- ## Author: 	StiviK					##
-- ## Version: 	1.0						##
-- #######################################

-- Tazer
function applyTazerTXD()
	local txd = engineLoadTXD ("FILES/models/tazer/silenced.txd")
		engineImportTXD (txd, 347)
	local ddf = engineLoadDFF("FILES/models/tazer/silenced.dff",347)
		engineReplaceModel(ddf, 347)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), applyTazerTXD)

function onPlayerTazer (pol, tazergun, part, loss)
	if (tazergun == 23) then
		triggerServerEvent("s_TazerPlayer", source, pol, tazergun, part, loss)
		cancelEvent();
	end
end
addEventHandler("onClientPlayerDamage", root, onPlayerTazer)
--addEventHandler("onClientPedDamage", root, onPlayerTazer)

function playTazerSound ()
	local x, y, z = getElementPosition(source)
	if setSoundMaxDistance(playSound3D("sounds/faction/tazer.wav", x, y, z), 15) then
		outputConsole("DEBUG: [Tazer: Der Tazer-Sound wurde erfolgreich abgespielt!; POS: "..x..", "..y..", "..z.."]", getLocalPlayer())
	else
		outputConsole("DEBUG: [Tazer: Es gab ein Problem bei der wiedergabe des Tazer-Sound's!]", getLocalPlayer())
	end
end
addEvent("c_onPlayerTazerd", true)
addEventHandler("c_onPlayerTazerd", root, playTazerSound)