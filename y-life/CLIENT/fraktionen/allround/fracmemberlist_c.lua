-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: FraktionsMemberListe	   	##
-- ## Author: Vandam					##
-- ## Version: 1.0						##
-- #######################################

position_fracmemberlist = 1
hoehe_fracmemberlist=17
local lp = getLocalPlayer()
local localPlayerFractionName


function showFrakMemberlist()
	addFrakMemberlist(getElementData(lp, "player.faction"))
	addEventHandler("onClientRender", root, renderFrakMemberlist)
	bindKey("mouse_wheel_down","down",FrakMemberlistScroll)
	bindKey("mouse_wheel_up","down",FrakMemberlistScroll)
end


function closeFrakMemberlist()
	removeEventHandler("onClientRender", root, renderFrakMemberlist)
	unbindKey("mouse_wheel_down","down",FrakMemberlistScroll)
	unbindKey("mouse_wheel_up","down",FrakMemberlistScroll)
end

	bindKey("o","down",showFrakMemberlist)
	bindKey("o","up",closeFrakMemberlist)

function FrakMemberlistScroll(key)
		if key=="mouse_wheel_down" then
			--outputChatBox("Size: "..#fracMemberlistTab)
				--outputChatBox("Position: "..position_fracmemberlist)
			if #fracMemberlistTab - position_fracmemberlist <= hoehe_fracmemberlist then
				if #fracMemberlistTab > hoehe_fracmemberlist then
					outputChatBox("Size: "..#fracMemberlistTab)
					outputChatBox("Position: "..position_fracmemberlist)
					position_fracmemberlist = #fracMemberlistTab-hoehe_fracmemberlist
				else
					position_fracmemberlist=1
				end
			else
				position_fracmemberlist = position_fracmemberlist + 1 
			end
		elseif key=="mouse_wheel_up" then
			if  position_fracmemberlist <= 1 then
				position_fracmemberlist = 1
			else
				position_fracmemberlist = position_fracmemberlist - 1 
			end
		end
	--end
end

function textab (table)
	factionMembers = table
end
addEvent("receivedata", true)
addEventHandler("receivedata", root, textab)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function ()
	triggerServerEvent("s_onClientReady", getLocalPlayer(), root)
end)

function addFrakMemberlist(id)
	localPlayerFractionName=factionNames[id]
	fracMemberlistTab={}
	local frakspielernummer=1
	for index, _ in pairs(factionMembers[id]) do
		fracMemberlistTab[frakspielernummer] = {}
		fracMemberlistTab[frakspielernummer].spielername = index
		fracMemberlistTab[frakspielernummer].rank = factionMembers[id][index].rank
		frakspielernummer=frakspielernummer+1
	end
end

function renderFrakMemberlist()	
	dxDrawRectangle(600*px,220*py,300*px,50*py,tocolor(0,0,0,220), true)
	dxDrawRectangle(600*px,270*py,300*px,380*py,tocolor(0,0,0,150), true)
	dxDrawText(localPlayerFractionName,610*px,220*py,890*px,260*py,tocolor(255,255,255,255),0.8*py,"bankgothic","center", "center", false, false, true, false, false)
	dxDrawText("Spielername",630*px,250*py,750*px,270*py,tocolor(255,255,255,255),0.5*py,"bankgothic","left", "center", false, false, true, false, false)
	dxDrawText("Rang",800*px,250*py,890*px,270*py,tocolor(255,255,255,255),0.5*py,"bankgothic","left", "center", false, false, true, false, false)
	fracmemberlistZeile = 0
	
	for fracmemberlistpos = 0+position_fracmemberlist  , hoehe_fracmemberlist+position_fracmemberlist  do 
		if fracMemberlistTab[fracmemberlistpos] then
			dxDrawText(fracMemberlistTab[fracmemberlistpos].spielername, 610*px, 249*py +(20*fracmemberlistZeile), 300*px, 330*py +(20*fracmemberlistZeile), tocolor(255,255,255,255), 0.5*py, "bankgothic", "left", "center", false, false, true, false, false)
			dxDrawText(fracMemberlistTab[fracmemberlistpos].rank, 830*px, 249*py +(20*fracmemberlistZeile), 300*px, 330*py +(20*fracmemberlistZeile), tocolor(255,255,255,255), 0.5*py, "bankgothic", "left", "center", false, false, true, false, false)
		end
			fracmemberlistZeile=fracmemberlistZeile+1	
	end 	
end