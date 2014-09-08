-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cRegister_Login.lua     	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local lp = getLocalPlayer()

-- //
-- || Register
-- \\

local RegisterStuff = {}
function onRegister ()
	local time = getRealTime()
	local jahr = time.year + 1900
	local Passwort = dxEditGetText(RegisterStuff.Password)
	local EMail = dxEditGetText(RegisterStuff.Mail)
	local Birth = dxEditGetText(RegisterStuff.Birth)
	local Day = ""
	local Month = ""
	local Year = ""
	if (#split(Birth, ".") == 3) then
		outputChatBox("TRUE")
		Day = split(Birth, ".")[1]
		Month = split(Birth, ".")[2]
		Year = split(Birth, ".")[3]
	end
	
	if Passwort ~= "" and EMail ~= "" and Day ~= "" and Month ~= "" and Year ~= "" then
		--if Passwort == Passwortwdh then
			if string.match(EMail,'^[%w+%.%-_]+@[%w+%.%-_]+%.%a%a+$') == EMail then
				if tonumber(Day) ~= nil then
					if tonumber(Month) ~= nil then
						if tonumber(Year) ~= nil then
							if tonumber(Month) >= 1 and tonumber(Month) <= 12 then
								if tonumber(Day) >= 1 and tonumber(Day) <= 30 then
									--if tonumber(Year) >= 1900 and tonumber(Year) <= 1998 then -- Bessere Abfrage ^^ | (Mindestens 16 Jahre :P)
									if tonumber(Year) >= 1900 and tonumber(Year) <= (jahr - 10) then -- (Mindestens 10 Jahre :P)
										triggerServerEvent("s_SaveData", lp, lp, Passwort, EMail, Day, Month, Year)
										registerPlayer(false)
									else
										showInfoBox ("RegisterError1", "Register:\nDu bist zu jung!\nGeh lieber raus zum Spielen ;)", 3000)
										--showInfoBox ("small", "Error", "Register:\nDu bist zu jung\noder dein Geburtsdatum ist falsch!", 3000)
									end
								else
									showInfoBox ("RegisterError2", "Register:\nBitte gebe ein gültiges Geburtsdatum ein!", 3000)
								end
							else
								showInfoBox ("RegisterError3", "Register:\nBitte gebe ein gültiges Geburtsdatum ein!", 3000)
							end
						else
							showInfoBox ("RegisterError4", "Register:\nBitte gebe ein gültiges Geburtsdatum ein!", 3000)
						end
					else
						showInfoBox ("RegisterError5", "Register:\nBitte gebe ein gültiges Geburtsdatum ein!", 3000)
					end
				else
					showInfoBox ("RegisterError6", "Register:\nBitte gebe ein gültiges Geburtsdatum ein!", 3000)
				end
			else
				showInfoBox ("RegisterError7", "Register:\nDu hast eine ungültige E-Mail eingegeben!", 3000)
			end
		--else
		--	showInfoBox ("RegisterError8", "Register:\nDie Passwörter stimmen nicht über ein!", 3000)
		--end
	else
		showInfoBox ("RegisterError9", "Register:\nBitte fülle alle Felder aus!", 3000)
	end
end

local x, y = guiGetScreenSize()
local screensource = dxCreateScreenSource(x, y)
local _renderBlur = function () renderBlur(screensource, 8, 0, 0, x, y) end

local alphaRegister = {
	[1] = {a = 0, maxa = 250, timer},
	[2] = {a = 0, maxa = 130, timer},
	[3] = {a = 0, maxa = 200, timer},
}

function Register ()
	-- Username Edit
	RegisterStuff.Username = dxCreateEdit(613*px, 362*py, 376*px, 35*py, "", 0.8*py, "bankgothic", 254, 254, 254, 0, false, false)
	
	-- Passwort Edit
	RegisterStuff.Password = dxCreateEdit(613*px, 459*py, 376*px, 35*py, "", 0.8*py, "bankgothic", 254, 254, 254, 0, false, false)
	
	-- Mail Edit
	RegisterStuff.Mail = dxCreateEdit(613*px, 556*py, 376*px, 35*py, "", 0.7*py, "bankgothic", 254, 254, 254, 0, false, false)
	
	-- Birth Edit
	RegisterStuff.Birth = dxCreateEdit(613*px, 653*py, 376*px, 35*py, "", 0.8*py, "bankgothic", 254, 254, 254, 0, false, false)
	
	-- Register Button
	RegisterStuff.Register = dxCreateButton(697*px, 729*py, 206*px, 56*py, "Registrieren", 0.8*py, "bankgothic", 254, 138, 0, 0, false, onRegister, true, true)
end


function dxDrawRegister ()
	dxDrawImage(630*px, 0*py, 312*px, 304*py, "FILES/images/hud/logo.png", 360, 0, 0, tocolor(255, 255, 255, alphaRegister[1].a), false)

	dxDrawText("Username:", 612*px, 327, 989*px, 362*py, tocolor(255, 255, 255, alphaRegister[1].a), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
	dxDrawRectangle(611*px, 360*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 397*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(989*px, 360*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 360*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	
	--dxDrawLine(613*px, 361*py, 989*px, 361*py, tocolor(0, 0, 0, alphaRegister[1].a), 2*px, false)
	--dxDrawLine(613*px, 398*py, 989*px, 398*py, tocolor(0, 0, 0, alphaRegister[1].a), 2*py, false)
	--dxDrawLine(989*px, 360*py, 990*px, 398*py, tocolor(0, 0, 0, alphaRegister[1].a), 2*px, false)
	--dxDrawLine(612*px, 360*py, 612*px, 399*py, tocolor(0, 0, 0, alphaRegister[1].a), 2*py, false)
	
	
	dxDrawText("Passwort:", 612*px, 425*py, 987*px, 459*py, tocolor(255, 255, 255, alphaRegister[1].a), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
	dxDrawRectangle(611*px, 457*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 494*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(989*px, 457*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 457*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	
	--dxDrawLine(613*px, 458*py, 989*px, 458*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(613*px, 495*py, 989*px, 495*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(612*px, 457*py, 612*px, 496*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(990*px, 457*py, 990*px, 496*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	
	
	dxDrawText("E-Mail Adresse:", 612*px, 519*py, 987*px, 553*py, tocolor(255, 255, 255, alphaRegister[1].a), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
	dxDrawRectangle(611*px, 554*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 591*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(989*px, 554*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 554*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	
	--dxDrawLine(613*px, 553*py, 613*px, 592*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(612*px, 592*py, 988*px, 592*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(613*px, 553*py, 989*px, 553*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(987*px, 554*py, 988*px, 592*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
		
		
	dxDrawText("Geburtsdatum:", 612*px, 620*py, 987*px, 654*py, tocolor(255, 255, 255, alphaRegister[1].a), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
	dxDrawRectangle(611*px, 650*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 689*py, 380*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(989*px, 651*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(611*px, 651*py, 2*py, 39*py,tocolor(0, 0, 0, alphaRegister[1].a))
	
	--dxDrawLine(613*px, 654*py, 989*px, 654*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(613*px, 654*py, 613*px, 693*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(613*px, 693*py, 989*px, 693*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(988*px, 654*py, 988*px, 693*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	
	
	dxDrawRectangle(696*px, 785*py, 209*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(696*px, 728*py, 209*px, 2*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(903*px, 728*py, 2*py, 57*py,tocolor(0, 0, 0, alphaRegister[1].a))
	dxDrawRectangle(696*px, 728*py, 2*py, 57*py,tocolor(0, 0, 0, alphaRegister[1].a))
	
	--dxDrawLine(697*px, 729*py, 904*px, 729*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(696*px, 785*py, 903*px, 785*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(696*px, 729*py, 697*px, 785*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
	--dxDrawLine(903*px, 729*py, 903*px, 785*py, tocolor(0, 0, 0, alphaRegister[1].a), 2, false)
end

function Fadein_Register ()
	alphaRegister[1].timer = setTimer(function ()
		if (alphaRegister[1].a ~= alphaRegister[1].maxa) then
			alphaRegister[1].a = alphaRegister[1].a + 10
		else
			killTimer(alphaRegister[1].timer)
		end
	end, 50, -1)
	
	alphaRegister[2].timer = setTimer(function ()
		if (alphaRegister[2].a ~= alphaRegister[2].maxa) then
			alphaRegister[2].a = alphaRegister[2].a + 5
			dxSetEditColor(RegisterStuff.Username, 254, 254, 254, alphaRegister[2].a) 
			dxSetEditColor(RegisterStuff.Password, 254, 254, 254, alphaRegister[2].a) 
			dxSetEditColor(RegisterStuff.Mail, 254, 254, 254, alphaRegister[2].a) 
			dxSetEditColor(RegisterStuff.Birth, 254, 254, 254, alphaRegister[2].a) 
		else
			dxEdit[RegisterStuff.Password].tactv = true;
			dxEdit[RegisterStuff.Username].editable = false;
			dxSetEditText(RegisterStuff.Username, getPlayerName(localPlayer))
			killTimer(alphaRegister[2].timer)
		end
	end, 50, -1)
	
	alphaRegister[3].timer = setTimer(function ()
		if (alphaRegister[3].a ~= alphaRegister[3].maxa) then
			alphaRegister[3].a = alphaRegister[3].a + 8
			dxSetButtonColor(RegisterStuff.Register, 254, 138, 0, alphaRegister[3].a) 
		else
			killTimer(alphaRegister[3].timer)
		end
	end, 50, -1)
end

local ElementChanged
function registerPlayer (bool)
	if bool == true then
		addEventHandler("onClientRender", root, _renderBlur)
		Fadein_Register()
		Register()
		addEventHandler("onClientRender", root, dxDrawRegister)

		guiSetInputMode("no_binds")
		showCursor(true)
	elseif bool == false then
		guiSetInputMode("allow_binds")

		dxRemoveEdit(RegisterStuff.Username)
		dxRemoveEdit(RegisterStuff.Password)
		dxRemoveEdit(RegisterStuff.Mail)
		dxRemoveEdit(RegisterStuff.Birth)
		dxRemoveButton(RegisterStuff.Register)
		removeEventHandler("onClientRender", root, dxDrawRegister)
		removeEventHandler("onClientRender", root, _renderBlur)

		showCursor(false)
	else
		outputDebugString("Can't show Register for "..getPlayerName(lp).."! Bool is not given", 1)
	end
end
addEvent("c_register", true)
addEventHandler("c_register", root, registerPlayer)

-- //
-- || LOGIN
-- \\

local LoginStuff = {}
local alphaLogin = {
	[1] = {a = 0, maxa = 250, timer},
	[2] = {a = 0, maxa = 130, timer},
	[3] = {a = 0, maxa = 200, timer},
}

function Login ()
	setCameraMatrix(1992.5711669922, -1460.2141113281, 12.963700294495, 1991.7709960938, -1459.7365722656, 13.326453208923)
	setElementDimension(localPlayer, 99999)
	setElementInterior(localPlayer, 0)
	showChat(false)

	-- Username
	LoginStuff.Username = dxCreateEdit(613*px, 362*py, 376*px, 35*py, "", 1*py, "bankgothic", 254, 254, 254, 0, false, false)
	
	-- Passwort
	LoginStuff.Password = dxCreateEdit(613*px, 459*py, 376*px, 35*py, "", 1*py, "bankgothic", 254, 254, 254, 0, false, true)
	
	-- LoginButton
	LoginStuff.Login = dxCreateButton(698*px, 529*py, 205*px, 53*py, "Einloggen", 1*py, "bankgothic", 254, 138, 0, 0, false, onLogin, true, true)
	
	-- Showpassword
	--LALALA = dxCreateButton (951, 463, 32, 27, "", 0, "bankgothic", 255, 255, 255, 250, false, onLogin, true, true, "images/dxGUI/showPassword.png")
end

function dxDrawLogin ()
	-- Image
	dxDrawImage(644*px, 0*py, 312*px, 304*py, "FILES/images/hud/logo.png", 360, 0, 0, tocolor(255, 255, 255, alphaLogin[1].a), false)

	-- Username
	dxDrawText("Username:", 612*px, 327, 989*px, 362*py, tocolor(255, 255, 255, alphaLogin[1].a), 0.70*px, "bankgothic", "left", "bottom", false, false, false, false, false)
	dxDrawRectangle(611*px, 360*py, 380*px, 2*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(611*px, 397*py, 380*px, 2*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(989*px, 360*py, 2*py, 39*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(611*px, 360*py, 2*py, 39*py,tocolor(0, 0, 0, alphaLogin[1].a))
	
	--dxDrawLine(610*px, 361*py, 991*px, 361*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(610*px, 398*py, 991*px, 398*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(989*px, 360*py, 990*px, 398.5*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(612*px, 360*py, 612*px, 398.5*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	
	-- Passwort
	dxDrawText("Passwort:", 612*px, 425*py, 987*px, 459*py, tocolor(255, 255, 255, alphaLogin[1].a), 0.70*px, "bankgothic", "left", "bottom", false, false, false, false, false)
    dxDrawRectangle(611*px, 457*py, 380*px, 2*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(611*px, 494*py, 380*px, 2*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(989*px, 457*py, 2*py, 39*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(611*px, 457*py, 2*py, 39*py,tocolor(0, 0, 0, alphaLogin[1].a))
	
	
	--dxDrawLine(613*px, 458*py, 989*px, 458*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
    --dxDrawLine(613*px, 495*py, 989*px, 495*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(612*px, 457*py, 612*px, 496*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(990*px, 457*py, 990*px, 496*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
		
	-- LoginButton
	dxDrawRectangle(696*px, 581*py, 209*px, 2*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(696*px, 527*py, 209*px, 2*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(903*px, 527*py, 2*py, 55*py,tocolor(0, 0, 0, alphaLogin[1].a))
	dxDrawRectangle(696*px, 527*py, 2*py, 55*py,tocolor(0, 0, 0, alphaLogin[1].a))
	
	--698*px, 529*py, 205*px, 53*py
    --dxDrawLine(696*px, 528*py, 904*px, 528*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(696*px, 583*py, 903*px, 583*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
	--dxDrawLine(696*px, 527*py, 696*px, 583*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
    --dxDrawLine(904*px, 527*py, 904*px, 583*py, tocolor(0, 0, 0, alphaLogin[1].a), 2, false)
end

function Fadein_Login ()
	alphaLogin[1].timer = setTimer(function ()
		if (alphaLogin[1].a ~= alphaLogin[1].maxa) then
			alphaLogin[1].a = alphaLogin[1].a + 10
		else
			killTimer(alphaLogin[1].timer)
		end
	end, 50, -1)
	
	alphaLogin[2].timer = setTimer(function ()
		if (alphaLogin[2].a ~= alphaLogin[2].maxa) then
			alphaLogin[2].a = alphaLogin[2].a + 5
			dxSetEditColor(LoginStuff.Username, 254, 254, 254, alphaLogin[2].a) 
			dxSetEditColor(LoginStuff.Password, 254, 254, 254, alphaLogin[2].a) 
		else
			dxEdit[LoginStuff.Password].tactv = true;
			dxEdit[LoginStuff.Username].editable = false;
			dxSetEditText(LoginStuff.Username, getPlayerName(localPlayer))
			killTimer(alphaLogin[2].timer)
		end
	end, 50, -1)
	
	alphaLogin[3].timer = setTimer(function ()
		if (alphaLogin[3].a ~= alphaLogin[3].maxa) then
			alphaLogin[3].a = alphaLogin[3].a + 8
			dxSetButtonColor(LoginStuff.Login, 254, 138, 0, alphaLogin[3].a) 
		else
			killTimer(alphaLogin[3].timer)
		end
	end, 50, -1)
end

function showLoginP (bool)
	if bool == true then
		Fadein_Login()
		addEventHandler("onClientRender", root, _renderBlur)
		Login()
		addEventHandler("onClientRender", root, dxDrawLogin)
		
		guiSetInputMode("no_binds")
		
		fadeCamera(true)
		--toggleRadar(false)
		showCursor(true)
	elseif bool == false then
		dxRemoveEdit(LoginStuff.Username)
		dxRemoveEdit(LoginStuff.Password)
		dxRemoveButton(LoginStuff.Login)
		removeEventHandler("onClientRender", root, dxDrawLogin)
		removeEventHandler("onClientRender", root, _renderBlur)
	
		--guiSetInputEnabled(false)
		guiSetInputMode("allow_binds")
		--destroyElement(Password)
		showCursor(false)
	else
		outputDebugString("Can't show Login for "..getPlayerName(lp).."! Bool is not given", 1)
	end
end
addEvent("c_login", true)
addEventHandler("c_login", root, showLoginP)

function onLogin ()
	--local pass = guiGetText(Password)
	local pass = dxEditGetText(LoginStuff.Password)
	if pass ~= "" then
		triggerServerEvent("s_CheckLogin", lp, lp, pass)
	else
		showInfoBox ("LoginError1", "Login:\nBitte gebe ein Passwort ein!", 3000)
	end
end

function onForget ()
	showInfoBox ("LoginInfo1", "Todo - Password Recovery\nComming Soon!", 3000)
end

-- //
-- || Both
-- \\
triggerServerEvent("s_RLStatus", lp, lp)





















--[[
		-- Button
		dxDrawRectangle(698, 734, 205, 56, tocolor(255, 255, 255, 255), false)
		-- EDIT
        dxDrawRectangle(614, 654, 373, 39, tocolor(255, 255, 255, 255), false)
        dxDrawRectangle(614, 553, 373, 39, tocolor(255, 255, 255, 255), false)
		
		
        dxDrawImage(644, 0, 312, 304, "images/examples/logo.png", 360, 0, 0, tocolor(255, 255, 255, 250), false)
		
        dxDrawText("Username:", 612, 327, 989, 362, tocolor(255, 255, 255, 250), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawLine(613, 361, 989, 361, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(613, 398, 989, 398, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(989, 360, 990, 398, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(612, 360, 612, 399, tocolor(0, 0, 0, 250), 2, false)
		
        dxDrawText("Passwort:", 612, 425, 987, 459, tocolor(255, 255, 255, 250), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawLine(613, 458, 989, 458, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(613, 495, 989, 495, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(612, 457, 612, 496, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(990, 457, 990, 496, tocolor(0, 0, 0, 250), 2, false)
		
        dxDrawText("E-Mail Adresse:", 612, 519, 987, 553, tocolor(255, 255, 255, 250), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawLine(613, 553, 613, 592, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(612, 592, 988, 592, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(613, 553, 989, 553, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(987, 554, 988, 592, tocolor(0, 0, 0, 250), 2, false)
		
        dxDrawText("Geburtsdatum:", 612, 620, 987, 654, tocolor(255, 255, 255, 250), 0.70, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawLine(613, 654, 989, 654, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(613, 654, 613, 693, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(613, 693, 989, 693, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(988, 654, 988, 693, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(696, 734, 697, 790, tocolor(0, 0, 0, 250), 2, false)
        dxDrawLine(903, 734, 903, 790, tocolor(0, 0, 0, 250), 2, false)
--]]