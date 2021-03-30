# deviap/core

This module contains the basic building blocks to get started with your networked game, meaning you don't have to code the simple things such as:

- *(WIP)* main menu
- *(UNADDED)* chat
- *(UNADDED)* player list
- *(UNADDED)* characters
- *(UNADDED)* tools
- *(UNADDED)* administration

# Installation

Simply amend your deviapp manifest to reference this package, for example:
```lua
    {
        "schema": 1,
        "id": "networked-01-intro",
        "name": "networked-01-intro",
        "isApp": true,
        "version": "1.0.1",
        "permissions": {
            ... omitted for brevity
        },
        "dependencies": {
            "client": {
                "deviap/core": "latest"
            },
            "server": {
                "deviap/core": "latest"
            }
        }
    }
```
**We highly recommend you reference 'latest' as the version for this package.**

# Loading deviap/core

Simply require this package from both the client and server main.lua

*client/scripts/main.lua*
```lua
    require("deviap/core").load("all") -- load all core client components
```

*server/scripts/main.lua*
```lua
    require("deviap/core").load("all") -- load all core server components
```

# Loading specific components

You may not want to utilise everything this package provides. In which case, you could do something like:

*client/scripts/main.lua*
```lua
    require("deviap/core").load("chat")
    require("deviap/core").load("playerList")
```

*server/scripts/main.lua*
```lua
    require("deviap/core").load("chat")
    require("deviap/core").load("playerList")
```

# Passing parameters to components

```lua
    -- use default parameters
    require("deviap/core").load("mainMenu")

    -- pass custom title and description
    require("deviap/core").load("mainMenu", "title", "description goes here")
```

# Copyright and Acknowledgements

Copyright (c) 2021 - deviap.com