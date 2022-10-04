function packageMachineInfo(machine, category)
    local info = machine.getInfo()
    return {
        name = machine.getName(),
        state = info.state,
        item = system.getItem(info.currentProducts[1].id).displayNameWithSize,
        category = category
    }
end

function packageMineInfo(mine, category)
    return {
        name = mine.getName(),
        state = mine.getState(),
        item = system.getItem(mine.getActiveOre()).displayNameWithSize,
        remainingTime = mine.getRemainingTime(),
        rate = mine.getProductionRate(),
        category = category
    }
end

function updateMachines()
    -- Clear
    screen.clear()
    
    -- Package
    local package = {
        packageMachineInfo(containerAssembler, "Assembly"),
        packageMachineInfo(pipes, "Assembly"),
        packageMachineInfo(smallAssembler, "Assembly"),
        packageMachineInfo(coalRefiner, "Refining"),
        packageMachineInfo(bauxiteRefiner, "Refining"),
        packageMachineInfo(siluminSmelter, "Intermediates"),
        packageMineInfo(coalMine, "Mines"),
        packageMineInfo(bauxiteMine, "Mines"),
        packageMineInfo(hematiteMine, "Mines")
    }

    local input = json.encode(package)

    -- Update Screen
    screen.setScriptInput(input)
end

-- Initial Update
updateMachines()

-- Begin Timer for refreshes
unit.setTimer("refreshMachineData", 10)