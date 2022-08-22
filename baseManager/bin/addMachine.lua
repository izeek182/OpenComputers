local term = {x=-60,y=57,z=115}
local zOffset = 0.01
local fileName = "/data/Machines.data"
local alpha = 0.15

local tableLoader = require("tableToFile")
local comp = require("component")
local glasses = comp.glasses
local connectedMachines = comp.list("gt_machine")
local savedMachines = tableLoader.load(fileName)

local function displayHighlight(mIn,color)
    local m = {min = {},max = {}}
    m.min.x = mIn.min.x-zOffset
    m.min.y = mIn.min.y-zOffset
    m.min.z = mIn.min.z-zOffset
    m.max.x = mIn.max.x+zOffset
    m.max.y = mIn.max.y+zOffset
    m.max.z = mIn.max.z+zOffset

    local vertexes = {{},{},{},{},{},{}}
    vertexes[1] = {m.min.x,m.min.y,m.min.z}
    vertexes[2] = {m.min.x,m.min.y,m.max.z}
    vertexes[3] = {m.min.x,m.max.y,m.min.z}
    vertexes[4] = {m.min.x,m.max.y,m.max.z}

    vertexes[5] = {m.max.x,m.min.y,m.min.z}
    vertexes[6] = {m.max.x,m.min.y,m.max.z}
    vertexes[7] = {m.max.x,m.max.y,m.min.z}
    vertexes[8] = {m.max.x,m.max.y,m.max.z}

    local sides = {{1,2,3,4},{5,6,7,8},{1,2,5,6},{3,4,7,8},{1,3,5,7},{2,4,6,8}}

    for i = 1, 6 do
        local side = glasses.addQuad3D()
        for j = 1, 4 do
            local vert = sides[i][j]
			local x,y,z
			x = vertexes[vert][1]
			y = vertexes[vert][2]
			z = vertexes[vert][3]
            side.setVertex(j,x,y,z)
            side.setColor(color.r,color.g,color.b)
            side.setAlpha(color.a)
            side.setVisibleThroughObjects(false)
        end
    end
    local core = {x=0,y=0,z=0}
    core.x = (m.min.x + m.max.x)/2
    core.y = (m.min.y + m.max.y)/2
    core.z = (m.min.z + m.max.z)/2
    
    local dot = glasses.addDot3D()
    dot.set3DPos(core.x,core.y,core.z)
    dot.setColor(color.r,color.g,color.b)
    dot.setAlpha(0.75)
    dot.setVisibleThroughObjects(true)
    if mIn.name then
        local text = glasses.addFloatingText()
        text.setText(mIn.name)
        text.set3DPos(core.x,core.y+0.5,core.z)
        text.setColor(color.r,color.g,color.b)
        text.setAlpha(0.75)
        text.setVisibleThroughObjects(true)
    end
end

local function displayAllSaved() 
    for index, m in pairs(savedMachines) do
        displayHighlight(m,{r=0,g=0,b=1,a=alpha})
    end
end

local function getCoords(index) 
    local m = {min = {x=0,y=0,z=0}, max = {x=1,y=1,z=1}}
    local done = false
    while not done do 
        print("Enter min X:")
        m.min.x = io.read("*n")-term.x
        print("Enter min Y:")
        m.min.y = io.read("*n")-term.y
        print("Enter min Z:")
        m.min.z = io.read("*n")-term.z
        
        print("Enter max X:")
        m.max.x = io.read("*n")-term.x+1
        print("Enter max Y:")
        m.max.y = io.read("*n")-term.y+1
        print("Enter max Z:")
        m.max.z = io.read("*n")-term.z+1
        
        glasses.removeAll()
        displayAllSaved()
        displayHighlight(m,{r=1,g=0,b=0,a=alpha})
        print("Enter 1 if the whole machine is highlighted")
        local s = io.read("*n")
        if s > 0 then
            done = true
        end
    end
    return m
end

glasses.removeAll()

for index in pairs(connectedMachines) do
    local m;
    if savedMachines[index] and savedMachines[index].name then
        print("Machine "..savedMachines[index].name.." with ID"..index.." mapped")
    elseif savedMachines[index] then
        print("ID:"..index.." Found but has no Name")
        glasses.removeAll()
        displayAllSaved()
        displayHighlight(savedMachines[index],{r=0,g=1,b=0,a=alpha})
        print("Find enter the name of the green machine:")
        savedMachines[index].name = io.read()
    else
        print("Machine "..index.." "..connectedMachines[index].." Not mapped")
        savedMachines[index] = getCoords(index)
        print("Enter the name of the new machine:")
        savedMachines[index].name = io.read()
    end
end
displayAllSaved()
tableLoader.save(savedMachines,fileName)


