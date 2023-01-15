Each machine is defined as follows:
```
Type Machine{
min : {x:(int),Y:(int),Z:(int)}
max : {x:(int),Y:(int),Z:(int)}
name : (String)
HostController : (UID)
}
```
Machines.data: Is simply a table of Machine data.


Server.data:
```
Type Server{
    pos : {x:(int),Y:(int),Z:(int)},
    KnownHosts: {[UID]:{Type:(String)},
    ARProject: {en: (bool),pos : {x:(int),Y:(int),Z:(int)},Address}
}
```

Remote.data:
```
Type RemoteHost{
    pos : {x:(int),Y:(int),Z:(int)},
    Server: (UUID),
}
```

Ports

| Port | Description |
| --- | ----------- |
| 8008 | Logger broadcast |
| 20   | Discovery port |
| 21   | ping port |
| 25   | HeartBeat port |
| 30 | Component port |
| 35 | GLasses port |

ServiceCode

| Enum | Description |
| ---  | ----------- |
| 2    | PassUp      |
| 3    | ADP         |
| 4    | Debug Net   |

Default L2 header---
|DestHostName  | SrcHostName | PacketNum |

Destination is not necessarily unique, Some Destinations may imply a full network broadcast Example "Logger"

Default L3 header---
|DestHostName  | SrcHostName | PacketNum | ServiceCode |


All messages are going to have a header of the following form
| Final Destination | more maybe? |

Messages Types 
--

Logger
| Description |      Port   | DestHostName  | SrcHostName | args[1]        | args[2]    | args[3]       | arg[4]      |
| ----------- | ----------- |--             |--           | ----           | ----       | ---           | ---         | 
| Logger      | 8008        | "Logger"      | SrcName     | ServiceCode(4) | (srcClass) | (Error Level) | (message)   |

DNS {Register:1,Lookup:2,response:4}
| Description | Port       | DestHostName | SrcHostName | args[1]        | args[2]          | args[3]           |
| ---         | ----       | --           |--           | ----           | ----             | ---               |
| Register    | 20         | "DNS Service"| SrcName     | ServiceCode(3) | Enum.Register    | Sender's HostName |
| request     | 20         | "DNS Service"| SrcName     | ServiceCode(3) | Enum.Lookup      | ---               |
| response    | 20         |OriginalSender|"DNS Service"| ServiceCode(3) | Enum.response    | Sender's HostName |



Ping
| Description   | Port        | args[1]|
| ---           | ----------- | ---- |
| request       | 21          | "ping" |
| response      | 21          |  "pong" |

HeartBeat
| Description | Port | args[1]|
| --- | ----------- | ---- |
| request  | 25  | "heart" |
| response | 25  | "beat" |



