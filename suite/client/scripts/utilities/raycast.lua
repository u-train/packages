return {
    -- Returns the position of the closest hit OR a point if there's nothing but void.
    getMouseHitOrNear = function()
        local camera = core.scene.camera
        local camPos = camera.position
        local mousePos = camera:screenToWorld(core.input.mousePosition)

        local hits = core.scene:raycast(camPos, camPos + (mousePos * 500))
        if #hits == 0 then
            return camPos + (mousePos * 25)
        end
        
        return hits[1].position
    end
}