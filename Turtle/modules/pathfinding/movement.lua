M = {}

facing = "north"

function M.turn(direction)
    if direction == "left" then
        turtle.turnLeft()
        if facing == "north" then
            facing = "west"
        elseif facing == "west" then
            facing = "south"
        elseif facing == "south" then
            facing = "east"
        elseif facing == "east" then
            facing = "north"
        end
    elseif direction == "right" then
        turtle.turnRight()
        if facing == "north" then
            facing = "east"
        elseif facing == "east" then
            facing = "south"
        elseif facing == "south" then
            facing = "west"
        elseif facing == "west" then
            facing = "north"
        end
    end
end

function M.moveNorth()
    if facing == "north" then
        -- Do nothing
    elseif facing == "west" then
        M.turn("right")
    elseif facing == "south" then
        M.turn("right")
        M.turn("right")
    elseif facing == "east" then
        M.turn("left")
    end
    turtle.forward()
end

function M.moveEast()
    if facing == "north" then
        M.turn("right")
    elseif facing == "west" then
        M.turn("right")
        M.turn("right")
    elseif facing == "south" then
        M.turn("left")
    elseif facing == "east" then
        -- Do nothing
    end
    turtle.forward()
end

function M.moveSouth()
    if facing == "north" then
        M.turn("right")
        M.turn("right")
    elseif facing == "west" then
        M.turn("left")
    elseif facing == "south" then
        -- Do nothing
    elseif facing == "east" then
        M.turn("right")
    end
    turtle.forward()
end

function M.moveWest()
    if facing == "north" then
        M.turn("left")
    elseif facing == "west" then
        -- Do nothing
    elseif facing == "south" then
        M.turn("right")
    elseif facing == "east" then
        M.turn("left")
        M.turn("left")
    end
    turtle.forward()
end

function M.moveToNode(vector1, vector2)
    if(vector1.x ~= vector2.x) then
        if(vector2.x > vector1.x) then
            return M.moveEast()
        else
            return M.moveWest()
        end
    elseif (vector1.y ~= vector2.y) then
        if (vector2.y > vector1.y) then
            return turtle.up()           
        else
            return turtle.down()
        end
    elseif (vector1.z ~= vector2.z) then
        if (vector2.z > vector1.z) then
            return M.moveSouth()
        else
            return M.moveNorth()
        end
    end
end

function M.setFacingNorth()
    if facing == "north" then
        -- Do nothing
    elseif facing == "east" then
        M.turn("left")
    elseif facing == "south" then
        M.turn("left")
        M.turn("left")
    elseif facing == "west" then
        M.turn("right")
    end    
end

return M