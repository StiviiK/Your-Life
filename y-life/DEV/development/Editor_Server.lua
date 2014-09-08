-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: Editor_Server.lua       	##
-- ## Author: StiviK        			##
-- ## Version: 1.0						##
-- #######################################

DEV_Editor = {
    fileData = {}
}

-- read da files
function DEV_Editor.readFiles ()
    local fileData = {}

    local meta = xmlLoadFile ("meta.xml")
    for i, _ in ipairs(xmlNodeGetChildren(meta)) do
        local info = xmlFindChild(meta, "script", i - 1)
        if info then
            for name, value in pairs(xmlNodeGetAttributes(info)) do
                if (name == "src") then
                    local file = fileOpen(value)
                    table.insert(fileData, {path = tostring(value), data = fileRead(file, fileGetSize(file))})
                    fileClose(file)
                end
            end
        end
    end

    return fileData;
end

-- copy da files into the dev table
DEV_Editor.fileData = DEV_Editor.readFiles()

function DEV_Editor.sendFiles (client)
    if (isElement(client)) then
        triggerClientEvent(client, "DEV_Editor.receiveFileData", client, DEV_Editor.fileData)
    end
end
addEvent("DEV_Editor.sendFileData")
addEventHandler("DEV_Editor.sendFileData", root, DEV_Editor.sendFiles)