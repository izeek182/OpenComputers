local nanite = {port = 1,returnPort = 123,address = "",connected = false}
local component = require("component")
local m = component.modem
local event = require("event")

local function string(obj)
    if(obj == nil) then
        return "nil"
    else
        return tostring(obj)
    end
end

function nanite.open()
    m.open(nanite.returnPort)
    m.setStrength(3)
    m.broadcast(nanite.port,"nanomachines","setResponsePort",nanite.returnPort)
    local mesageType,receiverAddress,senderAddress,port,distance,arg1,arg2,arg3,arg4,arg5,arg6= event.pull(5,"modem_message")
    print("message Header: "..mesageType.." "..receiverAddress.." "..senderAddress.." "..port.." "..string(distance))
    print("message PayLoad: "..string(arg1).." "..string(arg2).." "..string(arg3).." "..string(arg4).." "..string(arg5).." "..string(arg6))
    nanite.address = senderAddress
    print("nanite address :"..nanite.address)
    nanite.connected = true
end

local function printNetworkResponce()
    local mesageType,receiverAddress,senderAddress,port,distance, arg1,arg2,arg3,arg4,arg5,arg6 = event.pull(5,"modem_message")
    print("message Header: "..string(mesageType).." "..string(receiverAddress).." "..string(senderAddress).." "..string(port).." "..string(distance))
    print("message PayLoad: "..string(arg1).." "..string(arg2).." "..string(arg3).." "..string(arg4).." "..string(arg5).." "..string(arg6))
end

local function sendCommand(command, arg1 , arg2)
    if(not nanite.connected) then
       nanite.open() 
    end
    if(arg1 ==nil) then
        m.send(nanite.address,nanite.port,command)
    else
        if(arg2==nil) then
            m.send(nanite.address,nanite.port,command,arg1)
        else
            m.send(nanite.address,nanite.port,command,arg1,arg2)
        end
    end
end

function nanite.setResponsePort(port)
    nanite.port = port
    nanite.open()
end
function nanite.getPowerState()
    sendCommand("getPowerState")
    printNetworkResponce()
end
function nanite.getHealth()
    sendCommand("getHealth")
    printNetworkResponce()
end
function nanite.getHunger()
    sendCommand("getHunger")
    printNetworkResponce()
end
function nanite.getAge()
    sendCommand("getAge")
    printNetworkResponce()
end
function nanite.getName()
    sendCommand("getName")
    printNetworkResponce()
end
function nanite.getExperience()
    sendCommand("getExperience")
    printNetworkResponce()
end
function nanite.getTotalInputCount()
    sendCommand("getTotalInputCount")
    printNetworkResponce()
end
function nanite.getSafeActiveInputs()
    sendCommand("getSafeActiveInputs")
    printNetworkResponce()
end
function nanite.getMaxActiveInputs()
    sendCommand("getMaxActiveInputs")
    printNetworkResponce()
end
function nanite.getInput(number)
    sendCommand("getInput",number)
    printNetworkResponce()
end
function nanite.setInput(number, value)
    sendCommand("setInput",number,value)
    printNetworkResponce()
end
function nanite.getActiveEffects()
    sendCommand("getActiveEffects")
    printNetworkResponce()
end
function nanite.saveConfiguration()
    sendCommand("saveConfiguration")
    printNetworkResponce()
end

return nanite