
import Color from require "framework.core"

import SceneNode, Vector, Transform from require "framework.scene_tree"


lg = love.graphics



--- @brief A simple text.
---
--- Public members :
---   - font : The font to use.
---   - text : The text drawn.
---   - color : The color of the text.
---
--- Properties :
---   - size [get] : The size of the text.
---
--- Building table :
---   - font : The font to use.
---   - text : The text drawn.
---   - color : The color of the text.
---
class NodeText extends SceneNode


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t


        @font = @_opt t.font, lg.getFont!
        @text = @_opt t.text, ""

        @color = @_opt t.color, Color!


        @property "size", "getSize", "setSize"




    --- @brief Draw the text.
    ---
    _draw: =>

        Love\set "color", @color
        Love\set "alpha", @getSelfAlpha!


        lg.setFont @font
        lg.print @text, @transform\toArgs!




    --- @brief Get the text's size.
    ---
    getSize: =>

        w = @font\getWidth @text
        h = @font\getHeight!

        return Vector\from w, h


    --- @brief Set the text's size.
    ---
    --- @note This setter is forbidden, so it will raise an error.
    ---
    setSize: (v) =>

        error "Can't set the size of a text."




    --- @brief Center the origin to the text's center.
    ---
    centerOrigin: =>

        @transform.origin = @get("size") / 2




{
    :NodeText
}
