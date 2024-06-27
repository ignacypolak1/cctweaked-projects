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

function draw_amount(amount)
    if (amount ~= 0) then
        paintutils.drawLine(2, 1, 7, 1, colors.green)
    else
        paintutils.drawLine(2, 1, 7, 1, colors.yellow)
    end
    term.setCursorPos(3, 1)
    term.write(string.format("%04i", amount))
    term.setCursorPos(0, 0)
end

function draw_error()
    paintutils.drawLine(2, 1, 7, 1, colors.red)
    term.setCursorPos(3, 1)
    term.write("ERRO")
    term.setCursorPos(0, 0)
end

function get_ores()
    ores = scanner.scan(12)
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

function get_chunk()
    results = scanner.chunkAnalyze()
    found = false
    if (results ~= nil) then
        for ore_name, ore_amount in pairs(results) do
            if (string.find(ore_name, filter)) then
                draw_amount(ore_amount)
                found = true
            end
        end
        if (found == false) then
            draw_amount(0)
        end
    else
        draw_error()
    end
end

function process_manager()
    while true do
        get_chunk()
        for i=1,4 do
            os.sleep(2.1)
            get_ores()
        end
        os.sleep(2.1)
    end
end

function main()
    screen_init()
    create_frame()
    print_player()
    process_manager()
end

main()