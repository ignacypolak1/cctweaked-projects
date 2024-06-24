local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function calculateManhattan(vector1, vector2)
    return round(math.abs(vector2.x - vector1.x) + math.abs(vector2.y - vector1.y) + math.abs(vector2.z - vector1.z), 4)
end

local function calculateEuclidean(vector1, vector2)
    return round(math.sqrt((vector2.x - vector1.x)^2 + (vector2.y - vector1.y)^2 + (vector2.z - vector1.z)^2), 4)
end

local function getForward(movement, vector1)
    available_neighbours = {}
    if not turtle.detect() then
        if movement.facing == "north" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z-1)
        elseif movement.facing == "south" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z+1)
        elseif movement.facing == "east" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x+1, vector1.y, vector1.z)
        elseif movement.facing == "west" then
            available_neighbours[#available_neighbours + 1] = vector.new(vector1.x-1, vector1.y, vector1.z)
        end
    end
    return available_neighbours
end

local function getNeighbours(movement, vector1)
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
    -- Detect left/west
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x - 1, vector1.y, vector1.z)
    end
    -- Detect behind/south
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x, vector1.y, vector1.z + 1)
    end
    -- Detect right/east
    movement.turn("left")
    if not turtle.detect() then
        available_neighbours[#available_neighbours + 1] = vector.new(vector1.x + 1, vector1.y, vector1.z)
    end

    return available_neighbours
end

local function getMinCostNode(open_set)
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

local function compareVectors(vector1, vector2)
    if ((math.floor(vector1.x) == math.floor(vector2.x)) and (math.floor(vector1.y) == math.floor(vector2.y)) and (math.floor(vector1.z) == math.floor(vector2.z))) then
        return true
    else
        return false
    end
end

local function vectorToString(vector)
    return ("x=%d,y=%d,z=%d"):format(vector.x, vector.y, vector.z)
end

local function stringToVector(str)
    local x, y, z = str:match("x=(%-?%d+),y=(%-?%d+),z=(%-?%d+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

local function start(movement, ending_point)
    local open_set = {}
    local close_set = {}

    local arrived = false
    local first_run = true 
    local last_cost

    while not arrived do
        open_set = {}
        
        local curr_x, curr_y, curr_z = gps.locate()
        local curr_vector = vector.new(math.floor(curr_x), math.floor(curr_y-0.13500), math.floor(curr_z))
        local curr_vector_string = vectorToString(curr_vector)

        open_set[curr_vector_string] = nil
        close_set[curr_vector_string] = true

        if (compareVectors(curr_vector, ending_point)) then
            movement.setFacingNorth()
            break
        end

        local neighbours = getForward(movement, curr_vector) 
        if (neighbours[1] ~= nil and not first_run) then     
            local current_cost = calculateManhattan(curr_vector, neighbours[1]) + calculateEuclidean(neighbours[1], ending_point)

            if (current_cost < last_cost) then
                -- Do nothing
            else
                neighbours = getNeighbours(movement, curr_vector)
            end
        else
            neighbours = getNeighbours(movement, curr_vector)
        end

        for index, neighbour in pairs(neighbours) do
            local neighbour_key = vectorToString(neighbour)
            local cost = calculateManhattan(curr_vector, neighbour) + calculateEuclidean(neighbour, ending_point)
            if close_set[neighbour_key] == nil then
                if open_set[neighbour_key] == nil or cost < open_set[neighbour_key] then
                        open_set[neighbour_key] = cost
                end 
            end
        end
        
        local min_node_key, min_cost = getMinCostNode(open_set)

        if min_node_key then
            local next_vector = stringToVector(min_node_key)            
            movement.moveToNode(curr_vector, next_vector)
            
            first_run = false
            last_cost = min_cost
        else
            arrived = true
        end

    end
end

return {start=start}