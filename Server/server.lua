srv = net.createServer(net.TCP)

srv:listen(80, function(conn)
  conn:on("receive", function(sck, data)
    print(data)
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
