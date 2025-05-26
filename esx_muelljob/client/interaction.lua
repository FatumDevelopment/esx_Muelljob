print('[GarbageJob] interaction.lua erfolgreich geladen')

local trashProps = {
    `prop_bin_05a`, 
    `prop_bin_06a`, 
    `prop_bin_07a`, 
    `prop_bin_08a`
}

local isJobActive = false  
local vehicle = nil
local vehicleBlip = nil
local depotCoords = vector3(-324.41, -1526.27, 27.54)

_G.StartGarbageRoute = function(route, vehicleNetId)
    if isJobActive then
        ESX.ShowHelpNotification("Du hast den Mülljob bereits gestartet!")
        return
    end

    vehicle = NetToVeh(vehicleNetId)

    if not route or type(route) ~= 'table' or not vehicle then
        print('[GarbageJob] ⚠️ Keine gültige Route oder Fahrzeug!')
        return
    end

    isJobActive = true  
    local current = 1
    local blip = nil

    vehicleBlip = AddBlipForEntity(vehicle)
    SetBlipSprite(vehicleBlip, 318)
    SetBlipColour(vehicleBlip, 3)
    SetBlipScale(vehicleBlip, 0.8)
    SetBlipAsShortRange(vehicleBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Dein Müllwagen")
    EndTextCommandSetBlipName(vehicleBlip)

    local function spawnTrash(pos)
        local randomTrash = trashProps[math.random(1, #trashProps)]
        local trashObj = CreateObject(randomTrash, pos.x, pos.y, pos.z, true, true, true)
        return trashObj
    end

    local function returnToDepot()
        if blip then RemoveBlip(blip) end
        blip = AddBlipForCoord(depotCoords)
        SetBlipSprite(blip, 50)
        SetBlipColour(blip, 2)
        SetBlipRoute(blip, true)
        ESX.ShowNotification("Fahre zurück zum Depot, um deinen Müllwagen abzugeben!")

        CreateThread(function()
            local atDepot = false
            while not atDepot do
                local pedCoords = GetEntityCoords(PlayerPedId())
                local dist = #(pedCoords - depotCoords)

                if dist < 5.0 then
                    ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~, um den Müllwagen abzugeben")
                    if IsControlJustReleased(0, 38) then
                        if DoesEntityExist(vehicle) then
                            DeleteVehicle(vehicle)
                        end
                        if vehicleBlip then RemoveBlip(vehicleBlip) end
                        if blip then RemoveBlip(blip) end

                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_COP_IDLES", 0, true)
                        Wait(3000)
                        ClearPedTasks(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                        end)

                        TriggerServerEvent('garbagejob:payPlayer')
                        isJobActive = false
                        atDepot = true
                    end
                end
                Wait(0)
            end
        end)
    end

    local function showNext()
        if current > #route then
            print('[GarbageJob] ✅ Route abgeschlossen!')
            returnToDepot()
            return
        end

        local pos = route[current]
        if blip then RemoveBlip(blip) end
        blip = AddBlipForCoord(pos)
        SetBlipSprite(blip, 1)
        SetBlipRoute(blip, true)

        local trashObj = spawnTrash(pos)

        CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                if #(coords - pos) < 2.0 then
                    ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~, um Müll einzusammeln")
                    if IsControlJustReleased(0, 38) then
                        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
                        Wait(4000)
                        ClearPedTasks(ped)
                        DeleteObject(trashObj)

                        if blip then
                            RemoveBlip(blip)
                            blip = nil
                        end

                        local bagModel = `prop_cs_rub_binbag_01`
                        RequestModel(bagModel)
                        while not HasModelLoaded(bagModel) do Wait(10) end
                        local bag = CreateObject(bagModel, coords.x, coords.y, coords.z, true, true, false)
                        AttachEntityToEntity(bag, ped, GetPedBoneIndex(ped, 57005), 0.3, 0, -0.05, 0, 0, 0, true, true, false, true, 1, true)

                        ESX.ShowNotification("Bringe den Müllsack zum Müllwagen!")

                        local thrown = false
                        while not thrown do
                            local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -4.5, 0.0)
                            DrawMarker(1, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 255, 0, 0, 100, false, true, 2)

                            local pedCoords = GetEntityCoords(ped)
                            local distToVehicle = #(pedCoords - vehicleCoords)

                            if distToVehicle < 2.0 then
                                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~, um den Müllsack einzuwerfen")
                                if IsControlJustReleased(0, 38) then
                                    DetachEntity(bag, 1, 1)
                                    DeleteObject(bag)

                                    RequestAnimDict('anim@heists@narcotics@trash')
                                    while not HasAnimDictLoaded('anim@heists@narcotics@trash') do Wait(10) end
                                    TaskPlayAnim(ped, 'anim@heists@narcotics@trash', 'throw_b', 8.0, -8.0, -1, 48, 0, false, false, false)
                                    Wait(2000)
                                    ClearPedTasks(ped)

                                    thrown = true
                                end
                            end
                            Wait(0)
                        end

                        current = current + 1
                        showNext()
                        break
                    end
                end
                Wait(0)
            end
        end)
    end

    showNext()
end
