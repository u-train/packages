------------------------------------------------------------------
-- Copyright 2021 Deviap (https://deviap.com/)                  --
------------------------------------------------------------------
-- Made available under the MIT License:                        --
-- https://github.com/deviap/deviserialiser/blob/master/LICENSE --
------------------------------------------------------------------

local shared = require("./shared.lua")
local function serialiseObject(object)
	if type(object) ~= "tevObj" then
		warn("Can only serialise tevObjs")
		return nil
	elseif object.name and object.name:sub(0, 2) == "__" then
		warn("Skipping object with __ prefix")
		return nil
	end

    local serialised = {}
    serialised.className = object.className

	local info = core.reflection:getClassReflection(object.className)
	for k, v in pairs(info.properties) do
		local value = object[k]
		local valueType = type(value)

		-- We only want to serialise values we can set
		if v.hasSetter or valueType == "tevObj" then
			if valueType ~= "tevObj" then
				serialised[k] = value
			else
				serialised[k] = serialiseObject(value)
			end
		end
	end

	if info.properties["children"] and type(object.children) == "table" then
		serialised.children = {}
		for _, v in pairs(object.children) do
			if type(v) == "tevObj" then
				table.insert(serialised.children, serialiseObject(v))
			end
		end
	end

	return serialised
end

return function(root)
	return core.json:encode {
        serialiserVersion = shared.version, 
        serialisedAt = os.date("%d/%m/%Y %H:%M:%S"),
        object = serialiseObject(root)
    }
end
