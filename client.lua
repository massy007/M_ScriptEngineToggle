local QBCore = exports['qb-core']:GetCoreObject()
local engineOn = false 


RegisterCommand("toggleengine", function()
    if Config.EngineToggleEnabled then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            engineOn = not engineOn
            SetVehicleEngineOn(vehicle, engineOn, false, true)
            QBCore.Functions.Notify(engineOn and "Engine started" or "Engine stopped", "success")
        end
    else
        QBCore.Functions.Notify("Engine toggle is disabled", "error")
    end
end, false)

RegisterNetEvent('un_enginetoggle:keepOn')
AddEventHandler('un_enginetoggle:keepOn', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, true)

    if vehicle ~= 0 then
        SetVehicleEngineOn(vehicle, true, true, false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, Config.EngineToggleKey) then
            ExecuteCommand("toggleengine")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and not IsPedInVehicle(ped, vehicle, true) then
            TriggerEvent('un_enginetoggle:keepOn')
        end
    end
end)
