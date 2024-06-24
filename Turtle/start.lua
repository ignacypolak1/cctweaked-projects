package.path = "modules/?.lua;" .. package.path

local movement = require("pathfinding.movement")
local pathfinder = require("pathfinding.astar")
local digging = require("digging.excavate")

function getLocation()
    local x, y, z = gps.locate()
    local starting_point = vector.new(math.floor(x), math.floor(y), math.floor(z))
    return starting_point
end

digging.excavate(4, 2)

-- local destination = vector.new(941, 130, 793)
-- local base = vector.new(956, 118, 824)

-- while fuel_level > 1000 do
--     pathfinder.start(getLocation(), destination)
    
--     if turtle then
--     pathfinder.start(getLocation(), base)
--     end
-- end

-- pathfinder.start(getLocation(), base)




