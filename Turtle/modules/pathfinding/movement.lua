facing = "north"

local function turn(direction)
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

local function moveNorth()
    if facing == "north" then
        -- Do nothing
    elseif facing == "west" then
        turn("right")
    elseif facing == "south" then
        turn("right")
        turn("right")
    elseif facing == "east" then
        turn("left")
    end
    turtle.forward()
end

local function moveEast()
    if facing == "north" then
        turn("right")
    elseif facing == "west" then
        turn("right")
        turn("right")
    elseif facing == "south" then
        turn("left")
    elseif facing == "east" then
        -- Do nothing
    end
    turtle.forward()
end

local function moveSouth()
    if facing == "north" then
        turn("right")
        turn("right")
    elseif facing == "west" then
        turn("left")
    elseif facing == "south" then
        -- Do nothing
    elseif facing == "east" then
        turn("right")
    end
    turtle.forward()
end

local function moveWest()
    if facing == "north" then
        turn("left")
    elseif facing == "west" then
        -- Do nothing
    elseif facing == "south" then
        turn("right")
    elseif facing == "east" then
        turn("left")
        turn("left")
    end
    turtle.forward()
end

local function moveToNode(vector1, vector2)
    if(vector1.x ~= vector2.x) then
        if(vector2.x > vector1.x) then
            return moveEast()
        else
            return moveWest()
        end
    elseif (vector1.y ~= vector2.y) then
        if (vector2.y > vector1.y) then
            return turtle.up()           
        else
            return turtle.down()
        end
    elseif (vector1.z ~= vector2.z) then
        if (vector2.z > vector1.z) then
            return moveSouth()
        else
            return moveNorth()
        end
    end
end

local function setFacingNorth()
    if facing == "north" then
        -- Do nothing
    elseif facing == "east" then
        turn("left")
    elseif facing == "south" then
        turn("left")
        turn("left")
    elseif facing == "west" then
        turn("right")
    end    
end

return {facing=facing, turn=turn, moveNorth=moveNorth, moveEast=moveEast, moveSouth=moveSouth, moveWest=moveWest, moveToNode=moveToNode, setFacingNorth=setFacingNorth}