-- Optimized Turtle Tunnel Mining Script for ComputerCraft
-- Mines tunnels efficiently, manages fuel, inventory, and places torches

-- Function to manage Turtle's fuel level
function fuelLevel()
    if turtle.getFuelLevel() < 1000 then
        turtle.select(1)
        turtle.refuel(8)
        print("Refueled")
    end
end

-- Function to mine a block in front, above, and optionally below
function mineBlock()
    if turtle.detect() then
        turtle.dig()
        sleep(0.5)
    end
    turtle.forward()
    if turtle.detectUp() then
        turtle.digUp()
        sleep(0.5)
    end
end

-- Function to handle inventory management by depositing items into a chest
function checkInventory()
    if turtle.getItemCount(16) > 0 then
        turtle.back()
        turtle.down()
        if turtle.detectDown() then
            turtle.digDown()
        end
        turtle.select(3)
        turtle.placeDown()
        for i = 4, 16 do
            turtle.select(i)
            turtle.dropDown()
        end
        turtle.select(2)
        turtle.up()
        turtle.forward()
    end
end

-- Function to place torches at intervals
function placeTorch()
    turtle.select(2)
    turtle.placeDown()
end

-- Function to mine a straight line of specified length
function mineLine(length)
    for _ = 1, length do
        fuelLevel()
        checkInventory()
        mineBlock()
    end
end

-- Prompt user for setup instructions
print("Place fuel in slot 1, torches in slot 2, and chests in slot 3!")
print("How wide will the tunnel be?")
local tunnelWidth = tonumber(read())

-- Main mining loop
placeTorch()
while true do
    for _ = 1, 9 do
        -- Mine the central path
        mineLine(1)

        -- Mine side paths based on tunnel width
        if tunnelWidth > 1 then
            turtle.turnLeft()
            mineLine(math.floor((tunnelWidth - 1) / 2))
            turtle.turnRight()
            turtle.turnRight()
            mineLine(tunnelWidth - 1)
            turtle.turnLeft()
            turtle.turnLeft()
            mineLine(math.floor((tunnelWidth - 1) / 2))
            turtle.turnRight()
        end
    end

    -- Place torch every 9 blocks
    placeTorch()
end
