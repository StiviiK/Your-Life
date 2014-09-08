-- #######################################
-- ## Project: 	MTA Your-Life     		##
-- ## Name: 	Scoreboard			    ##
-- ## Author:	Vandam					##
-- ## Version: 	1.0						##
-- #######################################

spieler={}

local x,y = guiGetScreenSize()
local position_scoreboard = 1
--local pingTimerStatus=false
--local pingtimer

bindKey("tab","down",function()
	addScoreboardPlayerData()
	addEventHandler("onClientRender", root, renderScoreboard)
	bindKey("mouse_wheel_down","down",scoreboardScroll)
	bindKey("mouse_wheel_up","down",scoreboardScroll)
	toggleControl("next_weapon",false)
	toggleControl("previous_weapon",false)
	toggleControl("fire",false)
end)

bindKey("tab","up",function()
	--killTimer(pingtimer)
	--pingTimerStatus = false
	unbindKey("mouse_wheel_down","down",scoreboardScroll)
	unbindKey("mouse_wheel_up","down",scoreboardScroll)
	removeEventHandler("onClientRender", root, renderScoreboard)
	toggleControl("next_weapon",true)
	toggleControl("previous_weapon",true)
	toggleControl("fire",true)
end)

function scoreboardScroll(key)
	if key=="mouse_wheel_down" then
		if #getElementsByType("player") - position_scoreboard <= 17 then
			position_scoreboard = #getElementsByType("player")-17
		else
			position_scoreboard = position_scoreboard + 1 
		end
	elseif key=="mouse_wheel_up" then
		if  position_scoreboard <= 1 then
			position_scoreboard = 1
		else
			position_scoreboard = position_scoreboard - 1 
		end
	end
end

function addScoreboardPlayerData()
	onlinePlayer = {}
	for id, player in pairs(getElementsByType("player")) do 
		onlinePlayer[id] = {}
		onlinePlayer[id].player = player
		onlinePlayer[id].name = getPlayerName(player)
		--onlinePlayer[id].playerping = 0
		onlinePlayer[id].playerping = getPlayerPing(player)

		if not (getElementData(player, "player.socialstate")) then
			onlinePlayer[id].socialstate = "Verbinde..."
			onlinePlayer[id].hours = ""
			onlinePlayer[id].playtime = ""
			onlinePlayer[id].faction = 0
			
		else
			onlinePlayer[id].faction = getElementData(player, "player.faction")
			
		   onlinePlayer[id].socialstate = getElementData(player, "player.socialstate")
		   
			if onlinePlayer[id].socialstate == "" then
				 onlinePlayer[id].socialstate = "-"
			end
			
			onlinePlayer[id].hours = math.floor(getElementData(player, "player.playtime") / 60)
			onlinePlayer[id].minutes = getElementData(player, "player.playtime") - (math.floor(getElementData(player, "player.playtime") / 60) * 60)
		
			if onlinePlayer[id].minutes < 10 then
				onlinePlayer[id].minutes = tonumber(0)..""..getElementData(player, "player.playtime") - (math.floor(getElementData(player, "player.playtime") / 60) * 60)
			end
		
			if onlinePlayer[id].hours < 10 then
				onlinePlayer[id].hours = tonumber(0)..""..math.floor(getElementData(player, "player.playtime") / 60)
			end
		
			onlinePlayer[id].playtime = onlinePlayer[id].hours..":"..onlinePlayer[id].minutes
		end
	end
end

function renderScoreboard()
	dxDrawRectangle(450,250,700,400,tocolor(0,0,0,200),true)
	dxDrawRectangle(450,250,700,20,tocolor(0,0,0,255),true)
	dxDrawText("Spielername",450,250,500,270,tocolor(255,255,255,255),0.5,"bankgothic","left", "center", false, false, true, false, false)
	dxDrawText("Status",670,250,500,270,tocolor(255,255,255,255),0.5,"bankgothic","left", "center", false, false, true, false, false)
	dxDrawText("Spielzeit",800,250,500,270,tocolor(255,255,255,255),0.5,"bankgothic","left", "center", false, false, true, false, false)
	dxDrawText("Ping",1000,250,500,270,tocolor(255,255,255,255),0.5,"bankgothic","left", "center", false, false, true, false, false)
	scoreboardZeile = 0
	for scorepos = 0+position_scoreboard  , 17+position_scoreboard  do 
		if onlinePlayer[scorepos] then
			--addScoreboardPlayerData()
			
			--dxDrawRectangle(1140, 270, 10, 380, tocolor(33, 33, 33, 255), true)
			
			--if (18/#getElementsByType("player")*380) > 380 then
			--	dxDrawRectangle(1140, 270, 10, 380, tocolor(55, 55, 55,255), true)
			--else
			--	dxDrawRectangle(1140, (position_scoreboard*380/#getElementsByType("player")) + 270, 10, 18/#getElementsByType("player")*380, tocolor(0,0,0,255), true)
			--end
			
			dxDrawText(onlinePlayer[scorepos].name, 450* x / 1600, 249 * y / 900 +(20*scoreboardZeile), 546* x / 1600, 330 * y / 900 +(20*scoreboardZeile), tocolor(factionColors[onlinePlayer[scorepos].faction].r, factionColors[onlinePlayer[scorepos].faction].g, factionColors[onlinePlayer[scorepos].faction].b, 255), 0.5, "bankgothic", "left", "center", false, false, true, false, false)
			dxDrawText(onlinePlayer[scorepos].socialstate, 670* x / 1600, 249 * y / 900 +(20*scoreboardZeile), 546* x / 1600, 330 * y / 900 +(20*scoreboardZeile), tocolor(factionColors[onlinePlayer[scorepos].faction].r, factionColors[onlinePlayer[scorepos].faction].g, factionColors[onlinePlayer[scorepos].faction].b, 255), 0.5, "bankgothic", "left", "center", false, false, true, false, false)
			dxDrawText(onlinePlayer[scorepos].playtime, 800* x / 1600, 249 * y / 900 +(20*scoreboardZeile), 546* x / 1600, 330 * y / 900 +(20*scoreboardZeile), tocolor(factionColors[onlinePlayer[scorepos].faction].r, factionColors[onlinePlayer[scorepos].faction].g, factionColors[onlinePlayer[scorepos].faction].b, 255), 0.5, "bankgothic", "left", "center", false, false, true, false, false)
			
			if onlinePlayer[scorepos].playerping < 50 then
				dxDrawText(onlinePlayer[scorepos].playerping, 1000* x / 1600, 249 * y / 900 +(20*scoreboardZeile), 546* x / 1600, 330 * y / 900 +(20*scoreboardZeile), tocolor(0, 125, 0, 255), 0.5, "bankgothic", "left", "center", false, false, true, false, false)
			elseif onlinePlayer[scorepos].playerping < 100 then
				dxDrawText(onlinePlayer[scorepos].playerping, 1000* x / 1600, 249 * y / 900 +(20*scoreboardZeile), 546* x / 1600, 330 * y / 900 +(20*scoreboardZeile), tocolor(255, 229, 9, 255), 0.5, "bankgothic", "left", "center", false, false, true, false, false)
			elseif onlinePlayer[scorepos].playerping >= 100 then
				dxDrawText(onlinePlayer[scorepos].playerping, 1000* x / 1600, 249 * y / 900 +(20*scoreboardZeile), 546* x / 1600, 330 * y / 900 +(20*scoreboardZeile), tocolor(255, 9, 9, 255), 0.5, "bankgothic", "left", "center", false, false, true, false, false)
			end
			
			scoreboardZeile=scoreboardZeile+1	
		end
	end 	
end

function updatePings()
	for i, v in pairs(getElementsByType("player")) do
		outputChatBox(i)
	end
end


-- Maybe?
--[[
	if (18/#getElementsByType("player")*380) > 380 then
		dxDrawRectangle(430, 270, 20, 380, tocolor(0,0,0,255), true)
	else
		dxDrawRectangle(430, (position_scoreboard*380/#getElementsByType("player")) + 270, 20, 18/#getElementsByType("player")*380, tocolor(0,0,0,255), true)
	end
--]]