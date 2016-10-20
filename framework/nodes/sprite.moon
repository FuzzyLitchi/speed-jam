
import Color, Love from require "framework.core"

import SceneNode, Vector, Transform from require "framework.scene_tree"


lg = love.graphics



--- @brief A simple 2D sprite.
---
--- Public members :
---   - image : The image used by the sprite.
---   - quad : A quad used by the sprite (sub-rect of the image).
---   - color : The modulation color.
---
--- Properties :
---   - sprite-size [get] : The size of the sprite's image.
---
--- Building table :
---   - image : The image used by the sprite.
---   - quad : The quad used by the sprite.
---   - color : The modulation color of the sprite.
---
class NodeSprite extends SceneNode


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @type = "NodeSprite"

        @image = t.image
        @quad = t.quad

        @color = @_opt t.color, Color!


        if @image == nil

            error "A sprite needs a image !"


        if @quad == nil

            @size = Vector\from @image\getDimensions!

        else

            x, y, w, h = @quad\getViewport!
            @size = Vector\from w, h


        @property "sprite-size", "getSpriteSize", "setSpriteSize"




    --- @brief Draw the sprite.
    ---
    _draw: =>

        trans = Transform\copy @transform

        size_scaling = @size / @get("sprite-size")
        trans.scale *= size_scaling

        Love\set "color", @color
        Love\set "alpha", @getSelfAlpha!

        if quad == nil

            lg.draw @image, trans\toArgs!

        else

            lg.draw @image, @quad, trans\toArgs!




    --- @brief Get the sprite's original size.
    ---
    getSpriteSize: =>

        if @quad == nil

            return Vector\from @image\getDimensions!

        else

            x, y, w, h = @quad\getViewport!

            return Vector\from w, h


    --- @brief Set the sprite's original size.
    ---
    --- @note This setter is forbidden, so calling this function will raise an
    ---     error.
    ---
    setSpriteSize: =>

        error "Can't set the size of the image."




    --- @brief Center the origin of the sprite in the middle of the image.
    ---
    centerOrigin: =>

        @transform.origin = @get("sprite-size") / 2



{
    :NodeSprite
}
