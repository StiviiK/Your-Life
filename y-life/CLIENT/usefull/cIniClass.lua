-- usefull/client/cIniClass

--[[

	#############################
	##   (c) Soner		       ##
	##   EasyIni 			   ## 
	#############################
	
]]--


EasyIni = {}
EasyIni.__index = EasyIni

function EasyIni:loadFile(filename)
	local self = setmetatable({},EasyIni)
	if not fileExists(filename) then
		outputDebugString("Ini cant find "..filename)
		return false
	end
	local file = fileOpen(filename)
	local data = nil
	if  fileGetSize(file) == 0  then
		data = {}
	else
		local read = fileRead(file,fileGetSize(file))
		fileClose(file)
		data = {}
		local filedata = split(read,"\n")
		local lastzone = ""
		for _,row in ipairs(filedata) do 
			if string.find(row, "[", 1, true) and string.find(row, "]", 1, true) then
				local b,e = string.find(row,"]",1,true)
				lastzone = string.sub(row,2,e-1)
				if not data[lastzone] then
					data[lastzone]={}
				end
			elseif string.find(string.sub(row,1,1),";",1,true) then --Ignorieren von INI Kommentierungen
			else
				local tempsplit = split(row,"=")
				data[lastzone][tempsplit[1]] = tempsplit[2]
			end
		end
	end
	self.data = data
	self.filename = filename
	return self
end

function EasyIni:newFile(filename)
	local self = setmetatable({},EasyIni)
	self.data = {}
	self.filename = filename
	return self
end

function EasyIni:get(selection,name)
	if self.data[selection] then
		if self.data[selection][name] then
			return self.data[selection][name]
		else
			return false
		end
	else
		return false
	end
end

function EasyIni:set(selection,name,value)
	if not self.data[selection] then
		self.data[selection] = {}
	end
	self.data[selection][name] = value
	return true
end


function EasyIni:save()
	local string = ""
	for selection,selectiontable in pairs(self.data) do 
		string = string.."["..selection.."]\n"
		for k,v in pairs(selectiontable) do 
			string = string..k.."="..v.."\n"
		end
	end
	local file = fileCreate(self.filename)
	fileWrite(file,string)
	fileClose(file)
	return true
end