local EnterLobby = createMarker(1788.400390625, -1298.1999511719, 12.300000190735 + 0.09, "cylinder", 1, 96, 96, 96, 255)

addEventHandler("onMarkerHit", EnterLobby, function (hitelement) setElementPosition(hitelement, 1783.5999755859, -1299.8000488281, 119.80000305176) end)
local KeyPad = createObject(2886, 1785.1, -1303.4, 13.98)
local KeyPed = createInteractivePed(1783.57214, -1303.56140, 13.53881, 0, 2, "E", "down", "c_createAufzugGUI", "client")
setElementRotation(KeyPad, 0, 0, 90)

local AufzugEnter = {}
AufzugEnter[1] = createMarker(1786.599609375, -1300.7998046875, 22.799999237061, "arrow", 1.5, 96, 96, 96, 255) -- Lobby
AufzugEnter[2] = createMarker(1786.599609375, -1300.7998046875, 28.299999237061, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[3] = createMarker(1786.599609375, -1300.7998046875, 33.700000762939, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[4] = createMarker(1786.599609375, -1300.7998046875, 39.200000762939, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[5] = createMarker(1786.599609375, -1300.7998046875, 44.700000762939, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[6] = createMarker(1786.599609375, -1300.7998046875, 50, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[7] = createMarker(1786.599609375, -1300.7998046875, 55.5, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[8] = createMarker(1786.599609375, -1300.7998046875, 61, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[9] = createMarker(1786.599609375, -1300.7998046875, 66.5, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[10] = createMarker(1786.599609375, -1300.7998046875, 71.800003051758, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[11] = createMarker(1786.599609375, -1300.7998046875, 77.300003051758, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[12] = createMarker(1786.599609375, -1300.7998046875, 82.699996948242, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[13] = createMarker(1786.599609375, -1300.7998046875, 88.199996948242, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[14] = createMarker(1786.599609375, -1300.7998046875, 93.599998474121, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[15] = createMarker(1786.599609375, -1300.7998046875, 99.099998474121, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[16] = createMarker(1786.599609375, -1300.7998046875, 104.5, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[17] = createMarker(1786.599609375, -1300.7998046875, 110.09999847412, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[18] = createMarker(1786.599609375, -1300.7998046875, 115.5, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[19] = createMarker(1786.599609375, -1300.7998046875, 120.90000152588, "arrow", 1.5, 96, 96, 96, 255)
AufzugEnter[20] = createMarker(1782.69604, -1299.73279, 131.78, "corona", 1.5, 96, 96, 96, 255) -- Dach

local AufzugExitX = {}
local AufzugExitY = {}
local AufzugExitZ = {}
-- 1 = Lobby; 20 = Dach
AufzugExitX[1], AufzugExitY[1], AufzugExitZ[1] = 1786.599609375, -1300.7998046875, 22.799999237061
AufzugExitX[2], AufzugExitY[2], AufzugExitZ[2] = 1786.599609375, -1300.7998046875, 28.299999237061
AufzugExitX[3], AufzugExitY[3], AufzugExitZ[3] = 1786.599609375, -1300.7998046875, 33.700000762939
AufzugExitX[4], AufzugExitY[4], AufzugExitZ[4] = 1786.599609375, -1300.7998046875, 39.200000762939
AufzugExitX[5], AufzugExitY[5], AufzugExitZ[5] = 1786.599609375, -1300.7998046875, 44.700000762939
AufzugExitX[6], AufzugExitY[6], AufzugExitZ[6] = 1786.599609375, -1300.7998046875, 50
AufzugExitX[7], AufzugExitY[7], AufzugExitZ[7] = 1786.599609375, -1300.7998046875, 55.5
AufzugExitX[8], AufzugExitY[8], AufzugExitZ[8] = 1786.599609375, -1300.7998046875, 61
AufzugExitX[9], AufzugExitY[9], AufzugExitZ[9] = 1786.599609375, -1300.7998046875, 66.5
AufzugExitX[10], AufzugExitY[10], AufzugExitZ[10] = 1786.599609375, -1300.7998046875, 71.800003051758
AufzugExitX[11], AufzugExitY[11], AufzugExitZ[11] = 1786.599609375, -1300.7998046875, 77.300003051758
AufzugExitX[12], AufzugExitY[12], AufzugExitZ[12] = 1786.599609375, -1300.7998046875, 82.699996948242
AufzugExitX[13], AufzugExitY[13], AufzugExitZ[13] = 1786.599609375, -1300.7998046875, 88.199996948242
AufzugExitX[14], AufzugExitY[14], AufzugExitZ[14] = 1786.599609375, -1300.7998046875, 93.599998474121
AufzugExitX[15], AufzugExitY[15], AufzugExitZ[15] = 1786.599609375, -1300.7998046875, 99.099998474121
AufzugExitX[16], AufzugExitY[16], AufzugExitZ[16] = 1786.599609375, -1300.7998046875, 104.5
AufzugExitX[17], AufzugExitY[17], AufzugExitZ[17] = 1786.599609375, -1300.7998046875, 110.09999847412
AufzugExitX[18], AufzugExitY[18], AufzugExitZ[18] = 1786.599609375, -1300.7998046875, 115.5
AufzugExitX[19], AufzugExitY[19], AufzugExitZ[19] = 1786.599609375, -1300.7998046875, 120.90000152588
AufzugExitX[20], AufzugExitY[20], AufzugExitZ[20] = 1782.70837, -1298.13135, 131.73320

local AufzugX, AufzugY, AufzugZ = 1786.61169, -1302.70325, 13.67994
local AufzugR = 180

local i = 1
while i <= 20 do
    local i2 = i;
	addEventHandler("onMarkerHit", AufzugEnter[i], function (hitelement) IntoAufzug(hitelement) end)
	addEventHandler("onMarkerHit", AufzugEnter[i], function (hitelement) CurrEnter = i2 SendToClient(hitelement, CurrEnter) end)
	i = i + 1
end

function IntoAufzug (player)
	setElementData(player,"allowednumber", 5)
	local i = 1
	while i <= 20 do
		if i == getElementData(player, "allowednumber") + 1 then	
			break
		end
		i = i + 1
	end
	
	--if i < 20 or getElementData(player, "isinApartment") == true then
		fadeCamera ( player, false, 0.8, 0, 0, 0 ) 
		setTimer(function () fadeCamera ( player, true, 1.0, 0, 0, 0 )  end, 80, 1)
		setElementPosition(player, AufzugX, AufzugY, AufzugZ)
		setElementRotation(player, 0, 0, AufzugR)
	--else
	--	outputChatBox("Du darfst keines der Apartments betreten!", player, 125, 0, 0)
	--	outputChatBox("Bitte klingel bei einem Freund oder kaufe dir ein Apartment!", player, 125, 0, 0)
	--end
end
addCommandHandler("aufzug", IntoAufzug)

local GCurrEnter = {}
local hasClickedNumber = {}
function SendToClient (player, CurrEnter)
	GCurrEnter[player] = CurrEnter
	if CurrEnter == 1 then
		CurrEnter = "E"
	elseif CurrEnter == 20 then
		CurrEnter = "OG"
	elseif CurrEnter <= 19 then
		CurrEnter = CurrEnter - 1
	end
	triggerClientEvent(player, "c_ReceiveAufzugData", player, tostring(CurrEnter))
end

function ReceiveAufzugData (player, number)
	if source ~= client then return false; end

	if not hasClickedNumber[player] then
		--if tonumber(number) == tonumber(getElementData(player, "allowednumber") + 1) or tonumber(number) == 20 or tonumber(number) == 1 then
			--if tonumber(number) <= 18 then number = number + 1 end
			if GCurrEnter[player] == nil then GCurrEnter[player] = 1 end
			if GCurrEnter[player] == tonumber(number) then
				outputChatBox("ERROR")
			else
				hasClickedNumber[player] = true
				if GCurrEnter[player] < tonumber(number) then
					time = (number - GCurrEnter[player])*1000
				else
					time = (GCurrEnter[player] - number)*1000
				end
					outputChatBox(tostring(number))
					outputChatBox(time)
				triggerClientEvent(player, "c_countNumber", player, number, GCurrEnter[player])
				setTimer(
					function()
						fadeCamera ( player, false, 0.8, 0, 0, 0 ) 
						setTimer(function () fadeCamera ( player, true, 1.0, 0, 0, 0 )  end, 80, 1)
						setElementPosition(player, AufzugExitX[tonumber(number)], AufzugExitY[tonumber(number)], AufzugExitZ[tonumber(number)])
						GCurrEnter[player] = tonumber(number)
						hasClickedNumber[player] = false
						triggerClientEvent(player, "c_destroyAufzugGUI", player)
					end, time + 1000, 1)
			end
		--else
		--	outputChatBox("Du darfst nur die "..tostring(getElementData(player, "allowednumber"))..". Etage betreten!", player, 125, 0, 0)
		--end
	else
		outputChatBox("Bitte drücke immer nur einen Knopf!", player, 125, 0, 0)
	end
end
addEvent("s_ReceiveAufzugData", true)
addEventHandler("s_ReceiveAufzugData", root, ReceiveAufzugData)