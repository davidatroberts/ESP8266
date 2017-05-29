local storm = {}

function storm.handler(req)
    -- print(handle)
    -- print(method)

    -- print(string.format("%s", data))

    local response = {
        "HTTP/1.0 200 OK\n",
        "Content-Type: text/html\n",
        "<h1>Hello, NodeMCU</h1>\n"
    }
    return response
end

return storm
