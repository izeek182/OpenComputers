local Logger = {Class = "Unintilized"}
local comp = require("component")
local modem = comp.modem

---intilizes the class
---@param class string
function Logger:init(class)
    self.Class = class
end

---Log error level data
---@param Message string
function Logger:error(Message)
    modem.broadcast(8008, self.Class,Message)
    print(self.Class..":Error:"..Message)
end

---Log info level data
---@param Message string
function Logger:info(Message)
    modem.broadcast(8007, self.Class,Message)
    print(self.Class..":Info :"..Message)
end

return Logger