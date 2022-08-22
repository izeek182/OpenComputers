local glasses = {}

local tableLoader = require("tableToFile")
local comp = require("component")

local glass = comp.glasses

local fileName = "/data/Glasses.data"
local term = tableLoader.load(fileName)
local zOffset = 0.01

function glasses.getRelative(machine)
    machine.min.x = machine.min.x-term.x
    machine.min.y = machine.min.y-term.y
    machine.min.z = machine.min.z-term.z
    machine.max.x = machine.max.x-term.x
    machine.max.y = machine.max.y-term.y
    machine.max.z = machine.max.z-term.z
    return machine
end

function glasses.showObject(elements,color)
    for key, value in pairs(elements) do
        if color then
            if value.colorable then
                value.setColor(color.r,color.g,color.b)
            end
            if value.alphaable then
                value.setAlpha(color.a)
            end
        end
        value.setVisible(true)
    end
end

function glasses.hideObject(elements)
    for key, value in pairs(elements) do
        value.setVisible(false)
    end
end

function glasses.deleteObject(elements)
    for key, value in pairs(elements) do
        glass.removeObject(value.getID())
    end
end

function glasses.isObjectVisable(elements)
    return elements[1].isVisible()
end

function glasses.buildBoxWithLable(mIn)
    local elements = {}

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
        local side = glass.addQuad3D()
        for j = 1, 4 do
            local vert = sides[i][j]
			local x,y,z
			x = vertexes[vert][1]
			y = vertexes[vert][2]
			z = vertexes[vert][3]
            side.setVertex(j,x,y,z)
        end
        side.setVisibleThroughObjects(false)
        side.setVisible(false)
        side.colorable = true
        table.insert(elements,side)
    end
    local core = {x=0,y=0,z=0}
    core.x = (m.min.x + m.max.x)/2
    core.y = (m.min.y + m.max.y)/2
    core.z = (m.min.z + m.max.z)/2
    
    local dot = glass.addDot3D()
    dot.set3DPos(core.x,core.y,core.z)
    dot.setAlpha(0.75)
    dot.setVisibleThroughObjects(true)
    dot.setVisible(false)
    dot.colorable = true
    table.insert(elements,dot)

    if mIn.name then
        local text = glass.addFloatingText()
        text.setText(mIn.name)
        text.set3DPos(core.x,core.y+0.5,core.z)
        text.setColor(0,0,0)
        text.setAlpha(0.8)
        text.setVisibleThroughObjects(true)
        text.setVisible(false)
        table.insert(elements,text)
    end
    return elements
end

return glasses