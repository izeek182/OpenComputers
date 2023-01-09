local MyInformation = "/data/Server.data"
local RegisteredMachines = "/data/Machines.data"

local net           = require("netCore")
local tableLoader   = require("tableToFile")
local event         = require("event")
local thread        = require("thread")

local Logger = require("logger")
local threads = {hb=nil}
local savedMachines
local server

local function SendAPD(localAddress, remoteAddress, port, distance, ...)
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

local function onCompMessage(localAddress, remoteAddress, port, distance, ...)
    Logger:info("Got a component Message from" .. remoteAddress .. " on port " .. port)
end

local function onGlassesMessage(localAddress, remoteAddress, port, distance, ...)
    Logger:info("Got a glasses message from" .. remoteAddress .. " on port " .. port)
end

local function HeartBeat(localAddress, remoteAddress, port, distance, ...)
    if (arg[1] == nil) then
        Logger:error("malformed HB from " .. remoteAddress)
    end
    if (arg[1] == "heart") then -- We only respond to the heart part of heart beat
        net.send(remoteAddress, port, "beat")
    end
end

local function onHeartBeat(localAddress, remoteAddress, port, distance, ...)
end

local function onADP(localAddress, remoteAddress, port, distance, ...)
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
    Logger:init("CentralServer",true)
    Logger:info("Central Server Starting")
    server = io.open(MyInformation, "r")
    if server ~= nil then
        io.close(server)
        server = tableLoader.load(MyInformation)
    else
        Logger:info("First time initlizing Server Data")
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
        io.close(server)
        Logger:info("First time initlizing Server client list")
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


    net.listen(_NetDefs.portEnum.adp,onADP)
    net.listen(_NetDefs.portEnum.componantCmd,onADP)
    net.listen(_NetDefs.portEnum.heartBeat,onADP)
    -- Open The used Ports
end

Init()