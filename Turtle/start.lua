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

local destination = vector.new(141, 119, -20)
local base = vector.new(127, 119, -10)
local fuel_level = turtle.getFuelLevel()

while (fuel_level > 1000) do
   pathfinding.start(movement, destination)
   digging.excavate(movement, 4, 5)
   pathfinding.start(movement, base)
   inventory.dropAllItems()
end

pathfinding.start(movement, base)




