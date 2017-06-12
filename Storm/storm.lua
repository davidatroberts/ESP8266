local led = require("led")
local cos = require("cos")

local storm = {}

local handleMap = {}
local fadeTmr = tmr.create()
local deg = 360

function setColour(req)
  print(string.format("Storm: %s", req.method.uri))
  local colours = sjson.decode(req.body)
  led.setColours(colours)
end

function setFade(req)
  local colour = sjson.decode(req.body)
  fadeTmr:register(50, tmr.ALARM_AUTO, function()
    local val, nextDeg = cos.value(deg, 2)
    deg = nextDeg
    colour.red = colour.red*val
    colour.green = colour.green*val
    colour.blue = colour.blue*val
    led.setColour(colour)
  end)
end

function stopFade(req)
  fadeTmr:stop()
  fadeTmr:unregister()
end

function storm.init()
  led.init(8)

  handleMap["/colour"] = {}
  handleMap["/colour"]["POST"] = setColour
  handleMap["/fade"] = {}
  handleMap["/fade"]["POST"] = setFade
  handleMap["/stopfade"] = {}
  handleMap["/stopfade"]["POST"] = stopFade
end

function storm.handler(req)
  -- map uri/method to function handler
  if handleMap[req.method.uri]~=nil then
    if handleMap[req.method.uri][req.method.method] ~= nil then
      handleMap[req.method.uri][req.method.method](req)
    end
  end

  local response = {
    "HTTP/1.0 200 OK\n"
  }
  return response
end

return storm
