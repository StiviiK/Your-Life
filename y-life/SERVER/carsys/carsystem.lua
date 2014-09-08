-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: carsystem.lua  	            ##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

PrivateVehicles = {}
InsuranceVehicles = {}

function createPrivateVehicle (destroyed, owner, model, x, y, z, rx, ry, rz, c1, c2, c3, damage, carnumber, fuel, numberplate, tunings, stunings)
	if type(tunings) == "string" and type(stunings) == "string" and type(destroyed) == "number" and type(owner) == "string" and type(model) == "number" and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(rx) == "number" and type(ry) == "number" and type(rz) == "number" and type(c1) == "number" and type(c2) == "number" and type(c3) == "number" and type(damage) == "number" and type(carnumber) == "number" and type(fuel) == "number" and type(numberplate) == "string" then
		if 	tonumber(destroyed) == 0 then	
			if (numberplate == "") then
				numberplate = tostring(owner)
			end
			
			local veh = createVehicle(model, x, y, z, rx, ry, rz, numberplate)
						setVehicleColor(veh, c1, c2, c3)
						setElementHealth(veh, damage)
						setElementData(veh, "vehicle.carkey", carnumber)
						setElementData(veh, "vehicle.fuel", fuel)
		end
	end
end
createPrivateVehicle(0, "StiviK", 411, 0, 0, 3, 0, 0, 90, 255, 255, 255, 1000, 1, 100, "", "[ [ 1008 ] ]", toJSON(nil))