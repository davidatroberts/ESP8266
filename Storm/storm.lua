local led = require("led")

local storm = {}

local handleMap = {}

function setColour(req)
  print(string.format("Storm: %s", req.method.uri))
  local colours = sjson.decode(req.body)
  -- for k, v in ipairs(colours) do
  --   print(string.format("%d: r:%d g:%d b:%d", k, v.red, v.green, v.blue))
  -- end
  led.setColours(colours)
end

function storm.init()
  led.init(8)

  handleMap["/colour"] = {}
  handleMap["/colour"]["POST"] = setColour
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
