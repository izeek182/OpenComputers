local targeter = require("targeter")
local turret = require("component").os_energyturret
local entity = require("component").os_entdetector
local turretRelPos = {x = 0, y = 1 ,z = 0}
turretRelPos.x = 0
turretRelPos.y = 1
turretRelPos.z = 0
maxSpeed = {xz = 3, vert = 3}
 
turret.powerOn()
turret.extendShaft(2)
turret.setArmed(true)
 
 
local pos = {xz=0,vert=0}
local target = {xz=0,vert=0}
 
local lastCheckedPlayer = 0
local lastCheckedturret = 0
local coolDown = 0.05
local coolDownTurret = 0.05
function moveTowards()
	local XZdelta = pos.xz - target.xz
	local vertDelta = pos.vert - target.vert
	XZdelta = math.max(math.min(XZdelta,maxSpeed.xz),-maxSpeed.xz)
	vertDelta = math.max(math.min(vertDelta,maxSpeed.vert),-maxSpeed.vert)
	pos.xz = pos.xz + XZdelta
	print("posXZ"..pos.xz)
	pos.vert = pos.vert + vertDelta
	print("posVert"..pos.vert)
	turret.moveTo(target.xz,target.vert)
end
while true do
	if(lastCheckedPlayer + coolDown < os.clock()) then
		lastCheckedPlayer = os.clock()
		print("current Time"..lastCheckedPlayer)
		local players = entity.scanPlayers(32)
		if(players) then
			local player = players[1]
			print(player.range)
			target.xz = targeter.getZrot(turretRelPos.x,turretRelPos.z,player.x,player.z)
			target.vert = targeter.getAlt(turretRelPos.x,turretRelPos.y,turretRelPos.z,player.x,player.y+player.height/2,player.z)
		end
		--turret.moveTo(target.xz,target.vert)
		--if(turret.isOnTarget()) then
			moveTowards()
		--end
	end
	if(lastCheckedturret + coolDownTurret < os.clock()) then
		lastCheckedturret = os.clock()
		moveTowards()
	end
	if(turret.isReady() and turret.isOnTarget()) then
		turret.fire()
	end
end