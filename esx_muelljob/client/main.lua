print('[GarbageJob] main.lua geladen')

ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local jobStart = vector3(-350.54, -1569.08, 25.22)
local npcModel = `s_m_y_garbage`
local vehicleModel = `trash`
local vehicleSpawn = vector3(-324.41, -1526.27, 27.54)
local vehicleHeading = 274.13
local isJobActive = false
local vehicle = nil

local maleOutfit = {
    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
    ['torso_1'] = 65, ['torso_2'] = 0,
    ['arms'] = 11,
    ['pants_1'] = 36, ['pants_2'] = 0,
    ['shoes_1'] = 12, ['shoes_2'] = 0,
    ['helmet_1'] = 14, ['helmet_2'] = 0
}

local femaleOutfit = {
    ['tshirt_1'] = 14, ['tshirt_2'] = 0,
    ['torso_1'] = 59, ['torso_2'] = 0,
    ['arms'] = 14,
    ['pants_1'] = 35, ['pants_2'] = 0,
    ['shoes_1'] = 10, ['shoes_2'] = 0,
    ['helmet_1'] = 13, ['helmet_2'] = 0
}

CreateThread(function()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do Wait(10) end

    local npc = CreatePed(4, npcModel, jobStart.x, jobStart.y, jobStart.z - 1.0, 294.41, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    local blip = AddBlipForCoord(jobStart)
    SetBlipSprite(blip, 318)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mülljob")
    EndTextCommandSetBlipName(blip)

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - jobStart)

        if dist < 2.0 then
            DrawMarker(1, jobStart.x, jobStart.y, jobStart.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 255, 0, 100, false, true, 2)
            if not isJobActive then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~, um den Mülljob zu starten")
                if IsControlJustReleased(0, 38) then
                    isJobActive = true

                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, maleOutfit)
                        else
                            TriggerEvent('skinchanger:loadClothes', skin, femaleOutfit)
                        end
                    end)

                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
                    Wait(3000)
                    ClearPedTasks(ped)

                    SpawnGarbageTruck()
                end
            else
                ESX.ShowHelpNotification("Der Mülljob läuft bereits!")
            end
        end
        Wait(0)
    end
end)

function SpawnGarbageTruck()
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do Wait(10) end
    vehicle = CreateVehicle(vehicleModel, vehicleSpawn.x, vehicleSpawn.y, vehicleSpawn.z, vehicleHeading, true, true)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetVehicleOnGroundProperly(vehicle)
    local route = GetRandomGarbageRoute()
    _G.StartGarbageRoute(route, netId)
end

RegisterNetEvent('garbagejob:endJob', function()
    if vehicle and DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
    end
    isJobActive = false
end)
