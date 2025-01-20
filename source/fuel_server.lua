QBCore = nil

if Config.UseQB then
    QBCore = exports['qb-core']:GetCoreObject()

    -- Define the rounding function
    local function round(num)
        return math.floor(num + 0.5)
    end

    RegisterServerEvent('fuel:pay')
    AddEventHandler('fuel:pay', function(price)
        local src = source -- Get the player's server ID
        local player = QBCore.Functions.GetPlayer(src) -- Get the player object
        local amount = round(price) -- Round the price to the nearest whole number

        if not player then
            print("[FUEL] Error: Player not found!")
            return
        end

        if price > 0 then
            local retries = 3 -- Set the retry limit
            local success = false

            -- Attempt to remove money with retries
            while retries > 0 and not success do
                success = player.Functions.RemoveMoney('cash', amount, 'GAS FILL UP')

                if success then
                    print(("[FUEL] Charged player %s $%s for gas"):format(src, amount))
                else
                    retries = retries - 1
                    print(("[FUEL] Retry %s - Failed to charge player %s for gas"):format(3 - retries, src))
                    Citizen.Wait(1000) -- Optional: Add a delay before retrying
                end
            end

            if not success then
                print(("[FUEL] Payment failed after 3 attempts for player %s"):format(src))
                -- You can add further actions here, such as notifying the player
                TriggerClientEvent('fuel:paymentFailed', src, amount)
            end
        else
            print("[FUEL] Price is invalid or zero!")
        end
    end)
end
