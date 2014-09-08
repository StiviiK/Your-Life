local sx, sy = guiGetScreenSize()
local highscore = 0
local showing = false
local window
local game
local renderFunc = function() highscore = game.bestScore end
--outputChatBox("[2048] Resource started successfully. Type /2048 to start the game!", 255, 255, 0)

function GAME_2048_START ()
	window = DXWindow(sx/2-(319+10)/2, sy/2-(421+30)/2,319+10, 421+30, "2048 (developed by schotobi)", tocolor(255, 136, 0, 150))
	window:setMoveable(true)
	showCursor(true)
	game = Game(window.x + 5,window.y + 25, highscore)
	game:setParent(window)
	addEventHandler("onClientRender", getRootElement(), renderFunc)
end

function GAME_2048_STOP ()
	removeEventHandler("onClientRender", getRootElement(), renderFunc)
	game:destroy()
	window:destroy()
	showCursor(false)
	showing = false
end

addCommandHandler("2048", function ()
	if (showing) then
		GAME_2048_STOP()
		showing = false
	else
		GAME_2048_START()
		showing = true
	end
end)