local Manager = {}

local tableLoader = require("tableToFile")
local glasses = require("glasses")

local fileName = "/data/Machines.data"
local alpha = 0.15
local machineVisuals = {}
local tempMachineVisual = {}

Manager.machines = tableLoader.load(fileName)


function Manager:addMachine(ID,m)
    m = glasses.getRelative(m)
    self.machines[ID] = m
end

function Manager:showTempMachine(m,color)
    m = glasses.getRelative(m)
    tempMachineVisual = glasses.buildBoxWithLable(m)
    glasses.showObject(tempMachineVisual,color)
end

function Manager:removeTempMachine()
    if not tempMachineVisual == {} then
        glasses.deleteObject(tempMachineVisual)
        tempMachineVisual = {}
    end
end

function Manager:showMachine(ID,color)
    if not machineVisuals[ID] then
        machineVisuals[ID] = glasses.buildBoxWithLable(self.machines[ID])
    end
    glasses.showObject(machineVisuals[ID],color)
end

function Manager:hideMachine(ID)
    if machineVisuals[ID] then
        glasses.hideObject(machineVisuals[ID])
    end
end

function Manager:displayAllSaved(color) 
    for index in pairs(self.machines) do
        self:ShowMachine(index,color)
    end
end

function Manager:hideAllSaved() 
    for index in pairs(self.machines) do
        self:hideMachine(index)
    end
end

function Manager:SaveToFile()
    tableLoader.save(self.machines,fileName)
end

function Manager:LoadFromFile()
    self.machines = tableLoader.load(fileName)
end

return Manager