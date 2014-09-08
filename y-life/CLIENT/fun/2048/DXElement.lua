DXElement = {}
DXElement.__index = DXElement

setmetatable(DXElement, {
					__call = function(_, ...)
						local self = setmetatable({}, DXElement)
						self:_init(...)
						
						return self
					end})

function DXElement:_init(_x, _y, _width, _height)
	self.parent = nil
	self.childreen = {}
	self.x = _x
	self.y = _y
	self.width = _width
	self.height = _height
	self.SW, self.SH = guiGetScreenSize()
	self.offsetX, self.offsetY = 0, 0
	self.visible = true
	
	self.renderFunction = function() self:checkChildreenPosition() end
	self.renderEvent = addEventHandler("onClientPreRender", getRootElement(), self.renderFunction)
end

function DXElement:destroy()

end

function DXElement:setParent(_parent)
	if self.parent then
		self.parent:removeChild(self)
		self.parent = nil
	end
	self.parent = _parent
	self.parent:addChild(self)
end

function DXElement:getParent()
	if self.parent then
		return self.parent
	else
		return nil
	end
end

function DXElement:addChild(_child)
	for k, v in pairs(self.childreen) do
		if v == _child then
			return
		end
	end
	table.insert(self.childreen, _child)
	local cx, cy = _child:getPosition()
	_child.offsetX = self.x - cx
	_child.offsetY = self.y - cy
end

function DXElement:removeChild(_child)
	for k, v in pairs(self.childreen) do
		if v == _child then
			table.remove(self.childreen, k)
		end
	end
end

function DXElement:getChildreen()
	return self.childreen
end

function DXElement:isChild(_child)
	for k, v in pairs(self.childreen) do
		if v == _child then
			return true
		end
	end
	
	return false
end

function DXElement:checkChildreenPosition()
	for k, v in pairs(self:getChildreen()) do
		v:setPosition(self.x - v.offsetX, self.y - v.offsetY)
	end
end

function DXElement:setPosition(_x, _y)
	self.x = _x
	self.y = _y
end

function DXElement:getPosition()
	return self.x, self.y
end

function DXElement:isPositionBetweenCursor(_x1, _y1, _x2, _y2)
	if isCursorShowing() then
		local cX, cY = getCursorPosition()
		local SW, SH = guiGetScreenSize()
		cX = cX * SW
		cY = cY * SH
			
		return cX >= _x1 and cX <= _x2 and cY >= _y1 and cY <= _y2
	else
		return false
	end
end

function DXElement:setVisible(_visible)
	self:onClientDXVisibleChange(_visible)
	if _visible then
		if not self.renderEvent then
			self.renderEvent = addEventHandler("onClientPreRender", getRootElement(), self.renderFunction)
			self.visible = true
		end
	else
		if self.renderEvent then
			removeEventHandler("onClientPreRender", getRootElement(), self.renderFunction)
			self.renderEvent = nil
			self.visible = false
		end
	end

	for k, v in pairs(self.childreen) do
		v:setVisible(_visible)
	end
end

function DXElement:getVisible(_visible)
	return self.renderEvent ~= nil
end