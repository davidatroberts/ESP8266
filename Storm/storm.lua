local storm = {}

function storm.handler(handle, method, data)
    print(handle)
    print(method)
    print(data)

    local response = {
        "HTTP/1.0 200 OK\n",
        "Content-Type: text/html\n",
        "<h1>Hello, NodeMCU</h1>\n"
    }
    return response
end

return storm