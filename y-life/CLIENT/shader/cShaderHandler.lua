-- #######################################
-- ## Project: 	MTA Your-Life	  	    ##
-- ## Name: 	cShaderHandler.lua      ##
-- ## Author: 	StiviK					##
-- ## Version: 	1.0						##
-- #######################################

addEventHandler("onClientResourceStart", root, function ()
	shader = {
		["blur"] = dxCreateShader("FILES/shader/BlurShader.fx")
	}
end)

-- Blur Shader
function renderBlur (scsource, strength, posx, posy, sx, sy)
	if (shader["blur"]) then
		dxUpdateScreenSource(scsource)
		dxSetShaderValue(shader["blur"], "ScreenSource", scsource);
		dxSetShaderValue(shader["blur"], "BlurStrength", tonumber(strength));
		dxSetShaderValue(shader["blur"], "UVSize", sx, sy)
		dxDrawImage(posx, posy, sx, sy, shader["blur"], 0, 0, 0, tocolor(255,255,255,255), false)
	else
		if (fileExists("FILES/shader/BlurShader.fx")) then
			shader["blur"] = dxCreateShader("FILES/shader/BlurShader.fx")
		end
	end
end