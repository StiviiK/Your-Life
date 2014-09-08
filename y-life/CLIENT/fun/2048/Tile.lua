Tile = {}
Tile.__index = Tile

setmetatable(Tile, {
					__call = function(_, ...)
						local self = setmetatable({}, Tile)
						self:_init(...)
						
						return self
					end})

function Tile:_init(_value, _x, _y)
	self.value = _value
	self.x = math.abs(_x)
	self.y = math.abs(_y)
	self.realX = math.abs(_x)
	self.realY = math.abs(_y)
	self.renderEventFunc = function() self:render() end
	addEventHandler("onClientRender", getRootElement(), self.renderEventFunc)
	self.alpha = 0
	self.changeable = true
	self.canBeDestroyed = false
end

function Tile:render()
	if self.alpha < 255 then
		self.alpha = self.alpha + 25.5
	end
	dxDrawImage(self.x, self.y, 134/2, 134/2, "FILES/images/2048/"..self.value..".png", 0, 0, 0, tocolor(255, 255, 255, self.alpha), true)
	if math.abs(self.x - self.realX) > 40 then
		if (self.realX < self.x) then
			self.x = self.x - 40
		else
			self.x = self.x + 40
		end
	else
		self.x = self.realX
	end
	if math.abs(self.y - self.realY) > 40 then
		if (self.realY < self.y) then
			self.y = self.y - 40
		else
			self.y = self.y + 40
		end
	else
		self.y = self.realY
	end
	
	if math.abs(self.x - self.realX) <= 40 and math.abs(self.y - self.realY) <= 40 and self.canBeDestroyed then
		removeEventHandler("onClientRender", getRootElement(), self.renderEventFunc)
		self = nil
	end

end

function Tile:setX(_x)
	self.realX = _x
end

function Tile:setY(_y)
	self.realY = _y
end
function Tile:getPosition()
	
end	
function Tile:destroy()
	self.canBeDestroyed = true
end