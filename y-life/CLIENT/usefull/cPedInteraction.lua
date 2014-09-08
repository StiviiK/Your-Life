-- usefull/client/cPedInteraction.lua

-- #######################################
-- ## Project: MTA Your-Life     	    ##
-- ## Name: cPedInteraction.lua         ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

function RenderBindKeyBackGround ()
	--[[
	sWidth, sHeight = guiGetScreenSize()
	deineAuflosung_x = 1600
	deineAuflosung_y = 900
	px = sWidth/deineAuflosung_x
	py = sHeight/deineAuflosung_y
	--]]
	
	local x,y = getScreenFromWorldPosition( dposx, dposy, dposz + 1)
	if x ~= false and y ~= false then
		--dxDrawRectangle(1242*px, 268*py, 278*px, 57*py, tocolor(0, 0, 0, 196), false)
		--dxDrawText("Drücke "..dxkey.." um zu Interagieren!", 1241*px, 268*py, 1520*px, 325*py, tocolor(255, 255, 255, 255), 0.55, "bankgothic", "center", "center", false, false, false, false, false)
		dxDrawText("Drücke "..dxkey.." um zu Interagieren!", x, y, x, y, tocolor(255, 255, 255, 255), 0.8*py, "bankgothic", "center", "center", false, false, false, false, false)
	end -- 0.55
end
InfoBoxPed = {
    label = {}
}

function addBindKeyText (key, posx, posy, posz)
	dxkey = key
	dposx = posx
	dposy = posy
	dposz = posz
	--[[
	sWidth, sHeight = guiGetScreenSize()
	deineAuflosung_x = 1600
	deineAuflosung_y = 900
	px = sWidth/deineAuflosung_x
	py = sHeight/deineAuflosung_y

	InfoBoxPed.label[2] = guiCreateLabel(1258*px, 275*py, 234*px, 55*py, "Drücke "..key.." um zu interagieren!", true)
	--InfoBoxPed.label[2] = guiCreateLabel(0.79*px, 0.31*py, 0.14*px, 0.05*py, "Drücke "..key.." um zu interagieren!", true)
	guiLabelSetHorizontalAlign(InfoBoxPed.label[2], "center", true)
    guiLabelSetVerticalAlign(InfoBoxPed.label[2], "center")
	--]]
	playSoundFrontEnd (42)
	addEventHandler("onClientRender", root, RenderBindKeyBackGround)
end
addEvent("addBindKeyText", true)
addEventHandler("addBindKeyText", root, addBindKeyText)

function removeBindKeyText ()
	--destroyElement(InfoBoxPed.label[2])
	--playSoundFrontEnd (42)
	removeEventHandler("onClientRender", root, RenderBindKeyBackGround)
end
addEvent("removeBindKeyText", true)
addEventHandler("removeBindKeyText", root, removeBindKeyText)