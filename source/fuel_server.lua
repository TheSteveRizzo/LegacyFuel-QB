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
            -- Attempt to remove cash from the player
            local success = player.Functions.RemoveMoney('cash', amount, 'GAS FILL UP')

            if success then
                print(("[FUEL] Charged player %s $%s for gas"):format(src, amount))
            else
                print(("[FUEL] Failed to charge player %s for gas"):format(src))
            end
        else
            print("[FUEL] Price is invalid or zero!")
        end
    end)
end