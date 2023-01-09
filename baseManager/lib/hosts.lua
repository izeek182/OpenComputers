local hosts = {}
local Logger = require("logger")
local net    = require("netCore")


function hosts:init(class,local_Log)
    Logger:init("hosts.lua",false)
    Logger:info("Init hosts")
end

function hosts.new(uuid,remoteType)
    local self = {}
    self.uuid = uuid
    self.HB = _NetDefs.hbEnum.overdue
    self.type = remoteType
    return self
end

local function sendHB(host)
    net.send(host.uuid,_NetDefs.portEnum.heartBeat,_NetDefs.START)
end

function hosts.heartBeat(host)
    sendHB(host)
    -- Mark the status as waiting if live, and dead if still waiting
    host.HB = host.HB + 1
    if(host.HB > _NetDefs.hbEnum.overdue) then
        host.HB = _NetDefs.hbEnum.overdue
    end
end

function hosts.receivedHB(host)
    -- Its alive again :)
    host.HB = _NetDefs.hbEnum.live
end

return hosts