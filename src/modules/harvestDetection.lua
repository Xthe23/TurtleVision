--[[ 
harvestDetection.lua

This module provides functions to detect and dig harvestable blocks in front of the turtle.
It uses the turtle's inspect function to check the block in front of it. If the block is configured as harvestable, the turtle will dig it.

The module exports the following main function:
1. detectAndHarvest: Inspects the block in front of the turtle. If the block is configured as harvestable, the turtle digs it.

The module relies on the turtle API for inspecting and digging operations.
]]--

local function detectAndHarvest(blockName, orientation)
    blockName = blockName or "minecraft:bamboo" -- Default to bamboo if no block name is provided
    orientation = orientation or "forward" -- Default orientation is forward
    
    local success, data
    if orientation == "forward" then
        success, data = turtle.inspect()
    elseif orientation == "down" then
        success, data = turtle.inspectDown()
    elseif orientation == "up" then
        success, data = turtle.inspectUp()
    else
        error("Invalid orientation provided to detectAndHarvest function.")
    end
    
    if success then
        if data.name == blockName then
            if orientation == "forward" then
                turtle.dig()
            elseif orientation == "down" then
                turtle.digDown()
            elseif orientation == "up" then
                turtle.digUp()
            end
        end
    end
end

return {
    detectAndHarvest = detectAndHarvest
}
