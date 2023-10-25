--[[ 
patternGeneration.lua

This module provides functions to generate specific patterns based on grid dimensions.
It includes a function to determine the starting value of the last row in a grid and
another function to generate a serpentine pattern across the grid.

The module exports two main functions:
1. return_pattern: Determines the start value for the last row of a grid.
2. serpentine_pattern: Generates a serpentine pattern based on grid dimensions.

Both functions take in the length and height of the grid as parameters and return
the respective patterns or values.
]]--

--- Returns the start value for the last row based on the grid dimensions.
-- @param length The length of the grid.
-- @param height The height of the grid.
-- @return The start value for the last row.
local function return_pattern(length, height)
    if length < 1 or height < 1 then
        return "Invalid dimensions"
    end

    local result = {}
    local lastRowStartValue = height % 2 == 0 and length or 1

    for i = height, 1, -1 do
        if i == height then
            table.insert(result, tostring(lastRowStartValue))
        elseif i == 1 then
            table.insert(result, "1")
        end
    end

    return table.concat(result, "")
end

--- Generates a serpentine pattern based on the grid dimensions.
-- @param length The length of the grid.
-- @param height The height of the grid.
-- @return The serpentine pattern string.
local function serpentine_pattern(length, height)
    if length < 1 or height < 1 then
        return "Invalid dimensions"
    end

    local result = {}
    local direction = 1  -- 1 for moving right, -1 for moving left

    for i = 1, height do
        local row = {}

        if direction == 1 then
            for j = 1, length do
                table.insert(row, j)
            end
        else
            for j = length, 1, -1 do
                table.insert(row, j)
            end
        end

        table.insert(result, table.concat(row, ""))
        direction = -direction -- Toggle direction
    end

    return table.concat(result, "\n")
end

return {
    return_pattern = return_pattern,
    serpentine_pattern = serpentine_pattern
}