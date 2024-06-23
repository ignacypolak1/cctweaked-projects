local movement = require("movement")

function calculateManhattan(vector1, vector2)
    return math.abs(vector2.x - vector1.x) + math.abs(vector2.y - vector1.y) + math.abs(vector2.z - vector1.z)
end

function getNeighbours(vector1)
    movement.setFacingNorth()

    available_neighbours = {}

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
    -- Detect forward/north
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z - 1)
    end

    return available_neighbours
end

function getMinCostNode(open_set)
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

function compareVectors(vector1, vector2)
    if ((vector1.x == vector2.x) and (vector1.y == vector2.y) and (vector1.z == vector2.z)) then
        return true
    else
        return false
    end
end

function vectorToString(vector)
    return ("x=%d,y=%d,z=%d"):format(vector.x, vector.y, vector.z)
end

function stringToVector(str)
    local x, y, z = str:match("x=(%-?%d+),y=(%-?%d+),z=(%-?%d+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

function main(starting_point, ending_point)
    local open_set = {}
    local close_set = {}

    local arrived = false
    local starting_heuristics = math.floor(calculateManhattan(starting_point, ending_point))

    while not arrived do
        local curr_x, curr_y, curr_z = gps.locate()
        local curr_vector = vector.new(math.floor(curr_x), math.floor(curr_y), math.floor(curr_z))

        if (compareVectors(curr_vector, ending_point)) then
            break
        end

        local current_neighbours_nodes = {}

        close_set[#close_set + 1] = curr_vector
        open_set[vectorToString(curr_vector)] = nil

        local neighbours = getNeighbours(curr_vector)

        for index, neighbour in pairs(neighbours) do
            local vector_key = vectorToString(neighbour)
            local cost = calculateManhattan(curr_vector, neighbour)
                + calculateManhattan(neighbour, ending_point)

            if open_set[vector_key] == nil or cost < open_set[vector_key] then
                open_set[vector_key] = cost
            end

            current_neighbours_nodes[vector_key] = cost
        end

        local min_node_key, min_cost = getMinCostNode(current_neighbours_nodes)
        if min_node_key then
            local next_vector = stringToVector(min_node_key)
            movement.moveToNode(curr_vector, next_vector)
        else
            arrived = true
        end
    end
end
