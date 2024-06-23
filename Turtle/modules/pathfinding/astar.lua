M = {}

local movement = require("pathfinding.movement")

function M.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function M.calculateManhattan(vector1, vector2)
    return M.round(math.abs(vector2.x - vector1.x) + math.abs(vector2.y - vector1.y) + math.abs(vector2.z - vector1.z), 4)
end

function M.calculateEuclidean(vector1, vector2)
    return M.round(math.sqrt((vector2.x - vector1.x)^2 + (vector2.y - vector1.y)^2 + (vector2.z - vector1.z)^2), 4)
end

function M.getForward(vector1)
    available_neighbours = {}

    local facing = movement.getCurrentFacing()

    if not turtle.detect() then
        if facing == "north" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z-1)
        elseif facing == "south" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z+1)
        elseif facing == "east" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x+1, vector1.y, vector1.z)
        elseif facing == "west" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x-1, vector1.y, vector1.z)
        end
    end

    return available_neighbours
end

function M.getNeighbours(vector1)
    movement.setFacingNorth()

    available_neighbours = {}

    -- Detect forward/north
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z - 1)
    end
    -- Detect up
    if not turtle.detectUp() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y + 1, vector1.z)
    end
    -- Detect down
    if not turtle.detectDown() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y - 1, vector1.z)
    end

    -- Detect right/east
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x + 1, vector1.y, vector1.z)
    end
    -- Detect behind/south
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z + 1)
    end
    -- Detect left/west
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x - 1, vector1.y, vector1.z)
    end

    return available_neighbours
end

function M.getMinCostNode(open_set)
    local min_node = nil
    local min_cost = math.huge

    for node, cost in pairs(open_set) do
        if cost < min_cost then
            min_cost = cost
            min_node = node
        end
    end

    return min_node, min_cost
end

function M.compareVectors(vector1, vector2)
    if ((math.floor(vector1.x) == math.floor(vector2.x)) and (math.floor(vector1.y) == math.floor(vector2.y)) and (math.floor(vector1.z) == math.floor(vector2.z))) then
        return true
    else
        return false
    end
end

function M.vectorToString(vector)
    return ("x=%d,y=%d,z=%d"):format(vector.x, vector.y, vector.z)
end

function M.stringToVector(str)
    local x, y, z = str:match("x=(%-?%d+),y=(%-?%d+),z=(%-?%d+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

function M.start(starting_point, ending_point)
    local open_set = {}
    local close_set = {}

    local arrived = false
    local first_run = true 
    local last_cost

    while not arrived do
        local curr_x, curr_y, curr_z = gps.locate()
        local curr_vector = vector.new(math.floor(curr_x), math.floor(curr_y-0.13500), math.floor(curr_z))
        local curr_vector_string = M.vectorToString(curr_vector)

        open_set[curr_vector_string] = nil
        close_set[curr_vector_string] = true

        if (M.compareVectors(curr_vector, ending_point)) then
            movement.setFacingNorth()
            break
        end

        local neighbours = M.getForward(curr_vector) 
        if (neighbours[1] ~= nil and not first_run) then     
            local current_cost = M.calculateManhattan(curr_vector, neighbours[1]) + M.calculateEuclidean(neighbours[1], ending_point)
            
            if (current_cost < last_cost) then
                -- Do nothing
            else
                neighbours = M.getNeighbours(curr_vector)
            end
        else
            neighbours = M.getNeighbours(curr_vector)
        end

        for index, neighbour in pairs(neighbours) do
            local neighbour_key = M.vectorToString(neighbour)
            local cost = M.calculateManhattan(curr_vector, neighbour) + M.calculateEuclidean(neighbour, ending_point)
            if close_set[neighbour_key] == nil then
                if open_set[neighbour_key] == nil or cost < open_set[neighbour_key] then
                        open_set[neighbour_key] = cost
                end 
            end
        end

        local min_node_key, min_cost = M.getMinCostNode(open_set)

        if min_node_key then
            local next_vector = M.stringToVector(min_node_key)            
            movement.moveToNode(curr_vector, next_vector)
            
            first_run = false
            last_cost = min_cost
        else
            arrived = true
        end

    end
end

return M