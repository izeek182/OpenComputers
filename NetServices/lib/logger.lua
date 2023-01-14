local Logger = {
    Class = "Unintilized",
    local_Log = true
    }
local comp = require("component")
local event = require("event")
local modem = comp.modem
local srcFilter = nil
local levelFilter = nil

---intilizes the class
---@param class string
function Logger:init(class,local_Log)
    self.Class = class
    if(local_Log ~= nil) then
        self.local_Log = local_Log
    else
        self.local_Log = false
    end
end

---Log error level data
---@param Message string
function Logger:error(Message)

    if(modem ~= nil) then
        modem.broadcast(_NetDefs.portEnum.logger, self.Class,_NetDefs.loggerEnum.error,Message)
    else
        print(self.Class..":Error:".."modem is nil")
    end

    if(self.local_Log) then
        print(self.Class..":Error:"..Message)
    end

end

---Log info level data
---@param Message string
function Logger:info(Message)

    if(modem ~= nil) then
        modem.broadcast(_NetDefs.portEnum.logger, self.Class,_NetDefs.loggerEnum.info,Message)
    end

    if(self.local_Log) then
        print(self.Class..":Info :"..Message)
    end
end

function Logger.SourceFilter(filter)
    srcFilter = filter
end

function Logger.LevelFilter(filter)
    levelFilter = filter
end


local function onMessage(eventName, localAddress, remoteAddress, port, distance, ...)
    --really only care about Heart beat messages here
    if(srcFilter ~= nil) then
        if(srcFilter ~= arg[1]) then
            return;
        end
    end
    if(levelFilter ~= nil) then
        if(levelFilter ~= arg[2]) then
            return;
        end
    end
    print(arg[2].." : "..arg[1].." : "..arg[3])
end

---print the all relevant network logging messages
function Logger:ActivateListener()
    modem.open(_NetDefs.portEnum.logger)
    local status = event.listen("modem_message", onMessage)
    if (~(status)) then
        print("Failed to register listener for network logging")
    end
end

return Logger