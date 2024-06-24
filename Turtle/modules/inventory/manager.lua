local function dropAllItems()
    for i = 1, 16 do
        turtle.select(i)
        turtle.dropDown()
    end
end

return {dropAllItems=dropAllItems}