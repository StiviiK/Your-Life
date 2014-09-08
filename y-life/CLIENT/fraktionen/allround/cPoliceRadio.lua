-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cPoliceRadio.lua	    	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- //
-- || Created: 16.04.14
-- \\

local PoliceRadio = {
	[1] = {}, -- SFPD
	[2] = {}, -- SWAT
	[3] = {}, -- Army
	[4] = {} -- Special
}
local CurrTalking = {}
local RadioNames = {
	[1] = "Kanal: Polizei",
	[2] = "Kanal: SWAT",
	[3] = "Kanal: Bunderswehr",
	[4] = "Kanal: Spezial-Einsatz"
}
local RadioColors = {
	[1] = {c1 = 0, c2 = 0, c3 = 139},
	[2] = {c1 = 139, c2 = 0, c3 = 0},
	[3] = {c1 = 0, c2 = 100, c3 = 0},
	[4] = {c1 = 255, c2 = 215, c3 = 0}
}
-- Add the Visualition Eventhandler	
addEventHandler('onClientPlayerVoiceStart', root,
    function()
		CurrTalking[source] = true
    end
)
addEventHandler('onClientPlayerVoiceStop', root,
    function()
		CurrTalking[source] = false
    end
)	

-- Update the given Table
function UpdateTable (currtable, number)
	PoliceRadio[number] = currtable
end
addEvent("UpdateClientTables", true)
addEventHandler("UpdateClientTables", root, UpdateTable)

-- Update the CurrChannel of the LocalPlayer
local currChannel = nil
function UpdateCurChannel (number)
	currChannel = tonumber(number)
end
addEvent("UpdateClientCurChannel", true)
addEventHandler("UpdateClientCurChannel", root, UpdateCurChannel)

-- Render the Current Channel (Max: 30 User)
function dxRenderChannel ()
	if currChannel ~= nil then
		local pos = 37
		local i = 1
		local count = #PoliceRadio[currChannel]
		if count > 30 then count = 30 end -- Only 30 Players!
		
		dxDrawRectangle(1406*px, 0*py, 194*px, ((37*count/2) + 20)*py, tocolor(0, 0, 0, 180), false)
		--dxDrawText("/channelinfo für mehr Infos", 1406, ((37*count/2) + 20)*py, 1600, 57, tocolor(255, 255, 255, 107), 1.00, "default-bold", "center", "top", false, false, true, false, false)
		dxDrawRectangle(1406*px, 0*py, 194*px, 16*py, tocolor(0, 0, 0, 255), true)
		dxDrawText(RadioNames[currChannel], 1406*px, 0*py, 1600*px, 16*py, tocolor(RadioColors[currChannel].c1, RadioColors[currChannel].c2, RadioColors[currChannel].c3, 255), 1.00*py, "default-bold", "center", "center", false, false, true, false, false)
			
		while i <= count do
			if PoliceRadio[currChannel][i] ~= nil then
				if CurrTalking[PoliceRadio[currChannel][i]] then													-- 72,209,204
					dxDrawText(getPlayerName(PoliceRadio[currChannel][i]), 1406*px, 21*py, 1600*px, pos*py, tocolor(100, 100, 100, 255), 1.00*py, "default-bold", "center", "center", false, false, true, false, false)
				else
					dxDrawText(getPlayerName(PoliceRadio[currChannel][i]), 1406*px, 21*py, 1600*px, pos*py, tocolor(255, 255, 255, 255), 1.00*py, "default-bold", "center", "center", false, false, true, false, false)
				end
			end
				
			pos = pos + 37
			i = i + 1
				
		end
	end
end
addEventHandler("onClientRender", root, dxRenderChannel)