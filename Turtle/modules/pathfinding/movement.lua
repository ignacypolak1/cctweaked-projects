M = {}

_G.facing = "north"

function M.turn(direction)
    if direction == "left" then
        turtle.turnLeft()
        if _G.facing == "north" then
            _G.facing = "west"
        elseif _G.facing == "west" then
            _G.facing = "south"
        elseif _G.facing == "south" then
            _G.facing = "east"
        elseif _G.facing == "east" then
            _G.facing = "north"
        end
    elseif direction == "right" then
        turtle.turnRight()
        if _G.facing == "north" then
            _G.facing = "east"
        elseif _G.facing == "east" then
            _G.facing = "south"
        elseif _G.facing == "south" then
            _G.facing = "west"
        elseif _G.facing == "west" then
            _G.facing = "north"
        end
    end
end

function M.moveNorth()
    if _G.facing == "north" then
        -- Do nothing
    elseif _G.facing == "west" then
        M.turn("right")
    elseif _G.facing == "south" then
        M.turn("right")
        M.turn("right")
    elseif _G.facing == "east" then
        M.turn("left")
    end
    turtle.forward()
end

function M.moveEast()
    if _G.facing == "north" then
        M.turn("right")
    elseif _G.facing == "west" then
        M.turn("right")
        M.turn("right")
    elseif _G.facing == "south" then
        M.turn("left")
    elseif _G.facing == "east" then
        -- Do nothing
    end
    turtle.forward()
end

function M.moveSouth()
    if _G.facing == "north" then
        M.turn("right")
        M.turn("right")
    elseif _G.facing == "west" then
        M.turn("left")
    elseif _G.facing == "south" then
        -- Do nothing
    elseif _G.facing == "east" then
        M.turn("right")
    end
    turtle.forward()
end

function M.moveWest()
    if _G.facing == "north" then
        M.turn("left")
    elseif _G.facing == "west" then
        -- Do nothing
    elseif _G.facing == "south" then
        M.turn("right")
    elseif _G.facing == "east" then
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
    if _G.facing == "north" then
        -- Do nothing
    elseif _G.facing == "east" then
        M.turn("left")
    elseif _G.facing == "south" then
        M.turn("left")
        M.turn("left")
    elseif _G.facing == "west" then
        M.turn("right")
    end    
end

return M