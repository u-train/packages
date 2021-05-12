require("devgit:source/application/utilities/camera.lua")

return {
    setup = function()
        core.graphics.sky = "fs:client/assets/skys/rooitou_park_4k.jpg"
        core.graphics.upperAmbient = colour.rgb(212, 239, 255)
        core.graphics.lowerAmbient = colour.rgb(54, 69, 55)
        
        local dir = quaternion.euler(math.rad(-45), math.rad(120), math.rad(0))
        core.graphics.ambientDirection = dir * vector3(0, 0, 1)
        
        core.scene.camera.position = vector3(0, 2, 10)
        core.scene.camera:lookAt(vector3(0,0,0))
    end
}