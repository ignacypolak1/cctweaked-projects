local filter = ...
local scanner = peripheral.wrap("back")

width, height = term.getSize()

function screen_init()
    for y = 1, height do
        for x = 1, width do
            paintutils.drawPixel(x, y, colors.black)
            term.setCursorPos(0, 0)
        end
    end
end

function print_player()
    paintutils.drawPixel(width / 2, height / 2, colors.white)
    term.setCursorPos(0, 0)
end

function draw_ore(x, y, z)
    correct_x = (x > -12 and x <= 12)
    correct_z = (z > -8 and z <= 8)
    if (not correct_x or not correct_z) then
        return
    end
    paintutils.drawPixel(width / 2 + x, height / 2 + z, colors.green)
    term.setCursorPos(width / 2 + x, height / 2 + z)
    if y < 0 then
        term.write("v")
    elseif y > 0 then
        term.write("^")
    end
    term.setCursorPos(0, 0)
end

function draw(x, y, letter)
    paintutils.drawPixel(x, y, colors.gray)
    term.setCursorPos(x, y)
    term.write(letter)
    term.setCursorPos(0, 0)
end

function create_frame()
    paintutils.drawLine(1, 1, 26, 1, colors.gray)
    paintutils.drawLine(26, 1, 26, 20, colors.gray)
    paintutils.drawLine(26, 20, 1, 20, colors.gray)
    paintutils.drawLine(1, 20, 1, 1, colors.gray)

    draw(13, 1, "N")
    draw(26, 10, "E")
    draw(1, 10, "W")
    draw(13, 20, "S")

    paintutils.drawPixel(26, 1, colors.red)
    paintutils.drawPixel(25, 1, colors.yellow)
    paintutils.drawPixel(24, 1, colors.blue)
    term.setCursorPos(0, 0)
end

function clear_screen()
    for y = 2, height - 1 do
        for x = 2, width - 1 do
            paintutils.drawPixel(x, y, colors.black)
            term.setCursorPos(0, 0)
        end
    end
end

function get_ores()
    ores = scanner.scan()
    if (ores ~= nil) then
        clear_screen()
        print_player()
        for index, ore in pairs(ores) do
            if (ore ~= nil) then
                if (string.find(ore.name, filter)) then
                    draw_ore(ore.x, ore.y, ore.z)
                end
            end
        end
    end
end

function process_manager()
    while true do
        get_ores()
        os.sleep(0.2)
    end
end

function main()
    screen_init()
    create_frame()
    print_player()
    process_manager()
end

main()