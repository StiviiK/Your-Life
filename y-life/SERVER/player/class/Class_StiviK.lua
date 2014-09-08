-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: Class_StiviK.lua            ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- First try's in OOP

local loadClass = {}

-- Vehicle Management Class
function Class_VehicleManagement ()
	-- Class Table
	VehicleClass = {};
	VehicleClass.__index = VehicleClass;
	
	-- Another Stuff
	local ClassName = "VehicleClass [OOP]"
	_createVehicle = createVehicle

	-- Class Function's
		-- Constructor
		function VehicleClass:newVehicle (veh)
			local data = {};
			data.vehicle = veh;
			
			setmetatable(data, self)
			
			return data;
		end

		-- Methods
		function VehicleClass:setColor (...)
			return setVehicleColor(self.vehicle, ...);
		end
		
		function VehicleClass:setPosition (...)
			return setElementPosition(self.vehicle, ...);
		end
		
		function VehicleClass:setHealth (...)
			return setElementHealth(self.vehicle, ...);
		end
		
		function VehicleClass:setLocked (...)
			return setVehicleLocked(self.vehicle, ...);
		end
		
		function VehicleClass:setRespawnPosition (...)
			return setVehicleRespawnPosition(self.vehicle, ...);
		end
		
		function VehicleClass:setDamageProof (...)
			return setVehicleDamageProof(self.vehicle, ...);
		end
		
		function VehicleClass:setDoorState (...)
			return setVehicleDoorState(self.vehicle, ...);
		end
		
		function VehicleClass:setDoorOpenRatio (...)
			return setVehicleDoorOpenRatio(self.vehicle, ...);
		end
		
		function VehicleClass:getVehicle ()
			return self.vehicle;
		end
		
		-- Destructor
		function VehicleClass:destroy ()
			local tmp = destroyElement(self.vehicle)
			self.vehicle = nil;
			
			return tmp;
		end
		
		-- Create Function
		function createVehicle (management, ...)
			if (management == "class") then
				local vehicle = VehicleClass:newVehicle(_createVehicle(...));
				addEventHandler("onVehicleExplode", vehicle.vehicle, function ()
					vehicle.vehicle = nil;
				end)
				return vehicle;
			else
				if type(management) == "number" then
					return _createVehicle(management, ...);
				else
					return _createVehicle(...);
				end
			end
		end
			
		-- Class Test (Dass immer brennende Auto, erstellt mit StiviK's OOP Vehicle Klasse)
			vehicle = createVehicle("class", 411, 0, 0, 3)
			vehicle:setColor(0, 125, 0)
			vehicle:setDamageProof(true)
			vehicle:setHealth(50)
			vehicle:setDoorOpenRatio(2, 1)
			
			addEventHandler("onVehicleEnter", vehicle.vehicle, function (_, seat)
				if (seat == 0) then
					outputChatBox(tostring(vehicle:setLocked(true)))
				end
			end)
			
			addEventHandler("onVehicleExit", vehicle:getVehicle(), function (_, seat)
				if (seat == 0) then
					outputChatBox(tostring(vehicle:setLocked(false)))
				end
			end)
			
			--	addEventHandler("onVehicleStartEnter", vehicle.vehicle, function (_, seat)
			--		if (seat ~= 0) then return; end
			--		vehicle:setLocked(true)
			
			--		setTimer(function ()
			--			vehicle:setLocked(false)	
			--		end, 500, 1)
			--	end)
			
			--	How to add Eventhandler on the Vehicle:
			--		addEventHandler(EVENT, vehicle:getVehicle(), FUNCTION)
			--	or
			--		addEventHandler(EVENT, vehicle.vehicle, FUNCTION)
			--
		--
	--
	table.insert(loadClass, "VehicleClass [OOP]")
end
--Class_VehicleManagement()


-- Needs to be at the end of the file!
local LoadedClasses = ""
for _, class in pairs(loadClass) do
	if LoadedClasses == "" then
		LoadedClasses = class
	else
		LoadedClasses = LoadedClasses..", "..class
	end
end

--outputDebugString("[DEV] "..#loadClass.." "..(#loadClass > 1 and "classes" or "class").." have been loaded!", 3)
--outputDebugString("[DEV] Following "..(#loadClass > 1 and "classes" or "class").." have been loaded: "..LoadedClasses, 3)