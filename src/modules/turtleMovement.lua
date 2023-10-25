--[[ 
turtleMovement.lua

This module provides functions to control the movement of a turtle based on a given pattern.
It defines a set of turtle actions and a function to move the turtle according to a serpentine pattern.

The module exports the following main function:
1. moveTurtle: Moves the turtle based on the provided serpentine pattern. The function reads the pattern string and determines the direction and movement of the turtle. It supports moving right, moving left, turning around, and moving down.

The turtle's movement is determined by the current and next characters in the pattern. If the next character indicates a position to the right of the current position, the turtle moves right, and vice versa. If the current character is a newline, the turtle switches rows and changes direction.

The module relies on the turtle API to execute the movement commands.
]]--

-- Require the harvestDetection module
local harvestDetection = require("modules.harvestDetection")

local turtleActions = {
    moveForward = function()
        -- Detect and harvest block in front before moving forward
        harvestDetection.detectAndHarvest("minecraft:bamboo", "forward")
        turtle.forward()
    end,
    turnAround = function() turtle.turnRight(); turtle.turnRight() end,
    moveDown = function()
        -- Detect and harvest block below before moving down
        harvestDetection.detectAndHarvest("minecraft:bamboo", "down")
        turtle.down()
    end
}

--- Moves the turtle based on the provided serpentine pattern.
-- @param pattern The serpentine pattern string.

function moveTurtle(pattern)
    local direction = 1 -- 1 for moving right, -1 for moving left

    for i = 1, #pattern do
        local currentChar = pattern:sub(i, i)
        local nextChar = (i < #pattern) and pattern:sub(i + 1, i + 1) or nil
        local nextValue = nextChar and tonumber(nextChar)

        if currentChar ~= "\n" then
            local value = tonumber(currentChar)

            -- Determine the turtle's movement based on the current and next values
            if nextChar and nextValue then
                if (direction == 1 and nextValue == value + 1) or (direction == -1 and nextValue == value - 1) then
                    turtleActions.moveForward()
                end
            end
        else
            -- Switch rows if not at the end of the pattern
            if i < #pattern - 1 then
                turtleActions.moveDown()
                turtleActions.turnAround()
                direction = direction * -1 -- Toggle direction
            end
        end
    end
    if direction == -1 then
        turtleActions.turnAround()
    end
end

return {
    moveTurtle = moveTurtle
}
