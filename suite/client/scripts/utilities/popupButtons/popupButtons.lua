------------------------------------------------------------------
-- Copyright 2021 Deviap (https://deviap.com/)                  --
------------------------------------------------------------------
-- Made available under the MIT License:                        --
-- https://github.com/deviap/deviserialiser/blob/master/LICENSE --
------------------------------------------------------------------
return {

    create = function(actions)
        local mPos = core.input.mousePosition
        local lines = {}
        local result = nil
        local active = true
        local count = 0
        for _,v in pairs(actions) do count = count + 1 end

        local i = 0
        for v,_ in pairs(actions) do
            i = i + 1
            local pos = mPos + vector2(40, ((i-1) * 26) - ((count * 26)/2))

            local line = core.construct("guiLine", {
                parent = core.interface,
                pointA = guiCoord(0, mPos.x, 0, mPos.y),
                pointB = guiCoord(0, mPos.x, 0, mPos.y),
                lineWidth = 2,
                lineAlpha = 0.7
            })

            local btn = core.construct("guiTextBox", {
                parent = core.interface,
                text = v,
                name = v,
                size = guiCoord(0, 20, 0, 20),
                position = guiCoord(0, mPos.x, 0, mPos.y),
                textAlign = "middle",
                textAlpha = 0,
                textSize = 14
            })

            btn:on("mouseLeftUp", function()
                result = v
                active = false
            end)

            lines[btn] = line

            btn.size = guiCoord(0, btn.textDimensions.x + 20, 0, 20)
            core.tween:begin(btn, 0.2 + (i/20), { 
                position = guiCoord(0, pos.x, 0, pos.y),
                textAlpha = 1,
                backgroundAlpha = 1
            }, "outQuad")

            core.tween:begin(line, 0.2 + (i/20), { 
                pointB  = guiCoord(0, pos.x, 0, pos.y + (btn.size.offset.y/2)),
                lineAlpha = 0.6
            }, "outQuad")
        end

        while active and sleep() do
            local newMPos = core.input.mousePosition

            local minY = nil
            local maxY = nil
            local maxX = nil

            for btn,v in pairs(lines) do
                if not minY then
                    minY = btn.absolutePosition.y 
                    maxY = btn.absolutePosition.y + btn.absoluteSize.y
                    maxX = btn.absolutePosition.x + btn.absoluteSize.x
                else
                    minY = math.min(minY, btn.absolutePosition.y)
                    maxY = math.max(maxY, btn.absolutePosition.y + btn.absoluteSize.y)
                    maxX = math.max(maxX, btn.absolutePosition.x + btn.absoluteSize.x)
                end
                
                v.pointA = guiCoord(0, mPos.x + math.clamp(newMPos.x - mPos.x, -10, 10), 0, newMPos.y)
                if btn.absolutePosition.y < newMPos.y and btn.absolutePosition.y + btn.absoluteSize.y > newMPos.y then
                    v.lineAlpha = 1
                    v.lineWidth = 3
                    btn.textFont = "deviap:fonts/openSansBold.ttf"
                else
                    v.lineAlpha = 0.6
                    v.lineWidth = 2
                    btn.textFont = "deviap:fonts/openSansRegular.ttf"
                end
            end

            if not (minY - 30 < newMPos.y and maxY + 30 > newMPos.y) or newMPos.x < mPos.x - 30 or newMPos.x > maxX + 30 then
                active = false
            end
        end

        local i = 0
        for btn, line in pairs(lines) do
            i = i + 1
            core.tween:begin(btn, 0.2, { 
                position = guiCoord(0, mPos.x, 0, mPos.y),
                textAlpha = 0,
                backgroundAlpha = 0
            }, "outQuad")

            core.tween:begin(line, 0.2, { 
                pointA  = guiCoord(0, mPos.x, 0, mPos.y),
                pointB  = guiCoord(0, mPos.x, 0, mPos.y),
                lineAlpha = 0
            }, "outQuad")
        end

        spawn(function()
            sleep(0.2)
            for btn, line in pairs(lines) do
                btn:destroy()
                line:destroy()
            end
        end)

        return result or nil
    end
}
