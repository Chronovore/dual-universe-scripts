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
    local package = {}
    -- Iterate Slots
    for index, slot in pairs(unit) do
        if (type(slot) == "table" and type(slot.export) == "table" and slot.getClass) then
            local className = slot.getClass():lower()
            system.print(className .. ":" .. slot.getName())
            if (className == "industry1") then
                local slotName = slot.getName()
                if (slotName:find("Refiner")) then
                    table.insert(package, packageMachineInfo(slot, "Refining"))
                elseif (slotName:find("Smelter")) then
                    table.insert(package, packageMachineInfo(slot, "Intermediates"))
                elseif (slotName:find("Assembly")) then
                    table.insert(package, packageMachineInfo(slot, "Assembly"))
                elseif (slotName:find("Metalwork")) then
                    table.insert(package, packageMachineInfo(slot, "Intermediates"))
                end
            elseif (className == "miningunit") then
                table.insert(package, packageMineInfo(slot, "Mining"))
            end
        end
    end

    local input = json.encode(package)

    -- Update Screen
    screen.setScriptInput(input)
end

-- Initial Update
updateMachines()

-- Begin Timer for refreshes
unit.setTimer("refreshMachineData", 10)