-- player/nametag/cNametag.lua

-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: cNametag.lua		    	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local lp = getLocalPlayer()
socialstate = {}
isFriend = {}
--[[ OLD
function renderNameTag ()
	for i, v in pairs(getElementsByType("ped")) do
		local xp, yp, zp = getElementPosition(v)
		local mx, my, mz = getCameraMatrix()
		if getElementDimension(v) == getElementDimension(lp) then
			if getElementInterior(v) == getElementInterior(lp) then
				--if getPlayerName(v) ~= getPlayerName(lp) then
					local dist = math.sqrt( ( mx - xp ) ^ 2 + ( my - yp ) ^ 2 + ( mz - zp ) ^ 2 )
					if dist < 20.0 then
						if isLineOfSightClear(mx, my, mz, xp, yp, zp, true, true, false, true, false, false, false, lp) then
							local sx, sy, sz = getPedBonePosition( v, 5 )
							local gx, gy = getScreenFromWorldPosition( sx, sy, sz + 0.3)
							local gx2, gy2 = getScreenFromWorldPosition( sx, sy, sz + 0.2)
							local gx3, gy3 = getScreenFromWorldPosition( sx, sy, sz + 0.4)
							if gx and gx2 and gx3 then
								--if isFriend["StiviK"] then
								--	dxDrawImage(gx3, gy3, gx3+50, gy3+50, "images\\friend.png")
								--end
								dxDrawText("StiviK", gx, gy, gx, gy, tocolor(255, 255, 255, getElementHealth(v)*2), 1.30*px, "bankgothic", "center", "center", false, false, false, false, false)
								if dist < 10 then
									dxDrawText(socialstate["StiviK"], gx2 , gy2 , gx2, gy2, tocolor(255, 255, 255, (getElementHealth(v)*2) + (getElementHealth(v)/2)), 0.5*py, "bankgothic", "center", "center", false, false, false, false, false)
								end
							end
						end
					end
				--end
			end
		end
	end
end
--]]

function renderNameTag ()
	for i, v in pairs(getElementsWithinColShape(maxdist, "player")) do
		if not isElementWithinColShape(v, mindist) then
			local xp, yp, zp = getElementPosition(v)
			local xl, yl, zl = getElementPosition(getLocalPlayer())
			local mx, my, mz = getCameraMatrix()
			if getElementDimension(v) == getElementDimension(lp) then
				if getElementInterior(v) == getElementInterior(lp) then
					if v ~= lp then
						--local dist = math.sqrt( ( mx - xp ) ^ 2 + ( my - yp ) ^ 2 + ( mz - zp ) ^ 2 )
						local dist = getDistanceBetweenPoints3D(xl, yl, zl, xp, yp, zp)
						if isLineOfSightClear(mx, my, mz, xp, yp, zp, true, true, false, true, false, false, false, lp) then
							local sx, sy, sz = getPedBonePosition( v, 8 )
							local gx, gy = getScreenFromWorldPosition( sx, sy, sz + 0.4)
							if gx and v then																											-- 1.30													-- bankgothic
								dxDrawText(getPlayerName(v), gx, gy, gx, gy, tocolor(factionColors[getElementData(v, "player.faction")].r, factionColors[getElementData(v, "player.faction")].g, factionColors[getElementData(v, "player.faction")].b, (getElementHealth(v)*2) + (getElementHealth(v)/2)), 0.50*px, fonts["hand"], "center", "center", false, false, false, false, false)
								if dist < 5 then
									if (isFriend[getPlayerName(v)] or false) then
										dxDrawImage(gx - 15, gy - 40, 30, 30, "FILES/images/Nametag/friend.png", 0, 0, 0, tocolor(255, 215, 0, (getElementHealth(v)*2) + (getElementHealth(v)/2)))
									end	
									--if string.len(getElementData(v, "socialstate")) <= 12 then
										dxDrawText(getElementData(v, "player.socialstate"), gx, gy + 40, gx, gy, tocolor(factionColors[getElementData(v, "player.faction")].r, factionColors[getElementData(v, "player.faction")].g, factionColors[getElementData(v, "player.faction")].b, (getElementHealth(v)*2) + (getElementHealth(v)/2)), 0.6*py, "bankgothic", "center", "center", false, false, false, false, false)
									--end
								end
							end
						end
					end
				end
			end
		end
	end
end

function UpdateFriendState(name, bool)
	isFriend[name] = bool
end
addEvent("c_UpdateFriendData", true)
addEventHandler("c_UpdateFriendData", root, UpdateFriendState)

function onSpawn ()
	if getElementType(source)=="player" then
		if (not isEventHandlerAdded("onClientRender", root, renderNameTag)) then
				maxdist = createColSphere(0, 0, 0, 10)
				mindist = createColSphere(0, 0, 0, 0.8)
			
				attachElements(maxdist, source)
				attachElements(mindist, source)
			
				addEventHandler("onClientRender", root, renderNameTag)
		end
	end
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), onSpawn)



