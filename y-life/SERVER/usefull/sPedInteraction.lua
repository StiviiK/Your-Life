-- #######################################
-- ## Project: MTA Your-Life     		##
-- ## Name: sPedInteraction.lua         ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

Peds = {}
ColSpheres = {}

function createInteractivePed (x,y,z,rot,skinid,key,state,func,stype,ptype)
		local event = tostring(func)
		local Ped = createPed(skinid, x, y, z, rot)
		table.insert (Peds, Ped)
		local ColSphere = createColSphere(x, y, z, 4)
		table.insert (ColSpheres, ColSphere)
		setElementData(Ped, "ColSphere", ColSphere)
		attachElements(ColSphere, Ped)
		setElementFrozen(Ped, true)
		addEventHandler("onColShapeHit", ColSphere,
			function (hitelement)
				if getPedOccupiedVehicle(hitelement) ~= nil then
					if getElementType(hitelement) == "player" then
						elementdata = getElementData(hitelement, "keybound")
						if elementdata ~= true then 
							if stype == "server" then
								bindKey(hitelement, key, state, 
									function ()
										triggerEvent(event, hitelement) 
									end)
								triggerClientEvent(hitelement, "addBindKeyText", hitelement, key, tonumber(x), tonumber(y), tonumber(z))
								setElementData(hitelement, "keybound", true)
							elseif stype == "client" then
								bindKey(hitelement, key, state, 
									function () 
										triggerClientEvent(hitelement,event,hitelement) 
									end)
								triggerClientEvent(hitelement, "addBindKeyText", hitelement, key, tonumber(x), tonumber(y), tonumber(z))
								setElementData(hitelement, "keybound", true)
							end
						end
					end
				end
			end)
		addEventHandler("onColShapeLeave", ColSphere,
			function (hitelement)
				if getPedOccupiedVehicle(hitelement) ~= nil then
					if getElementType(hitelement) == "player" then
					elementdata = getElementData(hitelement, "keybound")
						if elementdata == true then
							unbindKey(hitelement, key, state)
							triggerClientEvent(hitelement, "removeBindKeyText", hitelement)
							setElementData(hitelement, "keybound", false)
						end
					end
				end
			end)
		
		if ptype == "shopped" then
			-- TODO
		else
			addEventHandler("onPedWasted", Ped, 
				function () 
					destroyElement(ColSphere)
					destroyElement(Ped)
					createInteractivePed (x,y,z,rot,skinid,key,state,func,stype,ptype)
				end)
		end
		
		return Ped;
end