local dxCustomization = {
    scrollbar = {},
	updateb = {}
}


function()
	dxCustomization.scrollbar.r = guiCreateScrollBar(20, 222, 330, 20, true, false)
	dxCustomization.scrollbar.g = guiCreateScrollBar(20, 186, 330, 20, true, false)
	dxCustomization.scrollbar.b = guiCreateScrollBar(20, 147, 330, 20, true, false)
	dxCustomization.scrollbar.a = guiCreateScrollBar(20, 112, 330, 20, true, false)
	
	dxCustomization.updateb.perm = dxCreateButton(14, 247, 170, 26, "Update", 0.6, "bankgothic", 254, 139, 0, 212, false, 
		function ()
	
		end)
	dxCustomization.updateb.temp = dxCreateButton(190, 247, 170, 26, "Show", 0.6, "bankgothic", 254, 139, 0, 212, false, 
		function ()
			
		end)
		
	dxCustomization.updateb.demo = dxCreateButton(383, 29, 190, 38, "Show", 0.6, "bankgothic", 254, 139, 0, 212, false, 
		function ()
			dxUpdateButtonColor(dxCustomization.updateb.demo, 125, 0, 0, 255)
		end)
	end
)

addEventHandler("onClientRender", root,
    function()
        dxDrawRectangle(10, 10, 354, 15, tocolor(254, 135, 0, 255), false)
        dxDrawText("GUI - Customization", 20, 10, 354, 25, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, false, false, false)
		   
		dxDrawRectangle(383, 29, 190, 38, tocolor(0, 0, 0, 210), false)
        --dxDrawRectangle(388, 35, 180, 26, tocolor(254, 139, 0, 212), false)
        dxDrawText("Hier kannst du die GUI's nach deinen \nFarbwünschen anpassen!", 20, 35, 354, 67, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "top", false, false, true, false, false)

		dxDrawText("Alpha:", 24, 204, 346, 222, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawText("B:", 24, 167, 346, 185, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawText("G:", 24, 132, 346, 150, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "bottom", false, false, false, false, false)
        dxDrawText("R:", 22, 94, 344, 112, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "bottom", false, false, false, false, false)
    end
)




dxDrawRectangle(383, 10, 190, 15, tocolor(254, 135, 0, 255), false)
dxDrawRectangle(10, 29, 354, 248, tocolor(0, 0, 0, 210), false)
dxDrawText("Beispiel GUI", 393, 10, 563, 25, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, false, false, false)