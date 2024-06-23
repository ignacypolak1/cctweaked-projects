package.path = "modules/?.lua;" .. package.path
pathfinder = require("pathfinding.astar")

function getLocation()
    local x, y, z = gps.locate()
    local starting_point = vector.new(math.floor(x), math.floor(y), math.floor(z))
    return starting_point
end

local destination = vector.new(941, 130, 793)
local base = vector.new(956, 118, 824)

pathfinder.start(getLocation(), destination)
pathfinder.start(getLocation(), base)