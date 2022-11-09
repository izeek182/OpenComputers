local MyInformation = "/data/Server.data"
local RegisteredMachines = "/data/Machines.data"

local tableLoader = require("tableToFile")
local comp = require("component")
local event = require("event")
local thread = require("thread")

local Logger = require("logger")
local threads = {hb = nil }
local glasses = comp.glasses
local savedMachines
local server
local modem = comp.modem


local function HeartBeat()
    while true do
        for index, host in pairs(server.KnownHosts) do
            host.receivedHB = false;
            modem.send(index, 40, "Heart")
        end
        os.sleep(10)
        for index, host in pairs(server.KnownHosts) do
            if ~(host.receivedHB) then
                Logger:error("Missing HeartBeat From " .. index)
            end
        end
    end
end

local function onADP(localAddress, remoteAddress, port, distance, ...)
    if(arg[1] == nil) then
        Logger:error("malformed ADP request from "..remoteAddress)
        error("malformed ADP request from "..remoteAddress)
    end
    if(server.KnownHosts[remoteAddress] == nil) then
        local newHost = {type = arg[1]}
        server.KnownHosts[remoteAddress] = newHost
        tableLoader.save(server, MyInformation)
        -- Logger.info("Got a ADP from " .. remoteAddress .. " on port " .. port)
    else
    end
end

local function onHeartBeat(localAddress, remoteAddress, port, distance, ...)
    if(arg[1] == nil) then
        Logger:error("malformed HB from "..remoteAddress)
        error("malformed HB from "..remoteAddress)
    end
    if(server.KnownHosts[remoteAddress] == nil) then
        Logger:error("Got a HB from an unreistered client:" .. remoteAddress .. " on port " .. port)
    else
        server.KnownHosts[remoteAddress].receivedHB = true
    end
    -- Logger.info("Got a HeartBeat from " .. remoteAddress .. " on port " .. port .. " Message:"..arg[1])
end

local function onCompMessage(localAddress, remoteAddress, port, distance, ...)
    Logger:info("Got a component Message from" .. remoteAddress .. " on port " .. port)
end

local function onGlassesMessage(localAddress, remoteAddress, port, distance, ...)
    Logger:info("Got a glasses message from" .. remoteAddress .. " on port " .. port)
end

local function onMessage(eventName, localAddress, remoteAddress, port, distance, ...)
    if port==20 then
        onADP(localAddress, remoteAddress, port, distance, arg)
    elseif port==25 then
        onHeartBeat(localAddress, remoteAddress, port, distance, arg)
    elseif port==30 then
        onCompMessage(localAddress, remoteAddress, port, distance, arg)
    elseif port==35 then
        onGlassesMessage(localAddress, remoteAddress, port, distance, arg)
    else 
        
    end
    
end

local function Init()
    --  Either intilizes the server or load the server info from file.
    Logger:init("CentralServer")
    Logger:info("Central Server Starting")
    local file = io.open(MyInformation, "r")
    if file ~= nil then
        io.close(file)
        server = tableLoader.load(MyInformation)
    else
        server = { pos = {}, KnownHosts = {}, ARProject = { en = false } }
        print("Enter Server X:")
        server.pos.x = io.read("*n")
        print("Enter Server Y:")
        server.pos.y = io.read("*n")
        print("Enter Server Z:")
        server.pos.z = io.read("*n")
        tableLoader.save(server, MyInformation)
    end
    --  Either intilizes the savedMachines or load the savedMachines info from file.
    savedMachines = io.open(RegisteredMachines, "r")
    if savedMachines ~= nil then
        io.close(savedMachines)
        savedMachines = tableLoader.load(RegisteredMachines)
    else
        savedMachines = {}
        tableLoader.save(savedMachines, RegisteredMachines)
    end
    -- intilizes a HeartBeat to all knownhosts
    if (threads.hb ~= nil) then
        threads.hb:kill()
        threads.hb = nil
    end
    threads.hb = thread.create(HeartBeat)
    threads.hb:detach()
    -- RegisterEventHandlers
    local status = event.listen("modem_message", onMessage)
    if (~(status)) then
        error("Failed to register listener for network data")
    end
    -- Open The used Ports
    modem.open(20) -- Discovery port
    modem.open(25) -- HeartBeat port
    modem.open(30) -- Component port
    modem.open(35) -- GLasses port
end

Init()
