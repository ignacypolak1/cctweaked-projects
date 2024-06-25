package.path = "modules/?.lua;" .. package.path

local movement = require 'pathfinding.movement'
local digging = require 'digging.excavate'
local inventory = require 'inventory.manager'
local pathfinding = require 'pathfinding.astar'

local destination = vector.new(141, 119, -20)
local base = vector.new(127, 119, -10)
local fuel_level = turtle.getFuelLevel()

peripheral.find("modem", rednet.open)
local master = rednet.lookup("turtle_gps", "master")

local function vectorToString(vector)
    return ("x=%d,y=%d,z=%d"):format(vector.x, vector.y, vector.z)
end

local function sendLocation()
    while true do
        x,y,z = gps.locate()
        if(x ~= nil) then
            location = vector.new(x,y,z)
            rednet.send(master, vectorToString(location), "turtle_gps")
            sleep(1) 
        end
    end 
end

parallel.waitForAny(
    sendLocation,
    function()
        while (fuel_level > 1000) do
            pathfinding.start(movement, destination)
            digging.excavate(movement, 4, 5)
            pathfinding.start(movement, base)
            inventory.dropAllItems()
         end
         pathfinding.start(movement, base)
    end
)





