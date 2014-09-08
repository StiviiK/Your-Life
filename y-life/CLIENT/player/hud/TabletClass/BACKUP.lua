-- #######################################
-- ## Project: //					    ##
-- ## Name: TabletClass.lua			   	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Icon's by www.iconpharm.com

-- TableClass
TabletClass = {
	["apps"] = {
		["home"] = {AppHomeScreenRender, false, AppHomeScreenDestroy, "images/Tablet/apps/home.png"},
		["404"] = {AppErrorRender, true, nil, ""},
		["unlimited"] = {AppUnlimitedCreate, false, AppUnlimitedDestroy, "images/Tablet/apps/unlimited.png"},
		["streaming"] = {AppStreamCreate, false, AppStreamDestroy, "images/Tablet/apps/streaming.png"},
		["settings"] = {AppSettingsCreate, false, AppSettingsDestroy, "images/Tablet/apps/settings.png"},
		["admin"] = {AppAdministrationCreate, false, AppAdministrationDestroy, "images/Tablet/apps/administration.png"},
		["information"] = {nil, false, nil, "images/Tablet/apps/information.png"},
		["changelog"] = {nil, false, nil, "images/Tablet/apps/changelog.png"}
	},
	["settings"] = {
		showKey = "k",
		showKeyState = "down",
		homeApp = "home",
		curApp = "home",
		background = Backgrounds[1][2],
		isbroken = false,
		showing = false
	},
	["functions"] = {
		AppRenderFunc = function () 
			if TabletClass["settings"].showing then
				TabletClass["apps"][TabletClass["settings"].curApp][1]()
			end
		end
	},
	["button"] = {
		["home"] = dxCreateButton(1548*px, 666*py, 34*px, 32*py, "", 0.5*px, "bankgothic", 255, 255, 255, 0, false, function ()
			if (TabletClass["settings"].curApp ~= "home") then
				TabletClassSetApp(TabletClass["settings"].homeApp) 
			end
		end, true, true)
	}
}

function TabletClassSetApp (app)
	if (app ~= nil) then
		if TabletClass["apps"][tostring(app)] ~= nil and TabletClass["apps"][tostring(app)][1] ~= nil then
			if TabletClass["apps"][TabletClass["settings"].curApp][3] ~= nil then
				TabletClass["apps"][TabletClass["settings"].curApp][3]()
			end
			
			TabletClass["settings"].curApp = tostring(app:lower())
			
			if TabletClass["apps"][TabletClass["settings"].curApp][2] then
				removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
				addEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
			else
				removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
				TabletClass["apps"][TabletClass["settings"].curApp][1]()
			end
		else
			if TabletClass["apps"][TabletClass["settings"].curApp][3] ~= nil then
				TabletClass["apps"][TabletClass["settings"].curApp][3]()
			end
			
			TabletClass["settings"].curApp = "404"
			
			removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
			addEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
		end
	end
end

function TabletClassSetShowing ()
	if (not TabletClass["settings"].showing) then
		addEventHandler("onClientRender", root, TabletClassRender)
		
		if TabletClass["apps"][TabletClass["settings"].curApp][2] then
			if (not isEventHandlerAdded("onClientRender", root, TabletClass["functions"].AppRenderFunc)) then
				addEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
			end
		else
			TabletClass["apps"][TabletClass["settings"].curApp][1]()
		end
		
		TabletClass["settings"].showing = true
		showCursor(true)
	else
		removeEventHandler("onClientRender", root, TabletClassRender)
		
		if TabletClass["apps"][TabletClass["settings"].curApp][2] then 
			removeEventHandler("onClientRender", root, TabletClass["functions"].AppRenderFunc)
		else
			TabletClass["apps"][TabletClass["settings"].curApp][3]()
		end
		
		TabletClass["settings"].showing = false
		showCursor(false)
	end
end
bindKey(TabletClass["settings"].showKey, TabletClass["settings"].showKeyState, TabletClassSetShowing)

function TabletClassRender ()
	dxDrawImage(956*px, 468*py, 644*px, 432*py, "images/Tablet/base/Tablet.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(1024*px, 496*py, 507*px, 374*py, TabletClass["settings"].background, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
	if TabletClass["settings"].isbroken then
		dxDrawImage(1024*px, 496*py, 507*px, 374*py, "images/Tablet/base/Glass_Broken.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end
	
	if (TabletClass["settings"].curApp ~= "home") and (TabletClass["settings"].curApp ~= "404") then
		dxDrawRectangle(1024*px, 496*py, 506*px, 11*py, tocolor(32, 32, 32, 229), true)
        dxDrawText(tostring(TabletClass["settings"].curApp), 1024*px, 496*py, 1530*px, 506*py, tocolor(255, 255, 255, 255), 0.40, "bankgothic", "center", "top", false, false, true, false, false)
		
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