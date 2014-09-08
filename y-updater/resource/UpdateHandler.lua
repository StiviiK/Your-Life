-- #######################################
-- ## Project: MTA Y-Updater    	    ##
-- ## Name: fileHandler.lua		    	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

local files = {}
local FileCount = 0
local SuccessFiles = 0
local SkippedFiles = {}
local SkippedFilesC = 0

function EndUpdate ()
	outputServerLog("//                                   \\\\")
	outputServerLog("||    The Update was sucessfull!     ||")
	outputServerLog("|| "..SuccessFiles.."/"..FileCount.." Files have been downloaded! ||")
	outputServerLog("||       "..SkippedFilesC.."/"..FileCount.. " Files have failed!     ||")
	outputServerLog("\\\\                                   //")

	if ShowFailedFiles then
		for i, v in pairs(SkippedFiles) do
			outputServerLog("Failed File: ["..v.."], Errornum: ["..files[v].errnum.."], Requested Page: ["..UpdateLoc..v.."]")
		end
	end

	handleRemoteResource(false, UpdaterName)
	handleRemoteResource(true, ResourceName)
end

function downloadUpdate (filename, loc)
	fetchRemote(UpdateLoc..filename, function(data, errno)
		if errno == 0 then
			if fileExists(CacheLoc..filename) then
				fileDelete(CacheLoc..filename)
			end
			
			if (not files[filename] ~= nil) then files[filename] = {} end
			files[filename].data = data
			files[filename].loc = loc
			
			files[filename].file = fileCreate(CacheLoc..filename)
			fileWrite(files[filename].file, files[filename].data)
			fileClose(files[filename].file)
			
			--outputChatBox(files[filename].loc)
			--outputChatBox(":"..ResourceName.."/"..files[filename].loc.."/"..filename)
			
			
			CopyHandler(filename)
		else
			if (not files[filename] ~= nil) then files[filename] = {} end
			files[filename].errnum = errno
			
				--outputDebugString("Error while downloading file: ["..filename.."], Filepath: ["..UpdateLoc..filename.."] [Errornumber: "..errno.."]", 1)
			SkippedFilesC = SkippedFilesC + 1
			table.insert(SkippedFiles, filename)
			
			if (SkippedFilesC + SuccessFiles) == FileCount then
				EndUpdate()
			end
		end
	end)
end

function CopyHandler (filename)
	if files[filename] ~= nil then
		if fileExists(":"..ResourceName.."/"..files[filename].loc.."/"..filename) then
			fileDelete(":"..ResourceName.."/"..files[filename].loc.."/"..filename)
		end
			
		local status = fileCopy(CacheLoc..filename, ":"..ResourceName.."/"..files[filename].loc.."/"..filename)
		
		if (status) then
			SuccessFiles = SuccessFiles + 1
			--outputChatBox("Curr Files: "..SuccessFiles.."/"..FileCount)
			
			if SuccessFiles == (FileCount - SkippedFilesC) then				
				EndUpdate()
			end
		end
	end
end

function CheckForUpdates ()
	if fileExists("updates.xml") then
		fileDelete("updates.xml")
	end
	
	fetchRemote(UpdateFile, function (data, errno)
		if errno == 0 then
			local setfile = fileCreate("updates.xml")
			fileWrite(setfile, data)
			fileClose(setfile)
			
			GetUpdates()
		else
			handleRemoteResource(true, ResourceName)
			handleRemoteResource(false, UpdaterName)
			return false;
		end
	end)
end

function GetUpdates ()
	if (not fileExists("updates.xml")) then
		handleRemoteResource(false, UpdaterName)
		return false; 
	end
	
	handleRemoteResource(false, ResourceName) -- Stop the Gamemode
	
	local settings = xmlLoadFile("updates.xml")
	FileCount = #xmlNodeGetChildren(settings)
	SuccessFiles = 0
	
	if FileCount > 0 then
		outputServerLog("//                            \\\\")
		outputServerLog("|| An Update have been found! ||")
		outputServerLog("||    Downloading "..FileCount.." File"..((FileCount > 1) and "s." or ". ").."    ||")
		outputServerLog("||   This may take a while!   ||")
		outputServerLog("\\\\                            //")
		
		for i, v in ipairs (xmlNodeGetChildren(settings)) do
			local name = xmlNodeGetAttribute(v, "name")
			local loc = xmlNodeGetAttribute(v, "loc")
			
			downloadUpdate(name, loc)
		end
		
		xmlUnloadFile(settings)
	else
		outputServerLog("//                              \\\\")
		outputServerLog("||  No Update have been found!  ||")
		outputServerLog("|| The Gamemode will be started ||")
		outputServerLog("||        Please Wait!          ||")
		outputServerLog("\\\\                              //")
		
		handleRemoteResource(true, ResourceName)
		handleRemoteResource(false, UpdaterName)
	end
end
CheckForUpdates()