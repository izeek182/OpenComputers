local knownDetectors = {}
local unknownDetectors = {}

local function getOrigin(player)
    local numOfDetectors = #unknownDetectors;
    for i = 0,numOfDetectors do
        local players,err = unknownDetectors[i].scanPlayers()
        if(players == false) then
            print("players was false, err message?: "..err)
        else
            
        end
    end
end

local component = require("component")
for address, name in component.list("os_entdetector", true) do
    table.insert(unknownDetectors, component.proxy(address))
end

local numOfDetectors = unknownDetectors;
for i = 0,numOfDetectors do
    local players,err = unknownDetectors[i].scanPlayers()
    if(players == false) then
        print("players was false, err message?: "..err)
    else
        askCoords(players[1])
    end
end
