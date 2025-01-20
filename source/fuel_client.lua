AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
    currentFuel = GetVehicleFuelLevel(vehicle)

    while isFueling do
        Citizen.Wait(500)

        local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
        local fuelToAdd = math.random(10, 20) / 10.0
        local extraCost = fuelToAdd / 1.5 * Config.CostMultiplier

        if not pumpObject then
            if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
                currentFuel = oldFuel + fuelToAdd
                SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
            else
                isFueling = false
            end
        else
            currentFuel = oldFuel + fuelToAdd
        end

        if currentFuel > 100.0 then
            currentFuel = 100.0
            ShutOffPump = true
        end

        currentCost = currentCost + extraCost

        -- Server-side validation for balance
        TriggerServerEvent('fuel:checkBalance', currentCost, function(allowed)
            if allowed then
                SetFuel(vehicle, currentFuel)
            else
                ShutOffPump = true
            end
        end)

        if ShutOffPump then
            ShutOffPump = false
            Citizen.Wait(Config.WaitTimeAfterRefuel)
            isFueling = false

            -- Charge the user immediately after pump stops
            if currentCost > 0 then
                TriggerServerEvent('fuel:pay', currentCost)
                currentCost = 0.0
            end
        end
    end

    currentCost = 0.0
end)
