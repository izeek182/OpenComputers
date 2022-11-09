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
| 8008 | Logger Error broadcast |
| 8007 | Logger Info Broadcast |
| 20   | Discovery port |
| 21   | ping port |
| 25   | HeartBeat port |
| 30 | Component port |
| 35 | GLasses port |

Messages Types 
--

Logger
| Description | Port | args[1]| args[2]|
| --- | ----------- | ---- | ---- |
| Logger Error broadcast| 8008  | (srcClass) | (Error message) |
| Logger Info Broadcast| 8007  | (srcClass) | (Logged message) |

Automatic Discovery Protocol(ADP)
| Description | Port | args[1]|
| --- | ----------- | ---- |
| request  | 20  | "serverRequest" |
| response | 20  | "serverResponse" |

Ping
| Description | Port | args[1]|
| --- | ----------- | ---- |
| request  | 21  | "ping" |
| response | 21  | "pong" |

HeartBeat
| Description | Port | args[1]|
| --- | ----------- | ---- |
| request  | 25  | "heart" |
| response | 25  | "beat" |



