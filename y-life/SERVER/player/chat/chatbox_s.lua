-- #######################################
-- ## Project: 	MTA Your-Life     		##
-- ## Name: 	Chatbox					    ##
-- ## Author:	Vandam					##
-- ## Version: 	1.0						##
-- #######################################


function chatboxMessage(sendto,player,msg,msgart,c1,c2,c3)
	if msgart then
		triggerClientEvent(sendto,"onClientChatboxMessage",getRootElement(),player,msg,msgart,c1,c2,c3)
	else
		triggerClientEvent(sendto,"onClientChatboxMessage",getRootElement(), player, msg,255,255,255)
	end
end
addEvent("onPlayerChatbox",true)
addEventHandler("onPlayerChatbox",getRootElement(),chatboxMessage)


--test
addCommandHandler("text",function(player,cmd,msg)
	chatboxMessage(player,player,msg)
end
)
