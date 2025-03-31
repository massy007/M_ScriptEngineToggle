local QBCore = exports['qb-core']:GetCoreObject()
local engineOn = false  -- Tracks engine state

-- Load keybind and toggle state from config
local Config = {
    EngineToggleKey = 15,  -- Scroll Wheel Up (key 15 from FiveM documentation)
    EngineToggleEnabled = true  -- Set this to false to disable the engine toggle command
}

-- Command to toggle the engine
RegisterCommand("toggleengine", function()
    if Config.EngineToggleEnabled then  -- Check if the engine toggle command is enabled
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            engineOn = not engineOn
            SetVehicleEngineOn(vehicle, engineOn, false, true)
            QBCore.Functions.Notify(engineOn and "Engine started" or "Engine stopped", "success")
        end
    else
        QBCore.Functions.Notify("Engine toggle is disabled", "error")  -- Notify the player that it's disabled
    end
end, false)

-- Keeps engine running when leaving the vehicle
RegisterNetEvent('qb-engine:keepOn')
AddEventHandler('qb-engine:keepOn', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, true)
    
    if vehicle ~= 0 then
        SetVehicleEngineOn(vehicle, true, true, false)
    end
end)

-- Key mapping using control numbers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, Config.EngineToggleKey) then
            ExecuteCommand("toggleengine")
        end
    end
end)

-- Ensure engine stays on when the player exits the vehicle
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 and not IsPedInVehicle(ped, vehicle, true) then
            TriggerEvent('qb-engine:keepOn')
        end
    end
end)
