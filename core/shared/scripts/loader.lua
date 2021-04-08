---------------------------------------------------------------
-- Copyright 2021 Deviap (https://deviap.com/)               --
---------------------------------------------------------------
-- Made available under the MIT License:                     --
-- https://github.com/deviap/devicore/blob/master/LICENSE    --
---------------------------------------------------------------
--
-- Shared loader, detects if the requiring script is server or client
-- Throws error if requested component doesn't support current scope
--

local components = require("./componentList.lua")

local load;
load = function(component, ...)
    if not component then 
        component = "all"
    end

    if component == "all" then
        for k, v in pairs(components) do
            if (_SERVER and v.server) or (not _SERVER and v.client) then
                load(k)
            end
        end
        return nil
    end

    if not components[component] then
        return error("'" .. component .. "' component not found", 2)
    end

    if not (_SERVER and components[component].server) and not (not _SERVER and components[component].client) then
        return error("'" .. component .. "' component doesn't define work for " .. (_SERVER and "servers" or "clients"), 2)
    end

    return require((_SERVER and "server" or "client") .. "/scripts/components/" .. component .. ".lua")(...)
end

return load