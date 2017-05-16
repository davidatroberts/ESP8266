srv = net.createServer(net.TCP)

function trim(s)
  return (s:gsub ("^%s*(.-)%s*$", "%1"))
end

function getHTTPRequest(data)
local result = {}

local first = nil
local key, v, startInd, endInd

for str in string.gmatch (data, "([^\n]+)") do
  -- First line in the method and path
  if (first == nil) then
    first = 1
    startInd, endInd = string.find (str, "([^ ]+)")

    -- get the method used to send
    key = trim (string.sub (str, startInd, endInd))
    result["method"] = key

    -- get the handle and and HTTP version
    v = trim (string.sub (str, endInd + 2))
    local spaceInd = string.find(v, " ")
    result["handle"] = string.sub(v, 2, spaceInd)
    result["version"] = string.sub(v, spaceInd)
  else
    -- Process ":" fields
    startInd, endInd = string.find (str, "([^:]+)")
    if (endInd ~= nil) then
      v = trim (string.sub (str, endInd + 2))
      key = trim (string.sub (str, startInd, endInd))
      result[key] = v
    end
  end
end

return result
end

srv:listen(80, function(conn)
  conn:on("receive", function(sck, data)
    local req = getHTTPRequest(data)
    print(req.method)
    print(req.handle)
    sck:send([[
      HTTP/1.0 200 OK\r\n
      Content-Type: text/html\r\n\r\n
      <h1> Hello, NodeMCU.</h1>
      ]]
    )
  end)

  conn:on("sent", function(sck)
    sck:close()
  end)
end)
