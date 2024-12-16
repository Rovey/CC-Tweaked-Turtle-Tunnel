-- Chunk Miner for Mining Turtle (16x16 area)
-- Designed for CC:Tweaked
-- Ensure the turtle has fuel and a chest is placed at the starting point for deposits.

-- Constants
local CHUNK_SIZE = 16

-- Functions
local function refuel()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.refuel(0) then
            turtle.refuel()
            print("Refueled using slot " .. i)
        end
    end
end

local function ensureFuel()
    if turtle.getFuelLevel() == "unlimited" then return end
    while turtle.getFuelLevel() < 100 do
        print("Low on fuel, attempting to refuel...")
        refuel()
        if turtle.getFuelLevel() < 100 then
            print("Please add fuel to the turtle and press any key to continue.")
            os.pullEvent("key")
        end
    end
end

local function depositItems()
    for i = 1, 16 do
        turtle.select(i)
        if not turtle.refuel(0) then -- Only drop items that are NOT fuel
            turtle.drop()
        end
    end
    turtle.select(1) -- Reset to the first slot
end

local function isInventoryFull()
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false -- Found an empty slot, inventory is not full
        end
    end
    return true -- All slots are filled
end

local function returnToStart()
    print("Returning to start position...")
    turtle.turnLeft()
    turtle.turnLeft() -- Turn around
    for i = 1, CHUNK_SIZE - 1 do
        turtle.forward()
    end
    turtle.turnRight()
    for i = 1, CHUNK_SIZE - 1 do
        turtle.forward()
    end
    turtle.turnRight()
end

local function returnToLayer(row, col)
    print("Returning to previous position...")
    for i = 1, row - 1 do
        turtle.forward()
    end
    if row % 2 == 1 then
        for i = 1, col - 1 do
            turtle.forward()
        end
    else
        for i = 1, CHUNK_SIZE - col do
            turtle.forward()
        end
    end
end

local function digAndMoveForward()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()
end

local function digAndMoveDown()
    while turtle.detectDown() do
        turtle.digDown()
    end
    turtle.down()
end

local function digAndMoveUp()
    while turtle.detectUp() do
        turtle.digUp()
    end
    turtle.up()
end

local function mineLayer()
    for row = 1, CHUNK_SIZE do
        for col = 1, CHUNK_SIZE - 1 do
            digAndMoveForward()
            -- Check if inventory is full after every block
            if isInventoryFull() then
                print("Inventory full! Returning to deposit items...")
                returnToStart() -- Go back to the starting position
                depositItems()  -- Deposit items
                returnToLayer(row, col) -- Resume where it left off
            end
        end
        if row < CHUNK_SIZE then
            if row % 2 == 1 then
                turtle.turnRight()
                digAndMoveForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                digAndMoveForward()
                turtle.turnLeft()
            end
        end
    end
end

local function repositionToStartOfLayer()
    print("Repositioning to the starting corner of the new layer...")
    turtle.turnRight()

    -- Move back to the starting block
    for i = 1, CHUNK_SIZE - 1 do
        digAndMoveForward()
    end

    -- Align with the start of the chunk again
    turtle.turnRight()
end

local function mineChunk()
    ensureFuel()
    for depth = 1, 256 do
        print("Mining layer " .. depth)
        mineLayer()
        if depth < 256 then
            -- Move down to the next layer
            digAndMoveDown()
            -- Reposition to the bottom-left corner and face north
            repositionToStartOfLayer()
        end
    end
    print("Returning to surface...")
    for i = 1, 255 do
        digAndMoveUp()
    end
    print("Final deposit...")
    depositItems()
    print("Chunk mining complete!")
end

-- Main Program
print("Starting chunk miner...")
print("Ensure there is enough fuel and a chest for item deposits.")
mineChunk()