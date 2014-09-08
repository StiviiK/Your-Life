-- #######################################
-- ## Project: MTA Your-Life		    ##
-- ## Name: TabletClass.lua			   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Icon's by www.iconpharm.com

-- TableClass
TabletClass = {
	["apps"] = {
		{"home", AppHomeScreenCreate, false, AppHomeScreenDestroy, "FILES/images/Tablet/apps/home.png"},
		{"404", AppError404Render, true, nil, ""},
		{"403", AppError403Render, true, nil, ""},
		{"information", AppInformationCreate, false, AppInformationDestroy, "FILES/images/Tablet/apps/information.png"},
		{"settings", AppSettingsCreate, false, AppSettingsDestroy, "FILES/images/Tablet/apps/settings/settings.png"},
			{"background", AppSettingsBackgroundCreate, false, AppSettingsBackgroundDestroy, "FILES/images/Tablet/apps/settings/background.png"},
		{"admin", AppAdministrationCreate, false, AppAdministrationDestroy, "FILES/images/Tablet/apps/administration/administration.png"},
			{"player ch.", nil, false, nil, "FILES/images/Tablet/apps/administration/player.png"},
		{"streaming", AppStreamCreate, false, AppStreamDestroy, "FILES/images/Tablet/apps/streaming.png"},
		{"unlimited", AppUnlimitedCreate, false, AppUnlimitedDestroy, "FILES/images/Tablet/apps/unlimited.png"},
		{"changelog", nil, false, nil, "FILES/images/Tablet/apps/changelog.png"},
		--{"credits", nil, false, nil, "FILES/images/Tablet/apps/changelog.png"}
	},
	["settings"] = {
		showKey = "k",
		showKeyState = "down",
		autoShowCursor = false,
		homeApp = 1,
		curApp = 1,
		background = Backgrounds[2][2],
		isbroken = false,
		showing = false
	},
	["functions"] = {
		AppRenderFunc = function () 
			if TabletClass["settings"].showing then
				TabletClass["apps"][TabletClass["settings"].curApp][2]()
			end
		end
	},
	["button"] = {
		["home"] = dxCreateButton(1548*px, 666*py, 34*px, 32*py, "", 0.5*px, "bankgothic", 255, 255, 255, 0, false, function ()
			if (TabletClass["settings"].curApp ~= 1) then
				TabletClassSetApp(TabletClass["settings"].homeApp) 
			end
		end, true, true)
	}
}

local INI
function TabletClassLoadData ()
	if (not fileExists("FILES/settings/tablet.ini")) then
		INI = EasyIni:newFile("FILES/settings/tablet.ini")
		
		for s, v in pairs(TabletClass["settings"]) do
			INI:set("Settings", tostring(s), tostring(v))
		end
		
		INI:save()
		
		--[[fileClose(fileCreate("settings/savedfiles/tablet.json"))
		
		local TabletSettings = fileOpen("settings/savedfiles/tablet.json")
		fileWrite(TabletSettings, toJSON(TabletClass["settings"]))
		fileClose(TabletSettings)]]--
	else
		INI = EasyIni:loadFile("FILES/settings/tablet.ini")
		
		for s, _ in pairs(TabletClass["settings"]) do
			if isNumber(INI:get("Settings", tostring(s))) then
				TabletClass["settings"][s] = tonumber(INI:get("Settings", tostring(s)))
			elseif isBoolean(INI:get("Settings", tostring(s))) then
				TabletClass["settings"][s] = toboolean(INI:get("Settings", tostring(s)))
			else
				TabletClass["settings"][s] = tostring(INI:get("Settings", tostring(s)))
			end
		end
	
		--[[local TabletSettings = fileOpen("settings/savedfiles/tablet.json")
		TabletClass["settings"] = fromJSON(fileRead(TabletSettings, fileGetSize(TabletSettings)))
		fileClose(TabletSettings)]]--
	end
end
TabletClassLoadData()

function TabletClassSaveData ()
	if fileExists("FILES/settings/tablet.ini") then
		if TabletClass["settings"].showing then TabletClass["settings"].showing = false end
	
		INI = EasyIni:loadFile("FILES/settings/tablet.ini")
	
		for s, v in pairs(TabletClass["settings"]) do
			if TabletClass["settings"][s] ~= INI:get("Settings", tostring(s)) then
				INI:set("Settings", tostring(s), tostring(v))
			end
		end
		
		INI:save()
		
		--[[if (TabletClass["settings"].showing) then TabletClass["settings"].showing = false end
		
		local TabletSettings = fileOpen("settings/savedfiles/tablet.json")
		fileWrite(TabletSettings, toJSON(TabletClass["settings"]))
		fileClose(TabletSettings)]]--
	else
		TabletClassLoadData()
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), TabletClassSaveData)

function TabletClassSetApp (app)
	if (app ~= nil) then
		if TabletClass["apps"][tonumber(app)] ~= nil and TabletClass["apps"][tonumber(app)][2] ~= nil then
			if TabletClass["apps"][TabletClass["settings"].curApp][4] ~= nil then
				TabletClass["apps"][TabletClass["settings"].curApp][4]()
			end
			
			TabletClass["settings"].curApp = tonumber(app)
			
			if TabletClass["apps"][TabletClass["settings"].curApp][3] then
				removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
				addEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
			else
				removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
				TabletClass["apps"][TabletClass["settings"].curApp][2]()
			end
		else
			if TabletClass["apps"][TabletClass["settings"].curApp][4] ~= nil then
				TabletClass["apps"][TabletClass["settings"].curApp][4]()
			end
			
			TabletClass["settings"].curApp = 2
			
			removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
			addEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
		end
	end
end

function TabletClassSetShowing ()
	if (not TabletClass["settings"].showing) then
		addEventHandler("onClientRender", root, TabletClassRender)
		
		if TabletClass["apps"][TabletClass["settings"].curApp][3] then
			if (not isEventHandlerAdded("onClientRender", root, TabletClass["functions"].AppRenderFunc)) then
				addEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
			end
		else
			TabletClass["apps"][TabletClass["settings"].curApp][2]()
		end
		
		TabletClass["settings"].showing = true
		
		if (TabletClass["settings"].autoShowCursor) then
			showCursor(true)
		end
	else
		removeEventHandler("onClientRender", root, TabletClassRender)
		
		if TabletClass["apps"][TabletClass["settings"].curApp][3] then 
			removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
		else
			TabletClass["apps"][TabletClass["settings"].curApp][4]()
		end
		
		TabletClass["settings"].showing = false
		showCursor(false)
	end
end
bindKey(TabletClass["settings"].showKey, TabletClass["settings"].showKeyState, TabletClassSetShowing)

function TabletClassRender ()
	dxDrawImage(956*px, 468*py, 644*px, 432*py, "FILES/images/Tablet/base/Tablet.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(1024*px, 496*py, 507*px, 374*py, TabletClass["settings"].background, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
	if TabletClass["settings"].isbroken then
		dxDrawImage(1024*px, 496*py, 507*px, 374*py, "FILES/images/Tablet/base/Glass_Broken.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end
	
	if (TabletClass["settings"].curApp ~= 1) and (TabletClass["settings"].curApp ~= 2) and (TabletClass["settings"].curApp ~= 3) then
		dxDrawRectangle(1024*px, 496*py, 506*px, 11*py, tocolor(32, 32, 32, 229), true)
        dxDrawText(TabletClass["apps"][TabletClass["settings"].curApp][1], 1024*px, 496*py, 1530*px, 506*py, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "center", "top", false, false, true, false, false)
		
		local hours, minutes = getTime()
		
			if hours < 10 then
				hours = "0"..hours
			end
		
			if minutes < 10 then
				minutes = "0"..minutes
			end
			
		dxDrawText(hours..":"..minutes, 1024*px, 496*py, 1530*px, 506*py, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "left", "top", false, false, true, false, false)
	end
end

addCommandHandler("ch", function (cmd, arg)
	TabletClass["settings"].background = Backgrounds[tonumber(arg)][2]
end)

bindKey("m", "down", function ()
	showCursor(not isCursorShowing())
end)