local led = {}

local buffer = {}
local noLEDs = 0

function led.init(n)
  noLEDs = n

  ws2812.init()
  buffer = ws2812.newBuffer(noLEDs, 3)

  for i=1, noLEDs do
    buffer:set(i, 255, 255, 255)
  end
  ws2812.write(buffer)

end

function led.setColours(colours)
  for i=0, noLEDs-1 do
    local ledInd = (i % #colours)+1
    local colour = colours[ledInd]
    buffer:set(i+1, colour.green, colour.red, colour.blue)
  end
  ws2812.write(buffer)
end

function led.setColour(colour)
  local colours = {}
  table.insert(colours, colour)
  led.setColours(colours)
end

return led
