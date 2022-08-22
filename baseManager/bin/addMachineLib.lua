local comp = require("component")
local machineManager = require("machineManager")

local connectedMachines = comp.list("gt_machine")
local alpha = 0.15

local function getCoords(index) 
    local m = {min = {x=0,y=0,z=0}, max = {x=1,y=1,z=1}}
    local done = false
    while not done do 
        print("Enter min X:")
        m.min.x = io.read("*n")
        print("Enter min Y:")
        m.min.y = io.read("*n")
        print("Enter min Z:")
        m.min.z = io.read("*n")
        
        print("Enter max X:")
        m.max.x = io.read("*n")+1
        print("Enter max Y:")
        m.max.y = io.read("*n")+1
        print("Enter max Z:")
        m.max.z = io.read("*n")+1
        
        machineManager.displayAllSaved({r=0,g=0,b=1,a=alpha})
        machineManager.showTempMachine(m,{r=1,g=0,b=0,a=alpha})
        print("Enter 1 if the whole machine is highlighted")
        local s = io.read("*n")
        if s > 0 then
            done = true
        end
    end
    return m
end


for index in pairs(connectedMachines) do
    local m;
    if machineManager.machines[index] and machineManager.machines[index].name then
        print("Machine "..machineManager.machines[index].name.." with ID"..index.." mapped")
    elseif machineManager.machines[index] then
        print("ID:"..index.." Found but has no Name")
        machineManager.displayAllSaved({r=0,g=0,b=1,a=alpha})
        machineManager.showMachine(index,{r=0,g=1,b=0,a=alpha})
        print("Find enter the name of the green machine:")
        machineManager.machines[index].name = io.read()
    else
        print("Machine "..index.." "..connectedMachines[index].." Not mapped")
        machineManager.machines[index] = getCoords(index)
        print("Enter the name of the new machine:")
        machineManager.machines[index].name = io.read()
    end
end

machineManager.displayAllSaved()
machineManager.SaveToFile()