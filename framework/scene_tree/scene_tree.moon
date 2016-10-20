
import Love from require "framework.core"

import Vector from require "framework.scene_tree.transform"
import SceneNode from require "framework.scene_tree.scene_node"


lg = love.graphics



--- @brief The root of the scene tree.
---
--- Properties:
---   - size [get] : Get the size of the window.
---
--- Signals:
---   - resized() : Called when the window is resized.
---
class _SceneTree extends SceneNode


    --- @brief Create a new instance.
    ---
    new: =>

        super {

            is_spatial: false

            properties: {
                {"size", "getSize", "setSize"}
            }

            signals: {
                "resized"
            }
        }

        @in_tree = true
        @ready = true




    --- @brief Get the size of the scene tree (the window).
    ---
    getSize: =>

        return Vector\from lg.getDimensions!


    --- @brief Set the size of the scene tree (the window).
    ---
    --- @note This setter is forbidden, so it will raise an error.
    ---
    setSize: (v) =>

        error "Can't set the size of the scene tree"




SceneTree = _SceneTree!



Love\connect "process", (dt) ->

    SceneTree\process dt


Love\connect "draw", ->

    SceneTree\draw!


Love\connect "resize", ->

    SceneTree\emit "resized"



{
    :SceneTree
}
