local actions = {}

RegisterCommand("me", function(source, args, rawCommand)
    local action = table.concat(args, " ")
    TriggerServerEvent("player:performAction", action)
end, false)

RegisterNetEvent("player:displayAction")
AddEventHandler("player:displayAction", function(action)
    actions[GetPlayerServerId(PlayerId())] = action

    Citizen.CreateThread(function()
        Wait(5000) -- Affiche l'action pendant 5 secondes (ajustez selon vos besoins)
        actions[GetPlayerServerId(PlayerId())] = nil
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()

        if DoesEntityExist(ped) then
            local pedCoords = GetEntityCoords(ped)

            for playerId, action in pairs(actions) do
                local otherPlayerPed = GetPlayerPed(GetPlayerFromServerId(playerId))

                if DoesEntityExist(otherPlayerPed) then
                    local dist = #(pedCoords - GetEntityCoords(otherPlayerPed))

                    if dist < 20.0 then
                        DrawText3D(GetEntityCoords(otherPlayerPed).x, GetEntityCoords(otherPlayerPed).y, GetEntityCoords(otherPlayerPed).z + 1.0, action)
                    end
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end