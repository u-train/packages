# deviap/serialiser

This module handles serialising objects to and from JSON

# Usage

```lua
    local serialiser = require("deviap/serialiser")

    -- Save a scene to a JSON string
    local sceneAsJSON = serialiser.toJSON(core.scene)

    -- Load a scene from a JSON string
    serialiser.fromJSON(sceneAsJSON)
    
    -- Save a scene to a file
    local sceneAsJSON = core.io:write("client/assets/starterScene.json", serialiser.toJSON(core.scene))

    -- Load a scene from a file
    serialiser.fromFile("client/assets/starterScene.json")
```

# Copyright and Acknowledgements

Copyright (c) 2021 - deviap.com