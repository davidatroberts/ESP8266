local server = {}

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
      startInd, endInd = string.find(str, "([^ ]+)")

      -- get the method used to send
      key = trim(string.sub(str, startInd, endInd))
      result["method"] = key

      -- get the handle and and HTTP version
      v = trim(string.sub(str, endInd + 2))
      local spaceInd = string.find(v, " ")
      result["handle"] = string.sub(v, 2, spaceInd)
      result["version"] = string.sub(v, spaceInd)
    else
      -- Process ":" fields
      result.data = {}
      startInd, endInd = string.find(str, "([^:]+)")
      if (endInd ~= nil) then
        v = trim(string.sub(str, endInd + 2))
        key = trim(string.sub(str, startInd, endInd))
        result.data[key] = v
      end
    end
  end

  return result
end

function server.start(handler)
  srv:listen(80, function(conn)
    conn:on("receive", function(conn, data)
      -- get the request
      local req = getHTTPRequest(data)

      -- call the handler to deal with it
      local response = handler(req.handle, req.method, req.data)

      -- send the response
      local function sendMessage(conn)
        if #response > 0 then
          conn:send(table.remove(response, 1))
        else
          conn:close()
        end
      end
      conn:on("sent", sendMessage)
      sendMessage(conn)
    end)

    conn:on("sent", function(conn)
      conn:close()
    end)
  end)
end

return server