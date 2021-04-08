return function()

    local container = core.construct("guiFrame", {
		parent = core.interface,
		name = "_Client_PlayerList",
		size = guiCoord(0, 140, 0, 220),
		position = guiCoord(1, -140, 0, 0),
		backgroundColour = colour.rgb(255, 0, 0),
		backgroundAlpha = 0
	})

	local autoCollectionGrid = require("shared/scripts/components/collectionLayoutAuto.lua")

	local gridController = autoCollectionGrid({
		parent = container,
		position = guiCoord(0, 10, 0, 0),
		size = guiCoord(0, 300, 0, 200),
		backgroundColour = colour.rgb(255, 0, 0),
		backgroundAlpha = (debug_visual == true and 1) or 0,
		scrollbarAlpha = 0
	})

    core.networking:on("_clientConnected", function(client)
        core.construct("guiTextBox", {
            parent = gridController.container,
            name = client.id,
            text = client.name,
            size = guiCoord(1, 0, 0, 22),
            backgroundColour = colour.rgb(255, 255, 255),
            backgroundAlpha = 0.075,
            textAlign = "middleLeft"
        })
    end)

    core.networking:on("_clientDisconnected", function(client)
        local gui = gridController.container:child(client.id)
        if gui then
            gui:destroy()
        end
    end)
end