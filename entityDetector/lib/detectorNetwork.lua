local detectorNetwork = {}
local fs = require("filesystem")
local tableio = require("tableio")


if(fs.exists("/etc/detector.cfg"))then
    detectorNetwork.nodes = tableio.load("/etc/detector.cfg")
else 
    detectorNetwork.nodes = {}
    io.stderr:write("no config File found please run calibration")
end

function detectorNetwork.getplayers()

end