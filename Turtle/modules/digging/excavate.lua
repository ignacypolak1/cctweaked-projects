M = {}

local movement = require("pathfinding.movement")

function conditionalTurn(row, layer)
    if layer % 2 == 0 then
        if row % 2 == 0 then
            movement.turn("right")    
        else
            movement.turn("left")
        end
    else
        if row % 2 == 0 then
            movement.turn("left")    
        else
            movement.turn("right")
        end    
    end
end

function turnAtEndOfRow(row, layer)
    conditionalTurn(row, layer)

    turtle.dig()
    turtle.forward()

    conditionalTurn(row, layer)
end

function getDownUntilDetect()
    while not turtle.detectDown() do
        turtle.down()    
    end
end

function turn180()
    movement.turn("right")
    movement.turn("right")
end

function M.excavate(square_size, relative_depth)
    movement.setFacingNorth()
    movement.turn("right")
    
    getDownUntilDetect()
    
    for layer=1, relative_depth do
        
        if turtle.getFuelLevel() < 1000 then
            break
        end

        turtle.digDown()
        turtle.down()

        for row=1, square_size do            
            for col=1, square_size-1 do
                turtle.dig()
                turtle.forward()
            end
            if(row ~= square_size) then
                turnAtEndOfRow(row, layer) 
            end 
        end
        turn180()
    end
end

return M