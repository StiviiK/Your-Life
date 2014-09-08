-- #######################################
-- ## Project: MTA FlappyBird			##
-- ## Name: Script.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

local flappy		= false;

--[[

]]

addCommandHandler("flappybirds", function()
	if(flappy) then
		flappyBirdGame:Destructor();
		showCursor(false);
	else
		flappyBirdGame	= FlappyBirdGame:New();
	end
		
	flappy = not(flappy)
end)
	-- EVENT HANDLER --
