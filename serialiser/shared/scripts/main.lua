------------------------------------------------------------------
-- Copyright 2021 Deviap (https://deviap.com/)                  --
------------------------------------------------------------------
-- Made available under the MIT License:                        --
-- https://github.com/deviap/deviserialiser/blob/master/LICENSE --
------------------------------------------------------------------
local serialise = require("./internal/serialise.lua")
local deserialise = require("./internal/deserialise.lua")

return {
    toJSON = serialise,
    fromJSON = deserialise,
    fromFile = function(file)
        return deserialise(core.io:read(file))
    end
    
    -- Note the lack of a 'toFile' method,
    -- This is deliberate, as we do NOT want to give any app IO write access
    -- Even to their own app files
}