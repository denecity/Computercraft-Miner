veinMoves = {}

mode = 1

distance = 0

chunk = 15
loader = 15
start = 0

turtle.select(1)
turtle.refuel()
turtle.digDown()

function mine()
    while true do
        for i=1, 16, 1 do
                saveForward()
                search()
        end
        chunkload()
        fuel()
        ender()
    end
end

function saveForward()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.digUp()
    turtle.forward()
    distance = distance + 1
end


function ender()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.select(13)
    turtle.place()
    for i=1, 12, 1 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(13)
    turtle.dig()
    turtle.select(1)
end


function chunkload()
    turtle.digDown()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.select(chunk) -- select chunkloader
    turtle.placeDown()   -- place chunkloader
    turtle.select(1) -- reset
    if loader == 15 then
        turtle.select(16) -- select ender
        turtle.place() -- place ender
        turtle.suck(1)
        turtle.dropDown(1)
        turtle.dig()
        turtle.select(1) -- reset
    end
    if loader == 16 then
        turtle.select(16) --select ender
        turtle.place() -- place ender
        turtle.suck(1)
        turtle.dropDown(1)
        loader = 0
        turtle.dig()
        turtle.select(1) -- reset
    end
    loader = loader + 1
    turtle.turnLeft()
    turtle.turnLeft()

    for i=1, 16, 1 do
        turtle.forward()
    end

    if chunk == 15 then
        chunk = 14
    elseif chunk == 14 then
        chunk = 15
    end

    turtle.select(chunk) -- select chunkloader 2
    if start == 0 then
        turtle.drop()
    else
        start = 0
    end
    turtle.digDown() -- get chunkloader 2

    turtle.turnLeft()
    turtle.turnLeft()

    for i=1, 16, 1 do
        turtle.forward()
    end
    turtle.select(1) -- reset
end



function veinTurnLeft()
    table.insert(veinMoves, 1)
    turtle.turnLeft()
end

function veinMoveForward()
    table.insert(veinMoves, 2)
    turtle.forward()
end

function veinMoveUp()
    table.insert(veinMoves, 3)
    turtle.up()
end

function veinMoveDown()
    table.insert(veinMoves, 4)
    turtle.down()
end


function veinReverse()
    if veinMoves[#veinMoves - 2] == 1 and veinMoves[#veinMoves - 1] == 1 and veinMoves[#veinMoves] == 1 then
        turtle.turnLeft()
        table.remove(veinMoves)
        table.remove(veinMoves)
        table.remove(veinMoves)
    elseif veinMoves[#veinMoves] == 1 then
        turtle.turnRight()
        table.remove(veinMoves)
    elseif veinMoves[#veinMoves] == 2 then
        turtle.back()
        table.remove(veinMoves)
    elseif veinMoves[#veinMoves] == 3 then
        turtle.down()
        table.remove(veinMoves)
    elseif veinMoves[#veinMoves] == 4 then
        turtle.up()
        table.remove(veinMoves)
    end
end



function mineMove(direction)-- 1=up, 2=forward, 3=down
    if direction == 1 then
        turtle.digUp()
        veinMoveUp()
    elseif direction == 3 then
        turtle.digDown()
        veinMoveDown()
    elseif direction == 2 then
        while turtle.detect() do
            turtle.dig()
        end
        veinMoveForward()
    else
        print("no direction input (minemove)")
    end
    return search()
end



function search()
    success, block = turtle.inspectUp()
    if block.name ~= nil and string.find(block.name, "ore") then
        mode = 2
        return mineMove(1)
    end

    success, block = turtle.inspectDown()
    if block.name ~= nil and string.find(block.name, "ore") then
        mode = 2
        return mineMove(3)
    end

    success, block = turtle.inspect()
    if block.name ~= nil and string.find(block.name, "ore") then
        mode = 2
        return mineMove(2)
    end

    veinTurnLeft()
    success, block = turtle.inspect()
    if block.name ~= nil and string.find(block.name, "ore") then
        mode = 2
        return mineMove(2)
    end

    veinTurnLeft()
    success, block = turtle.inspect()
    if block.name ~= nil and string.find(block.name, "ore") then
        mode = 2
        return mineMove(2)
    end

    veinTurnLeft()
    success, block = turtle.inspect()
    if block.name ~= nil and string.find(block.name, "ore") then
        mode = 2
        return mineMove(2)
    end

    if #veinMoves > 3 then
        return back()
    else
        veinTurnLeft()
        veinMoves = {}
        print("normal mining...")
        for i=1, 4, 1 do
            table.remove(veinMoves)
        end
        return
    end
end


function back()
    while veinMoves[#veinMoves] == 1 do
        veinReverse()
    end
    veinReverse()
    return search()
end


mine()
