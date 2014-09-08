-- #######################################
-- ## Project: MTA Your-Life		    ##
-- ## Name: TabletApps.lua			   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- App Position's
HomeElements = {
	[1] = { -- Site
		[1] = { -- Row
			--1039, 510, 56, 51
			[1] = {1050, 510, 52, 50},
			[2] = {1151, 510, 52, 50},
			[3] = {1252, 510, 52, 50},
			[4] = {1353, 510, 52, 50},
			[5] = {1454, 510, 52, 50}
		},
		[2] = {
			[1] = {1050, 605, 52, 50},
			[2] = {1151, 605, 52, 50},
			[3] = {1252, 605, 52, 50},
			[4] = {1353, 605, 52, 50},
			[5] = {1454, 605, 52, 50}
		},
		[3] = {
			[1] = {1050, 700, 52, 50},
			[2] = {1151, 700, 52, 50},
			[3] = {1252, 700, 52, 50},
			[4] = {1353, 700, 52, 50},
			[5] = {1454, 700, 52, 50}
		},
		[4] = {
			[1] = {1050, 795, 52, 50},
			[2] = {1151, 795, 52, 50},
			[3] = {1252, 795, 52, 50},
			[4] = {1353, 795, 52, 50},
			[5] = {1454, 795, 52, 50}
		}
	}
}

-- Error 404
function AppError404Render ()
	dxDrawText("\n\nOh, no!\nWhat did you do?\n\n\n\nERROR 404 - App not found\n\n\"I think an Error occurred.\"\n  (Unlimited, 16.06.2014)", (1024+(507/2))*px, (496+(374/2))*py, (1024+(507/2))*px, (496+(374/2))*py, tocolor(255, 255, 255, 255), 1*px, "bankgothic", "center", "center", false, false, false)
end

-- Error 403
function AppError403Render ()
	dxDrawText("ERROR 403 - Access denied", (1024+(507/2))*px, (496+(374/2))*py, (1024+(507/2))*px, (496+(374/2))*py, tocolor(255, 255, 255, 255), 1*px, "bankgothic", "center", "center", false, false, false)
end

-- Homescreen
local HiddenApp = {
	[1] = true,
	[2] = true,
	[3] = true,
	[6] = true,
	[8] = true
}

function AppHomeScreenCreate ()
	local counter = 0
	local row = 1
	
	for app, _ in ipairs(TabletClass["apps"]) do
		if HiddenApp[app] then
		else
			counter = counter + 1	
			
			if counter > 5 then
				counter = 1
				row = row + 1
			end
			
			if (row > 4) then
			else
				TabletClass["button"][app] = {}
				TabletClass["button"][app].button = dxCreateButton(HomeElements[1][row][counter][1]*px, HomeElements[1][row][counter][2]*py, HomeElements[1][row][counter][3]*px, HomeElements[1][row][counter][4]*py, TabletClass["apps"][app][1], 0.5*px, "bankgothic", 255, 255, 255, 255, false, function () TabletClassSetApp(app) end, true, true, TabletClass["apps"][app][5])
			end
		end
	end
end

function AppHomeScreenDestroy ()
	for app, _ in pairs(TabletClass["button"]) do
		if (app == 1) then
		else
			dxRemoveButton(TabletClass["button"][app].button)
			TabletClass["button"][app] = nil
		end
	end
end

-- Informations
function AppInformationRender ()

end

function AppInformationCreate ()

end

function AppInformationDestroy ()

end

-- Settings
Backgrounds = {
	{"Berge", "FILES/images/Tablet/backgrounds/Background_1.png"},
	{"Light's", "FILES/images/Tablet/backgrounds/Background_2.png"},
	{"Mario", "FILES/images/Tablet/backgrounds/Background_3.png"},
	{"Hulk", "FILES/images/Tablet/backgrounds/Background_4.png"},
	{"Cosmos", "FILES/images/Tablet/backgrounds/Background_5.png"},
	{"Ocean", "FILES/images/Tablet/backgrounds/Background_6.png"},
}

function AppSettingsRender ()
	-- Not used
end

function AppSettingsCreate ()
		local counter = 0
	local row = 1
	
	for i = 6, 6 do
		counter = counter + 1
		
		if counter > 5 then
			counter = 1
			row = row + 1
		end
		
		TabletClass["button"]["SETTINGS"..i] = {}
		TabletClass["button"]["SETTINGS"..i].button = dxCreateButton(HomeElements[1][row][counter][1]*px, HomeElements[1][row][counter][2]*py, HomeElements[1][row][counter][3]*px, HomeElements[1][row][counter][4]*py, TabletClass["apps"][i][1], 0.5*px, "bankgothic", 255, 255, 255, 255, false, function () TabletClassSetApp(i) end, true, true, TabletClass["apps"][i][5])
	end
end

function AppSettingsDestroy ()
	for i = 6, 6 do
		dxRemoveButton(TabletClass["button"]["SETTINGS"..i].button)
	end
end

	-- Background Settings
	function AppSettingsBackgroundRender ()
	
	end
	
	function AppSettingsBackgroundCreate ()
	
	end
	
	function AppSettingsBackgroundDestroy ()
	
	end

-- Admin
function AppAdministrationRender ()
	-- Not used
end

function AppAdministrationCreate ()
	if getElementData(getLocalPlayer(), "player.adminlvl") > 0 then
		local counter = 0
		local row = 1
		
		for i = 8, 8 do
			counter = counter + 1
			
			if counter > 5 then
				counter = 1
				row = row + 1
			end
			
			TabletClass["button"]["ADMIN"..i] = {}
			TabletClass["button"]["ADMIN"..i].button = dxCreateButton(HomeElements[1][row][counter][1]*px, HomeElements[1][row][counter][2]*py, HomeElements[1][row][counter][3]*px, HomeElements[1][row][counter][4]*py, TabletClass["apps"][i][1], 0.5*px, "bankgothic", 255, 255, 255, 255, false, function () TabletClassSetApp(i) end, true, true, TabletClass["apps"][i][5])
		end
	else
		TabletClassSetApp(3)
	end
end

function AppAdministrationDestroy ()
	for i = 8, 8 do
		if TabletClass["button"]["ADMIN"..i] then
			dxRemoveButton(TabletClass["button"]["ADMIN"..i].button)
		end
	end
end

-- Music Streaming
local INI
local StreamLinks = {
	{"http://dsl.tb-stream.net:80", "Technobase"},
	{"http://listen.housetime.fm/dsl.pls", "HouseTime.fm"},
	{"http://listen.hardbase.fm/dsl.pls", "HardBase"},
	{"http://listen.trancebase.fm/dsl.pls", "TranceBase"},
	{"http://listen.clubtime.fm/dsl.pls", "ClubTime"},
	{"http://listen.coretime.fm/dsl.pls", "CoreTime"},
	--{"http://92.48.118.17:9450/listen.pls", "Rock"},
	{"http://stream.blackbeats.fm:80", "BlackBeats"},
	{"http://metafiles.gl-systemhaus.de/hr/youfm_2.m3u", "youFM"},
	{"http://www.dubstep.fm/256.asx", "Dubstep"}
}

if (not fileExists("FILES/settings/treams.ini")) then
	INI = EasyIni:newFile("FILES/settings/streams.ini")

	for stream, _ in ipairs(StreamLinks) do
		outputChatBox(StreamLinks[stream][2])
		INI:set("Streamlinks", tostring(StreamLinks[stream][2]), tostring(StreamLinks[stream][1]))
	end
	
	INI:save()
end

StreamLinks = {}
for stream, link in pairs(EasyIni:loadFile("FILES/settings/streams.ini").data["Streamlinks"]) do
	table.insert(StreamLinks, {link, stream})
end
	
function saveMusicStreamLinks ()
	if (fileExists("FILES/settings/streams.ini")) then
		INI = EasyIni:loadFile("FILES/settings/streams.ini")
		
		for stream, _ in ipairs(StreamLinks) do
			INI:set("Streamlinks", tostring(StreamLinks[stream][2]), tostring(StreamLinks[stream][1]))
		end
		
		INI:save()
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), saveMusicStreamLinks)

local sound
local started
local curStream = ""
function AppStreamRender ()
end

function AppStreamCreate ()
end

function AppStreamDestroy ()
	removeEventHandler("onClientRender", root, AppStreamRender)
	
	--stopSound(sound)
end

-- Unlimited
function AppUnlimitedRender ()
	dxDrawText("Hey du!\nDas ist Unlimited seine\nnutzlose App!\n\n\n\n\n\n\n\nFuck du hast das Tablet\nruntergeworfen!", (1024+(506/2))*px, (496+(374/2))*py, (1024+(506/2))*px, (496+(374/2))*py, tocolor(255, 255, 255, 255), 1*px, "bankgothic", "center", "center", false, false, false) 
end

function AppUnlimitedCreate ()
	addEventHandler("onClientRender", root, AppUnlimitedRender) 
	TabletClass["settings"].isbroken = true
end

function AppUnlimitedDestroy ()
	removeEventHandler("onClientRender", root, AppUnlimitedRender)
end