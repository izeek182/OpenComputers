if(_L2 == nil) then
    require("netDefs")

    local comp = require("component")
    local computer = require("computer")
    local event = require("event")
    local thread = require("thread")


    local modems = {}
    _L2Vars = {
        hostNameTouuid  = {},   -- HostName : uuid 
        uuidToHostName  = {},   -- uuid : HostName
        localHostNames  = {},
        routingTable    = {},   -- HostName -> {modemUUid,nextStepuuid}
        recentMessages  = {},    -- HostName -> {messageNumber : true | nil}
        packetNum       = 0
    }

    _L2 = {
    }


    function _L2.send(src,TargetDestitination,port,...)
        _L2Vars.packetNum = _L2Vars.packetNum + 1;
        if(_L2Vars.routingTable[TargetDestitination] == nil)then
            for key, value in pairs(modems) do
                modems[key].broadcast(port,TargetDestitination,src,_L2Vars.packetNum,table.unpack(arg))
            end
        else
            modems[_L2Vars.routingTable[TargetDestitination].modem].send(_L2Vars.routingTable[TargetDestitination].dest,port,TargetDestitination,src,_L2Vars.packetNum,table.unpack(arg))
        end
    end

    function _L2.createHost(Name,callback)
        _L2Vars.localHostNames[Name] = callback
        local host = {
            Name = Name,
            send = function (host,dest,...)
                _L2.send(host.Name,dest,20,...)
            end,
            close = function (host)
                _L2Vars.localHostNames[host.Name] = nil
                host.active = false;
            end,
            active = true
        }
        return host
    end

    function _L2.open(port)
        for key, value in pairs(modems) do
            modems[key].open(port)
        end        
    end

    local function CheckNewMessage(SrcHostName,packetNum)
        if(_L2Vars.recentMessages[SrcHostName] == nil) then 
            _L2Vars.recentMessages[SrcHostName] = {packetNum = true,t = computer.uptime()}
            return false
        else
            if(_L2Vars.recentMessages[SrcHostName][packetNum] == nil) then
                _L2Vars.recentMessages[SrcHostName][packetNum] = true
                return false
            else
                return true
            end
        end
    end

    local function onMessage(eventName, localAddress, remoteAddress, port, distance, --l1
        TargetDestitination,SrcHostName,packetNum, --l2
        ...)    -- Next Levels

        local new = CheckNewMessage(SrcHostName,packetNum)
        if(new == false) then
            return
        end

        if(_L2Vars.localHostNames[TargetDestitination] ~= nil) then
            if(_L2Vars.localHostNames[TargetDestitination](SrcHostName,table.unpack(arg))==nil) then
                return
            end
        end

        if(_L2Vars.routingTable[SrcHostName] == nil) then
            _L2Vars.routingTable[SrcHostName] = {modem = localAddress,dest = remoteAddress}
        else
            if _L2Vars.routingTable[SrcHostName].modem ~= localAddress |
            _L2Vars.routingTable[SrcHostName].modem ~= remoteAddress
            then
                -- Add a packetAge to optimize routes?
            end
        end


        if(_L2Vars.routingTable[TargetDestitination] == nil)then
            for key, value in pairs(modems) do
                if key ~= localAddress then
                    modems[key].broadcast(port,TargetDestitination,SrcHostName,packetNum,table.unpack(arg))
                end
            end
        else
            modems[_L2Vars.routingTable[TargetDestitination].modem].send(_L2Vars.routingTable[TargetDestitination].dest,port,TargetDestitination,SrcHostName,packetNum,table.unpack(arg))
        end
    end

    local function initModems()
        local list = comp.list("modem")

        modems = {}

        for index, value in ipairs(list) do
            modems[index] = comp.proxy(index)
        end
    end

    local function cleanRecentMessages()
        while true do
            for key, value in pairs(_L2Vars.recentMessages) do
                for key2, value2 in pairs(_L2Vars.recentMessages[key]) do
                    if(os.difftime(computer.uptime(),_L2Vars.recentMessages[key][key2].t) > 10)then
                        _L2Vars.recentMessages[key][key2] = nil
                    end
                end                
            end
            os.sleep(5)
        end
    end

    local function init()
        -- RegisterEventHandlers
        initModems()

        local t = thread.create(cleanRecentMessages)
        if(t == nil) then
            print("thread failed to create")
        end
        for key, value in pairs(t) do
            
        end
        t:detach()

        local status = event.listen("modem_message", onMessage)
        if (~(status)) then
            error("Failed to register listener for network data")
        end
    end

    function _L2.reset()
        initModems()
        _L2Vars = {
            hostNameTouuid  = {},   -- HostName : uuid 
            uuidToHostName  = {},   -- uuid : HostName
            routingTable    = {},   -- uuid -> {modemUUid,nextStepuuid}
        }
        _L2.open(_NetDefs.portEnum.adp)
        _L2.open(_NetDefs.portEnum.logger)
        _L2.open(_NetDefs.portEnum.ping)
    end
    init()
end
return _L2