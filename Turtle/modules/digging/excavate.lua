local function conditionalTurn(movement, row, layer)
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

local function turnAtEndOfRow(movement, row, layer)
    conditionalTurn(movement, row, layer)

    turtle.dig()
    turtle.forward()

    conditionalTurn(movement, row, layer)
end

local function getDownUntilDetect()
    while not turtle.detectDown() do
        turtle.down()    
    end
end

local function turn180(movement)
    movement.turn("right")
    movement.turn("right")
end

local function return_procedure(starting_level)
    while math.floor(gps.locate().y) ~= starting_level do
        turtle.up()
    end
end

local function excavate(movement, square_size, relative_depth)
    
    local starting_level = math.floor(gps.locate().y)

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
                turnAtEndOfRow(movement, row, layer) 
            end 
        end
        turn180(movement)
    end

    return_procedure(starting_level)
end

return {excavate=excavate}