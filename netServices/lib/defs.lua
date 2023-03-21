if(_NetDefs ~= nil) then 
    _NetDefs = {}
    _NetDefs.loggerEnum = {
        error = 0,
        info  = 1
    }
    _NetDefs.hbEnum = {
        live    = 0,
        waiting = 1,
        overdue = 2
    }
    _NetDefs.serviceEnum = {
        adp         = 0,
        dns         = 1,
        logger      = 2
    }
    _NetDefs.portEnum = {
        logger          = 8008,
        adp             = 20,
        ping            = 21,
        heartBeat       = 25,
        componantCmd    = 30
    }
    _NetDefs.routingEnum = {
        uuid          = 420,   --not IP
        service       = 10,    -- Used for adp,dns,possibly others
        hostName      = 61     --Not implmented
    }
    _NetDefs.START = 0
    _NetDefs.END   = 420
end