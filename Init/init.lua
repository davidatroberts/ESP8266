local credentials = require("credentials")
local ghost       = require("ghost")
local server      = require("server")
local storm       = require("storm")

timeout = 20

function startup()
  print("MSG: starting script")
  ghost.setGhostColour(credentials.GHOST_IP, "green")
  storm.init()
  server.start(storm.handler)
end

function rebootWithoutInit(timer)
  file.remove("init.lua")
  timer:unregister()
  node.restart()
end

print(string.format("WIFI MSG: connecting to %s", credentials.WIFI_SSID))
wifi.setmode(wifi.STATION)
wifi.sta.config(credentials.WIFI_SSID, credentials.WIFI_PW)

count = 0
tmr.create():alarm(1000, tmr.ALARM_AUTO, function(cbTimer)
  local status = wifi.sta.status()
  -- handle error status
  if status == wifi.STA_WRONGPWD then
    print("WIFI ERROR: wrong password")
    rebootWithoutInit(cbTimer)
  end
  if status == wifi.STA_APPNOTFOUND then
    print("WIFI ERROR: no AP found")
    rebootWithoutInit(cbTimer)
  end
  if status == wifi.STA_WRONGPWD then
    print("WIFI ERROR: wrong password")
    rebootWithoutInit(cbTimer)
  end
  if status == wifi.STA_FAIL then
    print("WIFI ERROR: fail")
    rebootWithoutInit(cbTimer)
  end

  -- try and acquire an IP address
  if status ~= wifi.STA_GOTIP then
    print("WIFI MSG: acquiring IP address")
    count = count + 1
    if count > timeout then
      cbTimer:unregister()
      print(string.format(
        "WIFI ERROR: failed to acquire IP address after %d seconds, restarting",
        timeout))
      rebootWithoutInit(cbTimer)
    end
  else
    -- connected, run script
    cbTimer:unregister()
    local ip = wifi.sta.getip()
    print("WIFI MSG: connected")
    print(string.format("WIFI MSG: IP address: %s\n", ip))
    print("MSG: waiting 5 seconds until start...")

    tmr.alarm(0, 5*1000, tmr.ALARM_SINGLE, startup)
  end

end)
-- file.remove("init.lua")
