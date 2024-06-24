package.path = "modules/?.lua;" .. package.path

local movement = require 'pathfinding.movement'
local digging = require 'digging.excavate'
local inventory = require 'inventory.manager'
local pathfinding = require 'pathfinding.astar'

function getLocation()
    local x, y, z = gps.locate()
    local starting_point = vector.new(math.floor(x), math.floor(y), math.floor(z))
    return starting_point
end

local destination = vector.new(941, 130, 793)
local base = vector.new(956, 118, 824)
local fuel_level = turtle.getFuelLevel()

while (fuel_level > 1000) do
   pathfinding.start(movement, destination)
   digging.excavate(movement, 4, 20)
   pathfinding.start(movement, base)
   inventory.dropAllItems()
end

pathfinding.start(getLocation(), base)




