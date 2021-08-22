local fullCutoff = 0.8
local component = require("component")
local gen = component.ie_diesel_generator
local capList= component.list("ie_hv_capacitor")
local caps = {}
for address, name in capList do 
  table.insert(caps,component.proxy(address))
end
gen.enableComputerControl(true)
while true do
  local capFull = false
  for k,cap in pairs(caps) do 
    local fill = cap.getEnergyStored()/cap.getMaxEnergyStored()
    print("capacitor "..k.." is filled to "..fill)
    if(cap.getEnergyStored()/cap.getMaxEnergyStored() > fullCutoff) then
      capFull = true
    end
  end
  if(capFull) then
    gen.setEnabled(false)
    print("generator is disabled")
  else
    gen.setEnabled(true)
    print("generator is enabled")
  end
  os.sleep(1)
end