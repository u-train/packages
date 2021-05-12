local popupButtons = require("./popupButtons/popupButtons.lua")
local options = require("./popupButtons/createOptions.lua")
local raycast = require("./raycast.lua")
local open = false
local click = 0

core.input:on("mouseRightDown", function()
    if os.clock() - click < 0.5 then
        if open then return end
        open = true
        local insertPosition = raycast.getMouseHitOrNear()
        local result = popupButtons.create(options)
        if result then
            options[result](insertPosition)
        end
        open = false
    else
        click = os.clock()
    end
end)