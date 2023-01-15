local event = require("event")
local l2    = require("l2")

local srcFilter = nil
local levelFilter = nil





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

local localhost = l2.createHost("LOGGER",onMessage)