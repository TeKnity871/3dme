RegisterServerEvent("player:performAction")
AddEventHandler("player:performAction", function(action)
    TriggerClientEvent("player:displayAction", -1, action)
end)
