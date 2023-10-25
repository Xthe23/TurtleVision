--[[ 
main.lua

This is the main execution file that ties together the turtle movement, pattern generation, and fuel management modules.

The script performs the following steps:
1. Requires the turtleMovement, patternGeneration, and fuelManager modules.
2. Generates a serpentine pattern based on specified grid dimensions using the patternGeneration module.
3. Checks the turtle's fuel level using the fuelManager module.
4. Moves the turtle according to the generated pattern using the turtleMovement module.
]]--

local turtleMovement = require("turtleMovement")
local patternGeneration = require("patternGeneration")
local fuelManager = require("fuelManager")

local length = 3
local height = 2

local pattern = patternGeneration.serpentine_pattern(length, height)

-- Check fuel before moving the turtle
local isFuelSufficient = fuelManager.checkFuel(length, height, "forward")

if not isFuelSufficient then
    print("Insufficient fuel to start operations. Please refuel the turtle.")
    return
end

print("Moving turtle according to the generated pattern...")
turtleMovement.moveTurtle(pattern)
print("Turtle movement completed!")
