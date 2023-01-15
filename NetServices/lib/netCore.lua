if(_Net == nil) then
    require("netDefs.lua")

    local comp = require("component")
    local event = require("event")
    local Logger = require("logger")

    local modem = comp.modem
    _NetVars = {
        hostNameTouuid  = {},   -- HostName : uuid 
        uuidToHostName  = {},   -- uuid : HostName
        listeners       = {},   -- listeners {Id : listener}
        services        = {}    -- Services format {Id : {}}
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
    -- Blocking ping command
    function _Net.ping(uuid)
        _Net.send(uuid,_NetDefs.portEnum.ping,_NetDefs.START)
    end

    local function onMessage(eventName, localAddress, remoteAddress, port, distance, ...)
        if(_NetVars.pListeners[port] ~= nil) then
            _NetVars.pListeners[port](localAddress, remoteAddress, port, distance, arg)            
        else
            if(_NetVars.listeners[port]~= nil)then
                _NetVars.listeners[port](localAddress, remoteAddress, port, distance, arg)
            else
                Logger:info("recived message on port:"..port.." but has no registered services on port");
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