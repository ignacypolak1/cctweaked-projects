local monitor = peripheral.find("monitor")
local offset_vector = vector.new(978, 116, 857)
local width, height

peripheral.find("modem", rednet.open)
rednet.host("turtle_gps", "master")

local visible_nodes = {}

local function screen_init()
    for y = 1, height do
        for x = 1, width do
            paintutils.drawPixel(x, y, colors.black)
            term.setCursorPos(0, 0)
        end
    end
end

local function create_frame()
    function draw(x, y, letter)
        paintutils.drawPixel(x, y, colors.gray)
        term.setCursorPos(x, y)
        term.write(letter)
        term.setCursorPos(0, 0)
    end

    paintutils.drawLine(1, 1, width, 1, colors.gray)
    paintutils.drawLine(width, 1, width, height, colors.gray)
    paintutils.drawLine(width, height, 1, height, colors.gray)
    paintutils.drawLine(1, height, 1, 1, colors.gray)

    draw(math.floor(width/2), 1, "N")
    draw(width, math.floor(height/2), "E")
    draw(1, math.floor(height/2), "W")
    draw(math.floor(width/2), height, "S")

    term.setCursorPos(0, 0)
end

local function print_center()
    paintutils.drawPixel(width / 2, height / 2, colors.white)
    term.setCursorPos(0, 0)
end
  
local function clear_screen()
    for y = 2, height - 1 do
        for x = 2, width - 1 do
            paintutils.drawPixel(x, y, colors.black)
            term.setCursorPos(0, 0)
        end
    end
end

local function stringToVector(str)
    local x, y, z = str:match("x=(%-?%d+),y=(%-?%d+),z=(%-?%d+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

local function draw_position(vec)
    vec = vector.new(math.ceil((vec.x-offset_vector.x)), math.ceil(vec.y-offset_vector.y), math.ceil((vec.z-offset_vector.z)))

    correct_x = (vec.x > -12 and vec.x <= 12)
    correct_z = (vec.z > -8 and vec.z <= 8)
    
    if (not correct_x or not correct_z) then
        return
    end

    paintutils.drawPixel((width / 2) + vec.x, (height / 2) + vec.z, colors.green)
    term.setCursorPos((width / 2) + vec.x, (height / 2) + vec.z)

    if vec.y < 0 then
        term.write("v")
    elseif vec.y > 0 then
        term.write("^")
    end

    term.setCursorPos(0, 0)
end

local function  receive_positions_task()
    while true do
        local event, sender, message, protocol = os.pullEvent("rednet_message")
        if protocol == "turtle_gps" then
            visible_nodes[sender] = message
        end
    end
end

local function main()
    term.redirect(monitor)
    monitor.setTextScale(0.5)
    width, height = term.getSize()
    
    screen_init()
    print_center()
    create_frame()
    
    parallel.waitForAny(
        receive_positions_task,
        function()
            while true do
                clear_screen()
                print_center()
                for label, pos_vec in pairs(visible_nodes) do
                    draw_position(stringToVector(pos_vec))
                end
                os.sleep(1)
            end
        end)
end

main()