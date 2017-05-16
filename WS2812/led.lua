local led = {}

function led.init()
  ws2812.init()
end

function led.test()
  ws2812.write(string.char(
    255, 0, 0,
    0, 255, 0,
    0, 0, 255,
    255, 0, 0,
    0, 255, 0,
    0, 0, 255,
    255, 0, 0,
    0, 255, 0))
end

return led
