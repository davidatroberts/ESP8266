local server = {}

srv = net.createServer(net.TCP)

function trim(s)
  return (s:gsub ("^%s*(.-)%s*$", "%1"))
end

function printRequest(req)
  print(string.format("Method: %s", req.method.method))
  print(string.format("Method: %s", req.method.uri))
  print(string.format("Method: %s", req.method.protocol))

  for k, v in pairs(req.header) do
    print(string.format("Header: %s: %s", k, v))
  end

  if req.body ~= nil then
    print(string.format("Body: %s", req.body))
  end
end

function parseRequest(data)
  local parseMethod = function(line)
    local tmp = {}
    for str in string.gmatch(line, "%S+") do
      table.insert(tmp, str)
    end
    return {method=tmp[1], uri=tmp[2], protocol=tmp[3]}
  end

  local parseHeader = function(lines)
    local header = {}
    for _, line in ipairs(lines) do
      local ind = string.find(line, ":")
      if ind ~= nil then
        local key = trim(string.sub(line, 1, ind-1))
        local value = trim(string.sub(line, ind+1))
        header[key] = value
      end
    end
    return header
  end

  -- split the header and body 
  local lines = {}
  local headerEnd = string.find(data, "\r\n\r\n")
  if not headerEnd then 
    for str in string.gmatch(data, "([^\r\n]+)") do
      table.insert(lines, str)
    end
  else
    for str in string.gmatch(string.sub(data, 1, headerEnd), "([^\r\n]+)") do
      table.insert(lines, str)
    end
  end

  -- parse method
  local method = parseMethod(lines[1])
  table.remove(lines, 1)

  -- parse header
  local header = parseHeader(lines)

  -- read body
  local body = nil
  if headerEnd ~= nil then
    body = string.sub(data, headerEnd+4)
  end

  local request = {
    method = method,
    header = header,
    body = body
  }
  return request
end

function server.start(handler)
  srv:listen(80, function(conn)
    conn:on("receive", function(conn, data)
      -- get the request
      local req = parseRequest(data)
      -- printRequest(req)

      -- call the handler to deal with it
      local response = handler(req)

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
