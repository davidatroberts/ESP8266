local ghost = {}

function ghost.setGhostColour(address, colour)
  http.post(string.format("%s/ghost/%s", address, colour), "", "",
  function(code, body, header)
      if code==200 then
        print("MSG: set ghost colour")
      else
        print(string.format("GHOST ERROR: code %d", code))
      end
  end)
end

return ghost
