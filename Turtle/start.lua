package.path = "modules/?.lua;" .. package.path
pathfinder = require("pathfinding.astar")

local x, y, z = gps.locate()
local starting_point = vector.new(math.floor(x), math.floor(y), math.floor(z))
local ending_point = vector.new(970, 120, 850)

pathfinder.start(starting_point, ending_point)