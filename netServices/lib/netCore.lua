if(_Net == nil) then
    require("defs")

    local comp = require("component")
    local event = require("event")
    local Logger = require("logger")

    local modem = comp.modem

    _NetVars = {
        listeners   = {},
        pListeners  = {},
        localHosts  = {},
        DNSCache    = {},
        remoteHosts = {}
    }

    _Net = {
    }

    function _Net.listen(port,listener)
        if(_NetVars.pListeners[port] == nil) then
            if(_NetVars.listeners[port] == nil) then
                modem.open(port)
            end
            _NetVars.listeners[port] = listener;
        else

        end
    end

    function _Net.removelistener(port,listener)
        if(_NetVars.pListeners[port] == nil) then
            if(_NetVars.listeners[port] == listener) then
                _NetVars.listeners[port] = nil
                modem.close(port)
            end
        else

        end
    end

    function _Net.send(...)
        modem.send(table.unpack(arg))
    end
    
    function _Net.ping(uuid)
        _Net.send(uuid,_NetDefs.portEnum.ping,_NetDefs.START)
    end

---@diagnostic disable-next-line: unused-local
    local function onMessage(eventName, localAddress, remoteAddress, port, distance,routingMode,finalDestination, ...)
        if(routingMode == _NetDefs.routingEnum.hostName) then
            if(_NetVars.localHosts[finalDestination]~nil) then
                
            end
        end
    end

    local function onPing() 

    end

    local function init()
        Logger:init("NetCore",false)
        -- RegisterEventHandlers
        local status = event.listen("modem_message", onMessage)
        if (~(status)) then
            error("Failed to register listener for network data")
        end
    end


    init()
end
return _Net