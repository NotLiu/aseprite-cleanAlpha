----------------------------------------------------------------------
-- cleans up your image, removes all pixels with an alpha < 1.0
--
-- It works for RGB color mode
----------------------------------------------------------------------

if app.apiVersion < 1 then
    return app.alert("This script requires Aseprite v1.2.10-beta3")
end

local cel = app.activeCel
if not cel then
    return app.alert("There is no active image")
end

math.randomseed(os.time())

-- The best way to modify a cel image is to clone it (the new cloned
-- image will be an independent image, without undo information).
-- Then we can change the cel image generating only one undoable
-- action.
local img = cel.image:clone()

if img.colorMode == ColorMode.RGB then
    local rgba = app.pixelColor.rgba
    local rgbaA = app.pixelColor.rgbaA
    for pxl in img:pixels() do
        local pixelValue = pxl()
        if rgbaA(pxl()) < 255  and rgbaA(pxl()) > 0 then
            pxl(0, 0, 0, 0)
        end
    end
end

-- Here we change the cel image, this generates one undoable action
cel.image = img

-- Here we redraw the screen to show the modified pixels, in a future
-- this shouldn't be necessary, but just in case...
app.refresh()