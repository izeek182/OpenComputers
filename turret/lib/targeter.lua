local targeter = {} -- main table
function targeter.getZrot(x1,z1,x2,z2)
	local x = x2-x1
	local z = z2-z1
	print(" x:"..x.." z:"..z)
	local radian = math.atan2(x,-z);
	print("radian:"..radian)
	local deg = math.deg(radian)
	print("deg:"..deg)
	return deg
end
 
function targeter.getAlt(x1,y1,z1,x2,y2,z2)
	local dist = math.pow(math.pow((x2-x1),2)+math.pow((z2-z1),2),0.5)
	local radian = math.atan2((y2-y1),dist)
	return math.deg(radian)
end
 
return targeter
--[[
local x1 = 0
local x2 = 3
local y1 = 0
local y2 = 4
local z1 = 0
local z2 = 4
 
print("Z rotation: "..getZrot(x1,z1,x2,z2))
print("alt rot : "..getAlt(x1,y1,z1,x2,y2,z2))
--]]