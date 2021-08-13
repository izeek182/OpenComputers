local door = require("component").os_rolldoorcontroller
door.setSpeed(0.5)
door.toggle()
while (door.isMoving()) do 
	print(door.getPosition())
	os.sleep(0.25)
end