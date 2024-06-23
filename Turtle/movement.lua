M = {}

M._facing = "north"

function M.turn(direction)
    if direction == "left" then
        turtle.turnLeft()
        if M._facing == "north" then
            M._facing = "west"
        elseif M._facing == "west" then
            M._facing = "south"
        elseif M._facing == "south" then
            M._facing = "east"
        elseif M._facing == "east" then
            M._facing = "north"
        end
    elseif direction == "right" then
        turtle.turnRight()
        if M._facing == "north" then
            M._facing = "east"
        elseif M._facing == "east" then
            M._facing = "south"
        elseif M._facing == "south" then
            M._facing = "west"
        elseif M._facing == "west" then
            M._facing = "north"
        end
    end
end

function M.moveNorth()
    if M._facing == "north" then
        -- Do nothing
    elseif M._facing == "west" then
        M.turn("right")
    elseif M._facing == "south" then
        M.turn("right")
        M.turn("right")
    elseif M._facing == "east" then
        M.turn("left")
    end
    turtle.forward()
end

function M.moveEast()
    if M._facing == "north" then
        M.turn("right")
    elseif M._facing == "west" then
        M.turn("right")
        M.turn("right")
    elseif M._facing == "south" then
        M.turn("left")
    elseif M._facing == "east" then
        -- Do nothing
    end
    turtle.forward()
end

function M.moveSouth()
    if M._facing == "north" then
        M.turn("right")
        M.turn("right")
    elseif M._facing == "west" then
        M.turn("left")
    elseif M._facing == "south" then
        -- Do nothing
    elseif M._facing == "east" then
        M.turn("right")
    end
    turtle.forward()
end

function M.moveWest()
    if M._facing == "north" then
        M.turn("left")
    elseif M._facing == "west" then
        -- Do nothing
    elseif M._facing == "south" then
        M.turn("right")
    elseif M._facing == "east" then
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

function getCurrentFacing()
    return M._facing
end

return M