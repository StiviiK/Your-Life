-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: Editor_Client.lua         	##
-- ## Author: StiviK        			##
-- ## Version: 1.0						##
-- #######################################

DEV_Editor = {
    GUI = {
        gridlist = {},
        window = {},
        button = {},
        memo = {}
    },
    fileData = {}
}

-- GUI Stuff
function DEV_Editor.createWindow ()
    DEV_Editor.GUI.window[1] = guiCreateWindow(0, 0, 271, 800, "Filemanager:", false)
    guiWindowSetSizable(DEV_Editor.GUI.window[1], false)
    guiSetAlpha(DEV_Editor.GUI.window[1], 1.00)

    DEV_Editor.GUI.button[1] = guiCreateButton(9, 671, 253, 34, "Open file", false, DEV_Editor.GUI..window[1])
    guiSetProperty(DEV_Editor.GUI.button[1], "NormalTextColour", "FFAAAAAA")
    DEV_Editor.GUI.button[2] = guiCreateButton(9, 715, 253, 34, "Close current file", false, DEV_Editor.GUI..window[1])
    guiSetProperty(DEV_Editor.GUI.button[2], "NormalTextColour", "FFAAAAAA")
    DEV_Editor.GUI.button[3] = guiCreateButton(9, 759, 253, 31, "Close", false, DEV_Editor.GUI.window[1])
    guiSetProperty(DEV_Editor.GUI.button[3], "NormalTextColour", "FFAAAAAA")
    DEV_Editor.GUI.gridlist[1] = guiCreateGridList(9, 29, 253, 632, false, DEV_Editor.GUI..window[1])
    guiGridListAddColumn(DEV_Editor.GUI.gridlist[1], "File:", 0.9)


    DEV_Editor.GUI.window[2] = guiCreateWindow(329, 84, 792, 606, "Editor", false)
    guiWindowSetSizable(DEV_Editor.GUI.window[2], false)
    DEV_Editor.GUI.memo[1] = guiCreateMemo(9, 24, 774, 572, "", false, GUIEditor.window[2])
end

-- receive the data
function DEV_Editor.receiveFileData (fileData)
    if (fileData ~= nil) then
        if (type(fileData) == "table") then
            DEV_Editor.fileData = fileData
        else
            outputDebugString("Bad Argument @ DEV_Editor.receiveFileData [Expectet table at Argument 1 got "..type(fileData).."]", 1)
        end
    else
        outputDebugString("Bad Argument @ DEV_Editor.receiveFileData [Expectet table at Argument 1 got "..type(fileData).."]", 1)
    end
end
addEvent("DEV_Editor.receiveFileData")
addEventHandler("DEV_Editor.receiveFileData", root, DEV_Editor.receiveFileData)

DEV_Editor.receiveFileData({[1] = "hahaahahhhah"})