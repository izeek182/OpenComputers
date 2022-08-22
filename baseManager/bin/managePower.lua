local fileName = "/data/Machines.data"

local tableLoader = require("tableToFile")
local comp = require("component")
local savedMachines = tableLoader.load(fileName)
