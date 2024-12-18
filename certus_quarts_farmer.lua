local dropInterval = 300 -- Time interval to drop items (in seconds)
local lastDropTime = os.clock() -- Initialize the last drop time

while true do
    -- Check the block in front
    local success, data = turtle.inspect()

    if success and data.name == "ae2:quartz_cluster" then
        -- If the block is a quartz cluster, mine it
        print("Quartz cluster detected! Mining...")
        turtle.dig()
    end

    -- Check if it's time to drop inventory
    if os.clock() - lastDropTime >= dropInterval then
        print("Dropping inventory into the block below...")
        for slot = 1, 16 do
            turtle.select(slot) -- Select each slot
            turtle.dropDown()   -- Drop items into the block below
        end
        turtle.select(1) -- Reset to the first slot
        lastDropTime = os.clock() -- Update the last drop time
    end

    -- Wait for a short period before checking again
    sleep(0.5)
end
