--[[ 
fuelManager.lua

This module provides functions to manage the turtle's fuel.
It checks the turtle's fuel level and, if necessary, refuels the turtle.

The module works as follows:
1. When the turtle's fuel level is checked, it first determines the required fuel based on the operation type (e.g., "forward" or "return").
2. If the turtle's fuel level is below the required amount, it will attempt to refuel using any fuel items in its inventory.
3. If after refueling from its inventory, the turtle's fuel level is still below the required amount, it will then attempt to refuel from a chest above it.
4. If even after refueling from both its inventory and the chest the turtle doesn't have enough fuel, a warning message is printed to the user.

The module exports the following main function:
1. checkFuel: Checks the turtle's fuel level based on the operation type and refuels if necessary. It prioritizes refueling from the turtle's inventory before resorting to the chest.

Fuel sources are prioritized in the following order:
1. Lava Bucket
2. Coal
3. Dried Kelp Block
4. Bamboo
]]--

local function getFuelPriority()
    return {
        "minecraft:lava_bucket",
        "minecraft:coal",
        "minecraft:dried_kelp_block",
        "minecraft:bamboo"
    }
end

local function fuelConsumption()
    local currentFuel = turtle.getFuelLevel()
    local fuelItems = getFuelPriority()
    
    local refueled = false
    local fuelDifference = 0

    for _, fuelItem in ipairs(fuelItems) do
        if refueled then break end

        for slot = 1, 16 do
            turtle.select(slot)
            local itemDetail = turtle.getItemDetail()

            if itemDetail and itemDetail.name == fuelItem then
                turtle.refuel(1) -- Refuel using one item 
                local newFuel = turtle.getFuelLevel()
                fuelDifference = newFuel - currentFuel

                if fuelDifference > 0 then
                    refueled = true
                    break
                end
            end
        end
    end

    return fuelDifference
end

local function refuelFromInventory()
    local fuelItems = getFuelPriority()
    local refueled = false

    for _, fuelItem in ipairs(fuelItems) do
        if refueled then break end

        for slot = 1, 16 do
            turtle.select(slot)
            local itemDetail = turtle.getItemDetail()

            if itemDetail and itemDetail.name == fuelItem then
                turtle.refuel(1) -- Refuel using one item from inventory
                refueled = true
                break
            end
        end
    end

    return refueled
end

local function refuelFromChest()
    local fuelItems = getFuelPriority()
    for _, fuelItem in ipairs(fuelItems) do
        for slot = 1, 16 do
            turtle.select(slot)
            if turtle.suckUp() then -- Try to take fuel from the chest above
                local itemDetail = turtle.getItemDetail(slot)
                if itemDetail and itemDetail.name == fuelItem then
                    turtle.refuel()
                end
            end
        end
    end
end

local function checkFuel(pattern, operationType)
    local fuelUnit = fuelConsumption() -- Get the fuel consumption unit

    local requiredFuel = 0

    -- Calculate fuel requirements based on the operation type
    if operationType == "forward" then
        -- Calculate the total number of moves in the pattern
        local totalMoves = 0
        for _, row in ipairs(pattern) do
            totalMoves = totalMoves + #row
        end
        requiredFuel = totalMoves * 2 * fuelUnit -- Account for both movement and chopping/breaking actions
    elseif operationType == "return" then
        requiredFuel = #pattern * fuelUnit -- Only account for movement during return
    else
        error("Invalid operation type for fuel check.") -- Throw an error for invalid operation types
    end

    -- Check if the turtle has sufficient fuel
    if turtle.getFuelLevel() < requiredFuel then
        print("Refueling...")
        
        -- First, try to refuel from the turtle's inventory
        if not refuelFromInventory() then
            -- If not enough fuel in inventory, refuel from the chest
            refuelFromChest()
        end
        
        -- Re-check fuel level after refueling
        if turtle.getFuelLevel() < requiredFuel then
            print("Warning: Not enough fuel refueled. Please ensure there's sufficient fuel in the chest or inventory.")
            return false
        end
    end

    return true
end

return {
    checkFuel = checkFuel
}
