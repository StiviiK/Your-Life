DXWindow = {}
DXWindow.__index = DXWindow

setmetatable(DXWindow, {
						__index = DXElement,
						__call = function(_, ...)
							local self = setmetatable({}, DXWindow)
							self:_init(...)
							
							return self
						end
					})

function DXWindow:_init(_x, _y, _width, _height, _title, _color, _alpha)
	DXElement._init(self, _x, _y, _width, _height)

	self.title = _title
	self.color = _color
	self.moveable = false
	self.mouseOffsetX = nil
	self.mouseOffsetY = nil
	self.allowMove = false

	self.renderFunction = function() self:render() self:checkMoveable() end
	addEventHandler("onClientPreRender", getRootElement(), self.renderFunction)
end

function DXWindow:destroy()
	removeEventHandler("onClientPreRender", getRootElement(), self.renderFunction)
	self = nil
end

function DXWindow:render()
	dxDrawRectangle(self.x, self.y, self.width, self.height, self.color, true)
	dxDrawRectangle(self.x, self.y, self.width, 20, self.color, true)
	dxDrawRectangle(self.x, self.y, self.width, 20, self.color, true)
	-- dxDrawRectangle(50, 50, self.width, 20, tocolor(0, 0, 0, 255))
	-- dxDrawText(self.title, self.x, self.y, self.x+self.width, self.y+20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
	dxDrawText(self.title, self.x, self.y, self.x+self.width, self.y+20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true)
	
end

function DXWindow:setMoveable(_movable)
	self.moveable = _movable
end

function DXWindow:getMoveable()
	return self.moveable
end

function DXWindow:checkMoveable()
	if self.moveable then
		local cX, cY = getCursorPosition()
		cX = cX * self.SW
		cY = cY * self.SH
		--outputChatBox(tostring(self:isPositionBetweenCursor(self.x, self.y, self.x+self.width, self.y+20)))
		-- outputChatBox(self.x.." "..self.y)
		if  self.lastCursorState == false and getKeyState("mouse1") then
			if self:isPositionBetweenCursor(self.x, self.y, self.x+self.width, self.y+20) then
				if not self.mouseOffsetX and not self.mouseOffsetY then
					self.mouseOffsetX = cX - self.x
					self.mouseOffsetY = cY - self.y
					self.allowMove = true
				end
			end
		else
			if not getKeyState("mouse1") then
				if self.mouseOffsetX and self.mouseOffsetY then
					self.mouseOffsetX = nil
					self.mouseOffsetY = nil
					self.allowMove = false
				end
			end
		end
		
		if self.allowMove then
				if cX - self.mouseOffsetX + self.width <= self.SW then
					if cX - self.mouseOffsetX >= 0 then
						self:setPosition(cX - self.mouseOffsetX, self.y)
					else
						self:setPosition(0, self.y)
					end
				else
					self:setPosition(self.SW - self.width, self.y)
				end

				if cY - self.mouseOffsetY + self.height <= self.SH then
					if cY - self.mouseOffsetY >= 0 then
						self:setPosition(self.x, cY - self.mouseOffsetY)
					else
						self:setPosition(self.x, 0)
					end
				else
					self:setPosition(self.x, self.SH - self.height)
				end
				
				
			end
	end
	self.lastCursorState = getKeyState("mouse1")
end

function DXWindow:onClientDXVisibleChange(_visible)
	if not _visible then
		self.allowMove = false
	end
end