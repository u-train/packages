return {
    ["block"] = function(pos)
        core.construct("block", {
            position = pos,
            colour = colour(0.9, 0.9, 0.9)
        })
    end,
    ["sphere"] = function(pos)
        core.construct("block", {
            position = pos,
            mesh = "deviap:3d/sphere.glb",
            colour = colour(0.9, 0.9, 0.9)
        })
    end
}