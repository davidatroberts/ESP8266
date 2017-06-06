local led = require("led")

local storm = {}

local handleMap = {}
local fadeTmr = tmr.create()

function setColour(req)
  print(string.format("Storm: %s", req.method.uri))
  local colours = sjson.decode(req.body)
  led.setColours(colours)
end

function setFade(req)
    local fadeData = sjson.decode(req.body)
    
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
