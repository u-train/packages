---------------------------------------------------------------
-- Copyright 2021 Deviap (https://deviap.com/)               --
---------------------------------------------------------------
-- Made available under the MIT License:                     --
-- https://github.com/deviap/deviap-main/blob/master/LICENSE --
---------------------------------------------------------------
-- Default chat system (server).
return function()
	local settings = require("shared/scripts/components/chatSettings.lua")
   
   -- Networking Event(s)
   core.networking:on("_clientConnected", function(client)
      core.networking:broadcast("sendChatMessage", colour.rgb(255, 183, 77), "CONSOLE", "Client ["..client.name.."] connected to server.")
   end)

   core.networking:on("_clientDisconnected", function(client)
      core.networking:broadcast("sendChatMessage", colour.rgb(255, 183, 77), "CONSOLE", "Client ["..client.name.."] disconnected from server.")
   end)

   core.networking:on("sendChatMessage", function(client, message)
      if string.len(message) > settings.charLimitPerLine*settings.charLimitMultiplier then
         return nil
      end

      core.networking:broadcast("sendChatMessage", colour.rgb(255, 183, 77), client.name, message)
   end)

   --while sleep(1) do
   --   core.networking:broadcast("sendChatMessage", colour.rgb(255, 183, 77), "CONSOLE", "Ping.")
   --end
end