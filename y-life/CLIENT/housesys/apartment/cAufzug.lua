-- housesys/apartment/cAufzug.lua

function ReceiveAufzugData (CurrEnter)
	GCurrEnter = CurrEnter
end
addEvent("c_ReceiveAufzugData", true)
addEventHandler("c_ReceiveAufzugData", root, ReceiveAufzugData)

function PlayAufzugSound ()
	local sound = playSound3D("BETA/HouseMix.m4a", 1786.61169, -1302.70325, 13.67994, true)
	setSoundVolume(sound, 0.3)
	setSoundSpeed(sound, 1)
	setSoundMaxDistance (sound, 4)
end
--addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), PlayAufzugSound)

	scripterx,scriptery=1600,900
	screenx,screeny=guiGetScreenSize()
	

-- GUI
function fahrstuhl_start()
	if not GUIisOpen then
		--addEventHandler("onClientRender", root, function () renderFarhstuhlGUI (GCurrEnter) end)
		showCursor(true)
		GUIisOpen = true
		local wahletage=0
		fahrstuhl_display = guiCreateStaticImage(screenx*(650/scripterx),screeny*(180/scriptery),screenx*(300/scripterx),screeny*(540/scriptery),"FILES/images/Housesys/fahrstuhl.jpg",false)
		fahrstuhl_button={
			guiCreateStaticImage(screenx*(75/scripterx),screeny*(470/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton1.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(30/scripterx),screeny*(140/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton2.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(30/scripterx),screeny*(195/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton3.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(30/scripterx),screeny*(250/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton4.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(30/scripterx),screeny*(305/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton5.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(30/scripterx),screeny*(360/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton6.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(30/scripterx),screeny*(415/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton7.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(125/scripterx),screeny*(140/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton8.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(125/scripterx),screeny*(195/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton9.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(125/scripterx),screeny*(250/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton10.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(125/scripterx),screeny*(305/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton11.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(125/scripterx),screeny*(360/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton12.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(125/scripterx),screeny*(415/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton13.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(220/scripterx),screeny*(140/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton14.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(220/scripterx),screeny*(195/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton15.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(220/scripterx),screeny*(250/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton16.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(220/scripterx),screeny*(305/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton17.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(220/scripterx),screeny*(360/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton18.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(220/scripterx),screeny*(415/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton19.png",false,fahrstuhl_display),
			guiCreateStaticImage(screenx*(175/scripterx),screeny*(470/scriptery),screenx*(50/scripterx),screeny*(50/scriptery),"FILES/images/Housesys/fahrstuhlbutton20.png",false,fahrstuhl_display),
		}
		for i=1,#fahrstuhl_button,1 do
			addEventHandler( "onClientMouseEnter", fahrstuhl_button[i], function()
				for i=1,#fahrstuhl_button,1 do 
					if source==fahrstuhl_button[i] then
						if wahletage~=i then
							guiStaticImageLoadImage ( fahrstuhl_button[i],"FILES/images/Housesys/fahrstuhlbuttonhover"..i..".png" )
						end
					end
				end
			end)
			addEventHandler( "onClientMouseLeave", fahrstuhl_button[i], function()
				for i=1,#fahrstuhl_button,1 do 
					if source==fahrstuhl_button[i] then
						if wahletage~=i then
							guiStaticImageLoadImage ( fahrstuhl_button[i],"FILES/images/Housesys/fahrstuhlbutton"..i..".png" )
						end
					end
				end
			end)
			addEventHandler("onClientGUIClick",fahrstuhl_button[i],function()
				for i=1,#fahrstuhl_button,1 do 
					if source==fahrstuhl_button[i] then
						if wahletage~=0 then
							guiStaticImageLoadImage ( fahrstuhl_button[wahletage],"FILES/images/Housesys/fahrstuhlbutton"..wahletage..".png" )
						end
						guiStaticImageLoadImage ( fahrstuhl_button[i],"FILES/images/Housesys/fahrstuhlbuttonaktiv"..i..".png" )
						wahletage=i
						sendToServer(i)
					end
				end
			end)
		end
	end
end
addEvent("c_createAufzugGUI", true)
addEventHandler("c_createAufzugGUI", root, fahrstuhl_start)

local GCurrEnterA
function renderFarhstuhlGUI (GCurrEnter)
	--if GCurrEnterA == nil then GCurrEnterA = "E" end
	dxDrawText(GCurrEnterA, 685*px, 208*py, 915*px, 301*py, tocolor(254, 13, 13, 255), 3.00, "default", "center", "center", false, false, true, false, false)
end

function countNumber (number, GCurrEnter)
	GCurrEnterA = GCurrEnter
	addEventHandler("onClientRender", root, renderFarhstuhlGUI)
	if tonumber(GCurrEnter) < tonumber(number) then
		GCurrEnter = GCurrEnter - 1
	else
		GCurrEnter = GCurrEnter - 1
		number = number - 1
	end
	if GCurrEnter == "E" then GCurrEnter = tonumber(1) end
	if GCurrEnter == "OG" then GCurrEnter = tonumber(20) end
	outputChatBox("! "..GCurrEnter)
	outputChatBox("! "..number)
	counter=setTimer(
		function()
			if tonumber(GCurrEnter) < tonumber(number) then
				GCurrEnter = tonumber(GCurrEnter + 1)
				GCurrEnterA = GCurrEnter
				--removeEventHandler("onClientRender", root, function () renderFarhstuhlGUI (GCurrEnter) end)
				--addEventHandler("onClientRender", root, function () renderFarhstuhlGUI (GCurrEnter) end)
				--outputChatBox(GCurrEnter)
			elseif tonumber(GCurrEnter) > tonumber(number) then
				GCurrEnter = tonumber(GCurrEnter - 1)
				GCurrEnterA = GCurrEnter
				--removeEventHandler("onClientRender", root, function () renderFarhstuhlGUI (GCurrEnter) end)
				--addEventHandler("onClientRender", root, function () renderFarhstuhlGUI (GCurrEnter) end)
				--outputChatBox(GCurrEnter)
			end
			if tonumber(GCurrEnter) == tonumber(number) then
				killTimer(counter)
			end
		end,
	1000,0)
end
addEvent("c_countNumber", true)
addEventHandler("c_countNumber", root, countNumber)

function fahrstuhl_stop()
	GUIisOpen = false
	showCursor(false)
	destroyElement(fahrstuhl_display)
	GCurrEnterA = GCurrEnterA + 1
	outputChatBox(GCurrEnterA)
	removeEventHandler("onClientRender", root, renderFarhstuhlGUI)
	
end
addEvent("c_destroyAufzugGUI", true)
addEventHandler("c_destroyAufzugGUI", root, fahrstuhl_stop)

function sendToServer(number)
	triggerServerEvent("s_ReceiveAufzugData", getLocalPlayer(), getLocalPlayer(), tostring(number))
end