local component = require("component")
local knownDetectors = {}
local unknownDetectors = {}
require("tableio")
 
local function dumpTable(table)
  local s = ""
  if(type(table)=='table') then 
    s = s .. "{"
    for key,value in pairs(table) do 
      if(type(key)~= 'number') then 
        key = '"'..key..'"'
      end
      s = s .. '['..key..'] = ' .. dumpTable(value) .. ","
    end
  else
    return s .. table
  end
  return s .. "}"
end
 
local function getOrigin()
    print("drop origin item on block in view of atleast one detector and press return")
    io.read()
    local numOfDetectors = #unknownDetectors
    local toRemove = {}
    local itemFound = false
    for i = 1,numOfDetectors do
        local ents,err = unknownDetectors[i].scanEntities()
        if(ents == false) then
            print("players was false, err message?: "..err)
        else
            print("number of entities "..#ents)
            if(#ents > 0) then
                local ent = ents[1]
                --print(dumpTable(unknownDetectors[i]))
                table.insert(knownDetectors, {x=-ent.x,y=-ent.y,z=-ent.z,address=unknownDetectors[i].address})
                table.insert(toRemove, i)
                itemFound = true
            end
        end
    end
    for i = #toRemove,1,-1 do
        table.remove(unknownDetectors,i)
    end
    print("itemFound: "..tostring(itemFound))
    if(itemFound == false) then
        print("origin item can not be found, place the item closer and press return")
        io.read()
        getOrigin()
    end
end
 
local target;
 
local function findTarget()
    --target = {x=1,z=1,z=1,name = "tim"}    
    for i = 1,#knownDetectors do 
        print("known detector "..dumpTable(knownDetectors[i]))
        local ents,err = component.proxy(knownDetectors[i].address).scanEntities()
        if(ents == false) then  
            print("Error :"..err )
        end
        if(#ents > 0) then
            local det = knownDetectors[i] 
            local ent = ents[1]
            target = {x = det.x+ent.x, y=det.y+ent.y, z=det.z+ent.z, name=ent.name}
            print("target found and it is called "..ent.name)
            print(dumpTable(target))
            break
        end
    end
end
 
local function mapDetectors()
    local remaining = #unknownDetectors
    while (remaining>0) do 
        local toRemove = {}
        print("place item on next calibration block then press return")
        io.read()
        findTarget()
        for i = 1,remaining do 
           local ents,err = unknownDetectors[i].scanEntities() 
           if(ents == false) then
              print("scan entities failed with err "..err)
           end
           if(#ents > 0) then
               local ent = ents[1]
               print("entity found: "..dumpTable(ent))
               if(ent.name == target.name) then 
                   local x = target.x - ent.x
                   local y = target.y - ent.y
                   local z = target.z - ent.z
                   table.insert(knownDetectors, {x = x , y=y,z=z,address=unknownDetectors[i].address})
                   table.insert(toRemove, i )
               end
           end
        end
        print("removing "..#toRemove.." unknown detectors")
        for i = #toRemove,1,-1 do
            table.remove(unknownDetectors,toRemove[i])
        end
        remaining = #unknownDetectors
        print(remaining.." remaining unknown detectors left.")
    end
end
 
for address, name in component.list("os_entdetector", true) do
    table.insert(unknownDetectors, component.proxy(address))
end
 
getOrigin()
mapDetectors()
print("knownDetectors")
print(dumpTable(knownDetectors))
--print(dumpTable(unknownDetectors))
table.save(knownDetectors,  "/usr/misc/knownDetectors.tbl")
local fromSave = table.load("/usr/misc/knownDetectors.tbl")
print("table loaded from file")
print(dumpTable(fromSave))
--table.save(unknownDetectors,"/usr/misc/unknownDetectors.tbl")
local numOfDetectors = #unknownDetectors
print("still unknown detectors "..numOfDetectors)
