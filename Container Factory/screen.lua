local json = require("dkjson")

-- Constants
local fontSize = 16
local font = loadFont('Play', fontSize)
local fontHeaderSize = 2 * fontSize
local fontHeader = loadFont('Play', fontHeaderSize)
local layer = createLayer()
local colorWhite = { r = 1, g = 1, b = 1 }
local colorRed = { r = 1, g = 0, b = 0 }
local colorYellow = { r = 1, g = 1, b = 0 }
local colorGreen = { r = 0, g = 1, b = 0 }
local statusNames = {
    [1] = { text = "Stopped", color = colorYellow },
    [2] = { text = "Running", color = colorGreen },
    [3] = { text = "Input Missing", color = colorRed },
    [4] = { text = "Output Full", color = colorYellow },
    [5] = { text = "No Output Container", color = colorRed },
    [6] = { text = "Pending", color = colorYellow },
    [7] = { text = "No Schematics", color = colorRed }
}
local machineRenderHeight = 2 * 2 * fontSize + 2 * 2
local mineRenderHeight = machineRenderHeight + machineRenderHeight
local machineRenderWidth = 200

-- Render Methods
function writeTextLine(text, x, y, color, font, fontSize)
    if (color) then        
        setNextFillColor(layer, color.r, color.g, color.b, 1)
    else
        text = "no color for " .. text
    end
    addText(layer, font, text or "", x, y)
    return y + fontSize
end

function renderMachineInfo(name, machineInfo, x, y)
    setNextFillColor(layer, 0.1,0.1,0.1,1)
    setNextStrokeWidth(layer, 1)
    setNextStrokeColor(layer, 1,1,1,1)
    if (machineInfo.remainingTime) then
        addBox(layer, x, y, machineRenderWidth, mineRenderHeight)        
    else
        addBox(layer, x, y, machineRenderWidth, machineRenderHeight)
    end
    x = x + 10
    y = y + fontSize + 2
    y = writeTextLine(name, x, y, colorWhite, font, fontSize) + 2
    y = writeTextLine(statusNames[machineInfo.state].text, x, y, statusNames[machineInfo.state].color, font, fontSize) + 2
    y = writeTextLine(machineInfo.item, x, y, colorWhite, font, fontSize) + 2
    if (machineInfo.remainingTime) then
        y = writeTextLine("Time Remaining: " .. math.floor(machineInfo.remainingTime / 60) .. "min", x, y, colorWhite, font, fontSize) + 2
        y = writeTextLine("Rate: " .. machineInfo.rate .. "/hr", x, y, colorWhite, font, fontSize) + 2
    end
end

function renderColumn(title, machineInfos, x, y, spacing, tileHeight)
    y = y + fontHeaderSize
    x = x + 10
    addText(layer, fontHeader, title, x, y)
    y = y + 10
    local index = 0
    for name, machineInfo in pairs(machineInfos) do
        renderMachineInfo(name, machineInfo, x, y + fontSize + 2 + index * tileHeight + index * spacing)
        index = index + 1
    end
end

-- Data from controller
local data = json.decode(getInput()) or {}
local assemblyColumn = {
    ["Small Assembler"] = data.smallAssembler, 
    ["Medium Assembler"] = data.containers, 
    ["Pipes"] = data.pipes
}
local refinerColumn = {
    ["Bauxite Refiner"] = data.bauxiteRefiner,
    ["Coal Refiner"] = data.coalRefiner
}
local intermediatesColumn = {
    ["Silumin Smelter"] = data.siluminSmelter
}
local minesColumn = {
    ["Coal Mine"] = data.coalMine,
    ["Bauxite Mine"] = data.bauxiteMine,
    ["Hematite Mine"] = data.hematiteMine
}

renderColumn("Assembly", assemblyColumn, 5, 0, 10, machineRenderHeight)
renderColumn("Refinery", refinerColumn, 5 + machineRenderWidth + 20, 0, 10, machineRenderHeight)
renderColumn("Intermediates", intermediatesColumn, 5 + 2 * machineRenderWidth + 2 * 20, 0, 10, machineRenderHeight)
renderColumn("Mines", minesColumn, 5 + 3 * machineRenderWidth + 3 * 20, 0, 10, mineRenderHeight)