return function(name, description)
    name = name or _APP_NAME
    description = description or ""
    
    -- main container
    local mainContainer = core.construct("guiFrame", {
        parent = core.interface,
        size = guiCoord(0.45, 0, 1, 0),
        backgroundColour = colour(0.95, 0.95, 0.95),
        clip = false
    })

    -- main left bar tilted edge 
    core.construct("guiFrame", {
        parent = mainContainer,
        position = guiCoord(1, -100, -0.5, 0),
        size = guiCoord(0, 200, 2, 0),
        backgroundColour = colour(0.95, 0.95, 0.95),
        rotation = math.rad(10),
        zIndex = -2
    })

    -- main title text
    core.construct("guiTextBox", {
        parent = mainContainer,
        position = guiCoord(0, 50, 0, 30),
        size = guiCoord(1, 0, 0, 60),
        backgroundAlpha = 0,
        text = name,
        textSize = 48,
		textAlign = "middleLeft",
		textFont = "deviap:fonts/openSansBold.ttf"
    })

    -- main description text
    core.construct("guiTextBox", {
        parent = mainContainer,
        position = guiCoord(0, 50, 0, 80),
        size = guiCoord(1, 0, 0, 120),
        backgroundAlpha = 0,
        text = description,
        textSize = 18,
        textWrap = true,
		textAlign = "topLeft",
    })

    -- play button 
    local playBtn = core.construct("guiTextBox", {
        parent = mainContainer,
        position = guiCoord(0, 50, 0, 130),
        size = guiCoord(1, 0, 0, 42),
        backgroundColour = colour(0.35, 0.35, 0.35),
        text = "Play",
        textSize = 24,
        textWrap = true,
        textColour = colour(1, 1, 1),
		textAlign = "middle",
        clip = true
    })

    -- tilted edge for btn
    core.construct("guiFrame", {
        parent = playBtn,
        position = guiCoord(1, -5, -0.5, 0),
        size = guiCoord(0, 10, 2, 0),
        backgroundColour = colour(0.95, 0.95, 0.95),
        rotation = math.rad(10)
    })

    -- tilted edge for btn
    core.construct("guiFrame", {
        parent = playBtn,
        position = guiCoord(0, -5, -0.5, 0),
        size = guiCoord(0, 10, 2, 0),
        backgroundColour = colour(0.95, 0.95, 0.95),
        rotation = math.rad(10)
    })

    playBtn:once("mouseLeftUp", function()
        playBtn.text = "Looking for server..."
        core.networking:start()
    end)

    core.networking:on("_connection", function(msg)
        if msg == "connecting" then
            playBtn.text = "Connecting..."
        elseif msg == "failed" then
            playBtn.text = "Failed!"
        end
    end)

    core.networking:on("_connected", function(msg)
        mainContainer:destroy()
    end)
end