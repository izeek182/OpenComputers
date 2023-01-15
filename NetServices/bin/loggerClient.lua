require(netDefs)
local event = require("event")
local l2    = require("l2")

local srcFilter = nil
local levelFilter = nil

local function onMessage(src, input)
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
    print(" : ".._NetDefs.loggerEnum.toString(input[2]).." : "..input[1].." : "..input[3])
end

local localhost = l2.createHost("LOGGER",_NetDefs.portEnum.logger,onMessage)
while true do os.sleep() end