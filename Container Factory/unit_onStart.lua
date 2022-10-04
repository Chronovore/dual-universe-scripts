function packageMachineInfo(machine)
    return {
        state = machine.state,
        item = system.getItem(machine.currentProducts[1].id).displayNameWithSize
    }
end

function packageMineInfo(mine)
    return {
        state = mine.getState(),
        item = system.getItem(mine.getActiveOre()).displayNameWithSize,
        remainingTime = mine.getRemainingTime(),
        rate = mine.getProductionRate()
    }
end

function updateMachines()
    -- Clear
    screen.clear()

    -- Package
    local package = {
        containers = packageMachineInfo(containerAssembler.getInfo()),
        pipes = packageMachineInfo(pipes.getInfo()),
        smallAssembler = packageMachineInfo(smallAssembler.getInfo()),
        coalRefiner = packageMachineInfo(coalRefiner.getInfo()),
        bauxiteRefiner = packageMachineInfo(bauxiteRefiner.getInfo()),
        siluminSmelter = packageMachineInfo(siluminSmelter.getInfo()),
        coalMine = packageMineInfo(coalMine),
        bauxiteMine = packageMineInfo(bauxiteMine),
        hematiteMine = packageMineInfo(hematiteMine)
    }

    local input = json.encode(package)

    -- Update Screen
    screen.setScriptInput(input)
end

-- Initial Update
updateMachines()

-- Begin Timer for refreshes
unit.setTimer("refreshMachineData", 10)