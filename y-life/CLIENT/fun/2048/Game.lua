Game = {}
Game.__index = Game

setmetatable(Game, {
					__index = DXElement,
					__call = function(_, ...)
						local self = setmetatable({}, Game)
						self:_init(...)
						
						return self
					end})

function Game:_init(_x, _y, _presetHighscore)
	self.x = _x
	self.y = _y
	self.preX = _y
	self.preY = _y
	self.tileOffset = {{{["x"] = 26/2, ["y"] = 229/2}, {["x"] = 177/2, ["y"] = 229/2}, {["x"] = 329/2, ["y"] = 229/2}, {["x"] = 480/2, ["y"] = 229/2}},
							{{["x"] = 26/2, ["y"] = 380/2}, {["x"] = 177/2, ["y"] = 380/2}, {["x"] = 329/2, ["y"] = 380/2}, {["x"] = 480/2, ["y"] = 380/2}},
							{{["x"] = 26/2, ["y"] = 532/2}, {["x"] = 177/2, ["y"] = 532/2}, {["x"] = 329/2, ["y"] = 532/2}, {["x"] = 480/2, ["y"] = 532/2}},
							{{["x"] = 26/2, ["y"] = 683/2}, {["x"] = 177/2, ["y"] = 683/2}, {["x"] = 329/2, ["y"] = 683/2}, {["x"] = 480/2, ["y"] = 683/2}}
						   }
	

	self.tiles = {{nil, nil, nil, nil}, {nil, nil, nil, nil}, {nil, nil, nil, nil}, {nil, nil, nil, nil}}
	
	self.renderEventFunc = function() self:render() end
	addEventHandler("onClientRender", getRootElement(), self.renderEventFunc)
	self.keyEventFunc = function(_button, _state) self:keyPress(_button, _state) end
	addEventHandler("onClientKey", getRootElement(), self.keyEventFunc)
	self:addRandomTile()
	self:addRandomTile()
	
	

	
	self.score = 0
	if _presetHighscore then
		self.bestScore = _presetHighscore
	else
		self.bestScore = 0
	end
	self.onClientDXCheckboxTick = function() end
end

function Game:render()
	if self.preX ~= self.x or self.preY ~= self.y then
		for i = 1, 4 do
			for j = 1, 4 do
				if self.tiles[i][j] ~= nil then
					self.tiles[i][j].x = self.x + self.tileOffset[i][j]["x"]
					self.tiles[i][j].realX = self.x + self.tileOffset[i][j]["x"]
					self.tiles[i][j].y = self.y + self.tileOffset[i][j]["y"]
					self.tiles[i][j].realY = self.y + self.tileOffset[i][j]["y"]
				end
			end
		end
	end
	dxDrawImage(self.x, self.y, 319, 421, "FILES/images/2048/bg.png", 0, 0, 0, tocolor(255,255,255,255), true)
	dxDrawText(self.score, self.x + 203, self.y + 18, self.x + 203 + 41, self.y + 18 + 22, tocolor(255,255,255, 255), 0.8, 'arial-bold', "center", "center", false, false, true)
	dxDrawText(self.bestScore, self.x + 495/2, self.y + 18, self.x + 495/2 + 137/2, self.y + 18 + 22, tocolor(255,255,255, 255), 0.8, 'arial-bold', "center", "center", false, false, true)
	-- dxDrawRectangle( self.x + 203, self.y + 18, 41, 22)
	if self.score > self.bestScore then
		self.bestScore = self.score
	end
	self.preX, self.preY = self.x, self.y
end

function Game:moveRowHor(_line, _dir, _ask)
	local couldMove = false
	if _dir then
		for j = 1, 4 do
			for i = 3, 1, -1 do
				
				
				if self.tiles[_line][i] ~=nil and self.tiles[_line][i+1]==nil and i +1 <= 4 then
					if not _ask then
						self.tiles[_line][i]:setX(self.x + self.tileOffset[_line][i+1]["x"])
						self.tiles[_line][i+1] = self.tiles[_line][i]
						self.tiles[_line][i] = nil
					end
					couldMove = true
					
				end
			for k = 1, 3 do
					if self.tiles[_line][k] ~= nil and self.tiles[_line][k+1] ~= nil then
						if self.tiles[_line][k].value == self.tiles[_line][k+1].value and self.tiles[_line][k].changeable and self.tiles[_line][k+1].changeable then
							if not _ask then
								self.tiles[_line][k+1].value = self.tiles[_line][k+1].value * 2
								self.tiles[_line][k+1].alpha = 51
								self.score = self.score + self.tiles[_line][k+1].value
								self.tiles[_line][k]:setX(self.tiles[_line][k+1].realX)
								self.tiles[_line][k]:destroy()
								self.tiles[_line][k] = nil
								self.tiles[_line][k+1].changeable = false
							end
							couldMove = true
						end
					end
				end
			end
		end
		
	else
		for j = 1, 4 do
			for i = 4, 2, -1 do
				
				if self.tiles[_line][i] ~=nil and self.tiles[_line][i-1]==nil and i -1 >= 1 then
					if not _ask then
						self.tiles[_line][i]:setX(self.x + self.tileOffset[_line][i-1]["x"])
						self.tiles[_line][i-1] = self.tiles[_line][i]
						self.tiles[_line][i] = nil
					end
					couldMove = true
				end
				
				for k = 1, 3 do
					if self.tiles[_line][k] ~= nil and self.tiles[_line][k+1] ~= nil then
						if self.tiles[_line][k].value == self.tiles[_line][k+1].value and self.tiles[_line][k].changeable and self.tiles[_line][k+1].changeable then
							if not _ask then
								self.tiles[_line][k].value = self.tiles[_line][k].value * 2
								self.tiles[_line][k].alpha = 51
								self.score = self.score + self.tiles[_line][k].value
								self.tiles[_line][k+1]:setX(self.tiles[_line][k].realX)
								self.tiles[_line][k+1]:destroy()
								self.tiles[_line][k+1] = nil
								self.tiles[_line][k].changeable = false
							end
							couldMove = true
						end
					end
				end
			end
		end
	end
	
	for i = 1, 4 do
		if self.tiles[_line][i] ~= nil then
			self.tiles[_line][i].changeable = true
		end
	end
	
	if couldMove then
		return true
	else
		return false
	end
end

function Game:moveRowVert(_line, _dir, _ask)
	local couldMove = false
	if _dir then
		for j = 1, 4 do
			for i = 3, 1, -1 do
				
				if self.tiles[i][_line] ~=nil and self.tiles[i+1][_line]==nil and i + 1 <= 4 then
					if not _ask then
						self.tiles[i][_line]:setY(self.y + self.tileOffset[i+1][_line]["y"])
						self.tiles[i+1][_line] = self.tiles[i][_line]
						self.tiles[i][_line] = nil
					end
					couldMove = true
				end
				for k = 1, 3 do
					if self.tiles[k][_line] ~= nil and self.tiles[k+1][_line] ~= nil then
						if self.tiles[k][_line].value == self.tiles[k+1][_line].value and self.tiles[k][_line].changeable and self.tiles[k+1][_line].changeable then
							if not _ask then
								self.tiles[k+1][_line].value = self.tiles[k+1][_line].value * 2
								self.tiles[k+1][_line].alpha = 51
								self.score = self.score + self.tiles[k+1][_line].value
								self.tiles[k][_line]:setY(self.tiles[k+1][_line].realY)
								self.tiles[k][_line]:destroy()
								self.tiles[k][_line] = nil
								self.tiles[k+1][_line].changeable = false
							end
							couldMove = true
						end
					end
				end
			end
		end
	else
		for j = 1, 4 do
			for i = 4, 2, -1 do
				
				if self.tiles[i][_line] ~=nil and self.tiles[i-1][_line]==nil and i -1 >= 1 then
					if not _ask then
						self.tiles[i][_line]:setY(self.y + self.tileOffset[i-1][_line]["y"])
						self.tiles[i-1][_line] = self.tiles[i][_line]
						self.tiles[i][_line] = nil
					end
					couldMove = true
				end
				for k = 1, 3 do
					if self.tiles[k][_line] ~= nil and self.tiles[k+1][_line] ~= nil then
						if self.tiles[k][_line].value == self.tiles[k+1][_line].value and self.tiles[k][_line].changeable and self.tiles[k+1][_line].changeable then
							if not _ask then
								self.tiles[k][_line].value = self.tiles[k][_line].value * 2
								self.tiles[k][_line].alpha = 51
								self.score = self.score + self.tiles[k][_line].value
								self.tiles[k+1][_line]:setY(self.tiles[k][_line].realY)
								self.tiles[k+1][_line]:destroy()
								self.tiles[k+1][_line] = nil
								self.tiles[k][_line].changeable = false
							end
							couldMove = true
						end
					end
				end
			end
		end
	end
	
	for i = 1, 4 do
		if self.tiles[i][_line] ~= nil then
			self.tiles[i][_line].changeable = true
		end
	end
	
	if couldMove then
		return true
	else
		return false
	end
end

function Game:addTile(_value, _x, _y)
	local tx, ty = self.tileOffset[_x][_y]["x"], self.tileOffset[_x][_y]["y"]
	self.tiles[_x][_y] = Tile(_value, self.x + tx, self.y + ty)
end

function Game:addRandomTile()
	local nilCount = 0
	for i = 1, 4 do
		for j = 1, 4 do
			if self.tiles[i][j] == nil then
				nilCount = nilCount + 1
			end
		end
	end
	
	local nilRand = math.random(1, nilCount)
	nilCount = 0
	for i = 1, 4 do
		for j = 1, 4 do
			if self.tiles[i][j] == nil then
				nilCount = nilCount + 1
				
				if nilCount == nilRand then
					local twoFourRand = math.random(1, 1000)
					if twoFourRand < 900 then
						self:addTile(2, i, j)
					else
						self:addTile(4, i, j)
					end
					break
				end
			end
		end
	end
end
function Game:keyPress(_button, _state)
	if _button == "mouse1" and not _state then
		if self:isPositionBetweenCursor(self.x + 469/2, self.y + 108/2, self.x + 469/2 + 163/2, self.y + 108/2 + 50/2) then
			self.score = 0
			for i = 1, 4 do
				for j = 1, 4 do
					if self.tiles[i][j] ~= nil then
						self.tiles[i][j]:destroy()
						self.tiles[i][j] = nil
					end
				end
			end
			self:addRandomTile()
			self:addRandomTile()
		end
	end
	local couldMove = false
	if _state then
		if _button == "arrow_u" then
			for i = 1, 4 do 
				if self:moveRowVert(i, false) then
					couldMove = true
				end
			end
		elseif _button == "arrow_d" then
			for i = 1, 4 do 
				if self:moveRowVert(i, true) then
					couldMove = true
				end
			end
		elseif _button == "arrow_l" then
			for i = 1, 4 do 
				if self:moveRowHor(i, false) then
					couldMove = true
				end
			end
		elseif _button == "arrow_r" then
			for i = 1, 4 do 
				if self:moveRowHor(i, true) then
					couldMove = true
				end
			end
		end
	end
	
	if couldMove then
		self:addRandomTile()		
	end
	
	for i = 1, 4 do
		for j = 1, 4 do
			if self.tiles[i][j] == nil then
				return
			end
		end
	end
	
	for i = 1, 4 do
		if (not self:moveRowVert(1, false, true) and not self:moveRowVert(1, true, true) and not self:moveRowHor(1, false, true) and not self:moveRowHor(1, true, true)) and 
		(not self:moveRowVert(2, false, true) and not self:moveRowVert(2, true, true) and not self:moveRowHor(2, false, true) and not self:moveRowHor(2, true, true)) and 
		(not self:moveRowVert(3, false, true) and not self:moveRowVert(3, true, true) and not self:moveRowHor(3, false, true) and not self:moveRowHor(3, true, true)) and 
		(not self:moveRowVert(4, false, true) and not self:moveRowVert(4, true, true) and not self:moveRowHor(4, false, true) and not self:moveRowHor(4, true, true)) then
			self.tiles[2][1].value = "g"
			self.tiles[2][2].value = "a"
			self.tiles[2][3].value = "m"
			self.tiles[2][4].value = "e"
			self.tiles[3][1].value = "o"
			self.tiles[3][2].value = "v"
			self.tiles[3][3].value = "e"
			self.tiles[3][4].value = "r"
		end
	end
end

function Game:destroy()
	for i = 1, 4 do
		for j = 1, 4 do
			if self.tiles[i][j] ~= nil then
				self.tiles[i][j]:destroy()
				self.tiles[i][j] = nil
			end
		end
	end
	removeEventHandler("onClientRender", getRootElement(), self.renderEventFunc)
	removeEventHandler("onClientKey", getRootElement(), self.keyEventFunc)
	self = nil
end

function Game:onClientDXVisibleChange(_visible)
	
end

function Game:handleKey(_button, _pressed)
end

function Game:setVisible(_visible)

end