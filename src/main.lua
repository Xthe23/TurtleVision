--[[ 
main.lua

This is the main execution file that ties together the turtle movement, pattern generation, and fuel management modules.

The script performs the following steps:
1. Requires the turtleMovement, patternGeneration, and fuelManager modules.
2. Generates a serpentine pattern based on specified grid dimensions using the patternGeneration module.
3. Checks the turtle's fuel level using the fuelManager module.
4. Moves the turtle according to the generated pattern using the turtleMovement module.
]]--

local turtleMovement = require("modules.turtleMovement")
local patternGeneration = require("modules.patternGeneration")
local fuelManager = require("modules.fuelManager")
-- local shared = require("modules.sharedTable") -- not used, currently but may be used in the future

local length = 3
local height = 4


-- Generate a serpentine pattern based on the specified grid dimensions
local pattern = patternGeneration.serpentine_pattern(length, height)

-- Get the last value of the last row and the first value of the first row
local lastValue, firstValue = patternGeneration.return_pattern(pattern)

-- Check fuel before moving the turtle
local isFuelSufficient = fuelManager.checkFuel(pattern, "forward")

-- Check fuel before moving the turtle according to the generated pattern
if not isFuelSufficient then
    print("Insufficient fuel to start operations. Please refuel the turtle.")
    return
end

print("Moving turtle according to the generated pattern...")
turtleMovement.moveTurtle(pattern)
print("Turtle movement completed!")

-- Check fuel before returning the turtle to the starting position
local isReturnFuelSufficient = fuelManager.checkFuel(pattern, "return")
if not isReturnFuelSufficient then
    print("Insufficient fuel to return to the starting position. Please refuel the turtle.")
    return
end
-- Move the turtle directly from the last value of the last row to the first value of the first row
turtleMovement.returnToStart(height, lastValue, firstValue)
print("Turtle returned to the starting position!")