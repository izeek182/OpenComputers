local MyInformation = "/data/Client.data"
local RegisteredMachines = "/data/Machines.data"
local tableLoader = require("tableToFile")
local comp = require("component")
local event = require("event")
local thread = require("thread")

local Logger = require("logger")
local savedMachines
local client
local modem = comp.modem

local function onHeartBeat(localAddress, remoteAddress, port, distance, ...)
    if (arg[1] == nil) then
        Logger:error("malformed HB from " .. remoteAddress)
    end
    if (arg[1] == "heart") then -- We only respond to the heart part of heart beat
        modem.send(remoteAddress, port, "beat")
    end
end

local function onMessage(eventName, localAddress, remoteAddress, port, distance, ...)
    --really only care about Heart beat messages here
    if port == 25 then
        onHeartBeat(localAddress, remoteAddress, port, distance, arg)
    else
    end
end

local function validateServer()
    if (client.Server ~= nil) then
        modem.send(client.Server, 21, "ping")
        local _, _, from, port, _, message = event.pull(3, "modem_message")
        if (from ~= nil and message == "pong") then
            Logger:info("remote Server successfully pinged")
        else
            Logger:info("remote Server timmed out removing")
            client.Server = nil
        end
    end
    if (client.Server ~= nil) then
        Logger:info("Missing Remote Server requesing a new one")
        modem.send(client.Server, 20)
        local _, _, from, port, _, message = event.pull(3, "modem_message")
        if (from ~= nil) then
            Logger:info("remote Server successfully found")
            client.Server = from
        else
            Logger:error("No remote servers responed to ADP request")
            client.Server = nil
        end
    end

end

local function Init()
    --  Either intilizes the server or load the server info from file.
    Logger:init("GT_base_Client")
    Logger:info("intilizing client machine")
    local file = io.open(MyInformation, "r")
    if file ~= nil then
        io.close(file)
        client = tableLoader.load(MyInformation)
    else
        client = { pos = {}, Server = nil }
        print("Enter client X:")
        client.pos.x = io.read("*n")
        print("Enter client Y:")
        client.pos.y = io.read("*n")
        print("Enter client Z:")
        client.pos.z = io.read("*n")
        tableLoader.save(client, MyInformation)
    end
    
    -- Open The used Ports
    modem.open(20) -- Discovery port
    modem.open(25) -- HeartBeat port
    modem.open(30) -- Component port
    modem.open(35) -- GLasses port

    validateServer()

    -- RegisterEventHandlers
    local status = event.listen("modem_message", onMessage)
    if (~(status)) then
        error("Failed to register listener for network data")
    end

end

Init()
