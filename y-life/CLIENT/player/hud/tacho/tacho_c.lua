-- #######################################
-- ## Project: 	MTA Your-Life     		##
-- ## Name: 	Tacho				    ##
-- ## Author:	Vandam					##
-- ## Version: 	1.0						##
-- #######################################


scripterx,scriptery=1600,900
screenx,screeny=guiGetScreenSize()

motorStartbar=true

local tachoStatus=false
local multiplikator=0
local Gang=1
local autogang="N"
local tueropen="warntuerezu"
local getTankInhalt=100
local gefahreneKM=0
local altx,alty,altz
local Drehzahl

function showTacho(status)
	if status then
		if not tachoStatus then
			addEventHandler("onClientRender",getRootElement(),showTachoRender)
			tachoStatus=true
			altx,alty,altz=getElementPosition(getLocalPlayer())
		end
	elseif not status then
		if tachoStatus then
			removeEventHandler("onClientRender",getRootElement(),showTachoRender)
			tachoStatus=false
		end
	end
end
addEventHandler("onClientVehicleEnter",getRootElement(),function(player)
	setVehicleEngineState(getPedOccupiedVehicle(player), false)
	showTacho(true)
end
)
addEventHandler("onClientVehicleExit",getRootElement(),function()
	showTacho(false)
end
)
addEventHandler("onClientVehicleExplode", getRootElement(), function()
	killTimer(getFahrzeugVerbrauchProSekundeTimer)
end
)

local getFahrzeugVerbrauchProSekundeTimer
local isFahrzeugVerbrauchProSekundeTimer
bindKey("x","down",function()
	if isPedInVehicle(getLocalPlayer()) then
		local tveh=getPedOccupiedVehicle(getLocalPlayer())
		if motorStartbar then
			if getVehicleEngineState(tveh) then
				setVehicleEngineState(tveh,false)
				if isFahrzeugVerbrauchProSekundeTimer then
					--killTimer(getFahrzeugVerbrauchProSekundeTimer)
					isFahrzeugVerbrauchProSekundeTimer=false
				end
			else
				setVehicleEngineState(tveh,true)	
				isFahrzeugVerbrauchProSekundeTimer=true
				--[[getFahrzeugVerbrauchProSekundeTimer=setTimer(function()
					getTankInhalt=getTankInhalt-getFahrzeugVerbrauchProSekunde(tveh)
					if getTankInhalt<=0 then
						getTankInhalt=0
						if isFahrzeugVerbrauchProSekundeTimer then
							killTimer(getFahrzeugVerbrauchProSekundeTimer)
							isFahrzeugVerbrauchProSekundeTimer=false
							motorStartbar=false
							setVehicleEngineState(tveh,false)
						end
					end
					outputChatBox(getTankInhalt)
				end,10000,0)--]]
			end
		end
	end
end
)

function showTachoRender()
	if isPedInVehicle(getLocalPlayer()) then
	

		dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/tacho.png",0,0,0,tocolor(255,255,255),true)
		local tveh=getPedOccupiedVehicle(getLocalPlayer())

	--Distance
		local neux,neuy,neuz=getElementPosition(tveh)
		gefahreneKM=gefahreneKM+getDistanceBetweenPoints3D(neux,neuy,neuz,altx,alty,altz)/1000
		altx,alty,altz=neux,neuy,neuz
		dxDrawText(math.round(gefahreneKM).." km",screenx*(1400/scripterx),screeny*(790/scriptery),screenx*(1403/scripterx),screeny*(793/scriptery),tocolor(255,255,255),screeny*(1.7/scriptery),"default","center","center",false,false,true)

	--Speed
		local Geschwindigkeit=getElementSpeed(tveh)

	--Drehzahl	
		Gang=getVehicleCurrentGear(tveh)
		if Gang==0 then 
			multiplikator=50
			Gang=1
		elseif Gang==1 then 
			multiplikator=60 
		elseif Gang==2 then 
			multiplikator=75 
		elseif Gang==3 then 
			multiplikator=90 
		elseif Gang==4 then 
			multiplikator=105
		elseif Gang==5 then 
			multiplikator=120 
		end
		Drehzahl=500+multiplikator*Geschwindigkeit/Gang
		if not getVehicleEngineState(tveh) then Drehzahl=0 end
		if Drehzahl>7000 then Drehzahl=7000 end
		dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/pfeildrehzahl.png",Drehzahl*0.045,0,0,tocolor(255,255,255),true) 

	--Gänge
		if Geschwindigkeit <= 2 then
			autogang="N"
		else
			autogang=getVehicleCurrentGear(getPedOccupiedVehicle(getLocalPlayer()))
		end
		if getVehicleCurrentGear(tveh)==0 then autogang="R" end
		if getVehicleCurrentGear(tveh)==0 then Gang="R" end
		dxDrawText(math.round(Geschwindigkeit),screenx*(1400/scripterx),screeny*(710/scriptery),screenx*(1403/scripterx),screeny*(713/scriptery),tocolor(255,255,255),screeny*(3/scriptery),"default","center","center",false,false,true)
		dxDrawText(autogang,screenx*(1400/scripterx),screeny*(750/scriptery),screenx*(1403/scripterx),screeny*(753/scriptery),tocolor(255,255,255),screeny*(3/scriptery),"default","center","center",false,false,true)

	--Licht
		if getVehicleOverrideLights(tveh)==2 then	
			dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/warnlicht.png",0,0,0,tocolor(255,255,255),true) 
		end

	--Lampe
		if getVehicleLightState(tveh,0)==1 or getVehicleLightState(tveh,1)==1 or getVehicleLightState(tveh,2)==1 or getVehicleLightState(tveh,3)==1 then
			dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/warnlampe.png",0,0,0,tocolor(255,255,255),true) 
		end

	--Batterie
		if getVehicleEngineState(tveh) then
			dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/warnbattery.png",0,0,0,tocolor(255,255,255),true) 
		end

	--Türen
		if getVehicleDoorOpenRatio(tveh,2)~=0 and getVehicleDoorOpenRatio(tveh,3)~=0 then tueropen="warntuereauf"
		elseif getVehicleDoorOpenRatio(tveh,2)~=0 then tueropen="warntuerelinks"
		elseif getVehicleDoorOpenRatio(tveh,3)~=0 then tueropen="warntuererechts"
		else
			tueropen="warntuerezu"
		end
		dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/"..tueropen..".png",0,0,0,tocolor(255,255,255),true) 
		
	--ESP
		if (getControlState("accelerate") and not isVehicleOnGround(tveh)) or (getControlState("accelerate") and getControlState("brake_reverse")) then
			dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/warnesp.png",0,0,0,tocolor(255,255,255),true)
		end

	--Tank
		local tankinhalt=getTankInhalt
		if	tankinhalt<=20 then
			dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/warntank.png",0,0,0,tocolor(255,255,255),true)
		end
		dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/pfeiltank.png",tankinhalt*0.62,0,0,tocolor(255,255,255),true)

	--Motor
		if	getElementHealth(tveh)<=600 then
			dxDrawImage(screenx*(1200/scripterx),screeny*(600/scriptery),screenx*(400/scripterx),screeny*(300/scriptery),"player/hud/tacho/images/warnmotor.png",0,0,0,tocolor(255,255,255),true)
		end
	else
		showTacho(false)
	end
end



function getElementSpeed(element)
speedx, speedy, speedz = getElementVelocity (element)
actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
kmh = actualspeed * 180
return kmh
end


local speed
function getFahrzeugVerbrauchProSekunde(vehicle)
	speed=getElementSpeed(vehicle)
	if speed<1 then
		speed=1
	end
	return (speed*0.06+3)--/450000)*2
end

function setElementSpeed(element, speed)
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element)
		if (acSpeed~=false) then
			local diff = speed/acSpeed
			local x,y,z = getElementVelocity(element)
			setElementVelocity(element,x*diff,y*diff,z*diff)
			return true
		end
	return false
end	
	


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end





