package.path = "modules/?.lua;" .. package.path

local pathfinder = require("pathfinding.astar")
-- local digging = require("digging.excavate")
-- local invmanager = require("inventory.manager")

function getLocation()
    local x, y, z = gps.locate()
    local starting_point = vector.new(math.floor(x), math.floor(y), math.floor(z))
    return starting_point
end

local destination = vector.new(941, 130, 793)
local base = vector.new(956, 118, 824)
local fuel_level = turtle.getFuelLevel()

while (fuel_level > 1000) do
    pathfinder.start(getLocation(), destination)
    -- digging.excavate(3,20)
    pathfinder.start(getLocation(), base)
    -- invmanager.dropAllItems()
end
pathfinder.start(getLocation(), base)




