local Logger = {
    Class = "Unintilized",
    local_Log = true,
    localhost = {Name = 1}
    }

require("netDefs")
local l2    = require("l2")
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
    print(_NetDefs.portEnum.logger)
    self.localhost = l2.createHost(self.Class.."_Logger",_NetDefs.portEnum.logger,nil)
end

---Log error level data
---@param Message string
function Logger:error(Message)
    if(self.localhost.active == true) then
        self.localhost:send("LOGGER", self.Class,_NetDefs.loggerEnum.error,Message)
    end

    if(self.local_Log) then
        print(self.Class..":Error:"..Message)
    end

end

---Log info level data
---@param Message string
function Logger:info(Message)
    if(self.localhost.active == true) then
        self.localhost:send("LOGGER", self.Class,_NetDefs.loggerEnum.info,Message)
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

return Logger