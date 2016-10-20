
import MemberReference from require "framework.core"

import SceneNode, Vector from require "framework.scene_tree"



--- @brief Base class of every GUI element.
---
--- This node *must* have a parent with a size, otherwise it will raise an
--- error.
---
--- Public members :
---   - margin_left_type : The type of the left margin.
---   - margin_top_type : The type of the top margin.
---   - margin_right_type : The type of the right margin.
---   - margin_bottom_type : The type of the bottom margin.
---
--- Properties :
---   - position [get, set] : The position of the control.
---   - size [get, set] : The size of the control.
---   - transform [get] : The 2D transform of the control.
---   - margin_left [get, set] : The left margin.
---   - margin_top [get, set] : The top margin.
---   - margin_right [get, set] : The right margin.
---   - margin_bottom [get, set] : The bottom margin.
---   - margin_top_left [get, set] : The top and the left margin in a vector.
---   - margin_bottom_right [get, set] : The bottom and the right margin in a vector.
---
--- Signals:
---   - resized() : Called when the control is resized.
---
--- Building table:
---   - margin_left_type : The type of the left margin.
---   - margin_top_type : The type of the top margin.
---   - margin_right_type : The type of the right margin.
---   - margin_bottom_type : The type of the bottom margin.
---   - margin_left : The left margin.
---   - margin_top : The top margin.
---   - margin_right : The right margin.
---   - margin_bottom : The bottom margin.
---
---
class NodeControl extends SceneNode


    --- @brief Types of margin.
    ---
    @MarginType: {
        fromLeft: 1
        fromTop: 1

        fromRight: 2
        fromBottom: 2

        ratio: 3
    }


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @is_spatial = true

        @has_size = true


        @margin_left_type = @_opt t.margin_left_type, @@MarginType.fromLeft
        @margin_top_type = @_opt t.margin_top_type, @@MarginType.fromTop
        @margin_right_type = @_opt t.margin_right_type, @@MarginType.fromLeft
        @margin_bottom_type = @_opt t.margin_bottom_type, @@MarginType.fromTop

        @margin_left = @_opt t.margin_left, 0
        @margin_top = @_opt t.margin_top, 0
        @margin_right = @_opt t.margin_right, 0
        @margin_bottom = @_opt t.margin_bottom, 0

        @_margin_modified = true

        @has_custom_pos_setter = false
        @has_custom_size_setter = false

        @custom_pos_setter = nil
        @custom_size_setter = nil


        @property "position", "getPosition", "setPosition"
        @property "size", "getSize", "setSize"
        @property "transform", "getTransform", "setTransform"

        @property "margin_left", "getMarginLeft", "setMarginLeft"
        @property "margin_top", "getMarginTop", "setMarginTop"
        @property "margin_right", "getMarginRight", "setMarginRight"
        @property "margin_bottom", "getMarginBottom", "setMarginBottom"

        @property "margin_top_left", "getMarginTopLeft", "setMarginTopLeft"
        @property "margin_bottom_right", "getMarginBottomRight", "setMarginBottomRight"


        @addSignal "resized"




    --- @brief Called when the node enters the tree.
    ---
    _enterTree: =>

        super!

        @_resized_ref = MemberReference @, "_onParentResized"
        @parent\connect "resized", @_resized_ref


    --- @brief Called when the node exits the tree.
    ---
    --- @param old_parent : The old parent of the node (if it is removed).
    ---
    _exitTree: (old_parent) =>

        super old_parent

        if old_parent != nil

            old_parent\disconnect "resized", @_resized_ref
            @_resized_ref = nil


    --- @brief Called when the parent resizes.
    ---
    _onParentResized: =>

        @_margin_modified = true




    --- @brief Updates the position and the size of the node from its margins
    ---     values.
    ---
    --- @param t : The skip table.
    ---
    _updateMargin: (t = {}) =>

        if @parent == nil or not @parent.has_size

            error "A control need a parent with a size !"


        p_size = @parent\get "size"

        pos = Vector\copy @transform.position
        pos_changed = false

        size = Vector\copy @size
        resized = false


        -- left

        unless t.skip_left

            if @margin_left_type == @@MarginType.fromLeft

                pos.x = @margin_left

            elseif @margin_left_type == @@MarginType.fromRight

                pos.x = p_size.x - @margin_left

            else

                pos.x = p_size.x * @margin_left

            pos_changed = true


        -- top

        unless t.skip_top

            if @margin_top_type == @@MarginType.fromTop

                pos.y = @margin_top

            elseif @margin_top_type == @@MarginType.fromBottom

                pos.y = p_size.y - @margin_top

            else

                pos.y = p_size.y * @margin_left

            pos_changed = true


        -- right

        unless t.skip_right

            if @margin_right_type == @@MarginType.fromLeft

                size.x = @margin_right - pos.x

            elseif @margin_right_type == @@MarginType.fromRight

                size.x = p_size.x - @margin_right - pos.x

            else

                size.x = p_size.x * @margin_right - pos.x

            resized = true


        -- bottom

        unless t.skip_bottom

            if @margin_bottom_type == @@MarginType.fromTop

                size.y = @margin_bottom - pos.y

            elseif @margin_bottom_type == @@MarginType.fromBottom

                size.y = p_size.y - @margin_bottom - pos.y

            else

                size.y = p_size.y * @margin_bottom - pos.y

            resized = true


        @_margin_modified = false



        if pos_changed

            if @has_custom_pos_setter

                @[@custom_pos_setter] @, pos

            else

                @transform.position = pos


        if resized

            if @has_custom_size_setter

                @[@custom_size_setter] @, size

            else

                @size = size

            @emit "resized"




    --- @brief Get the position of the node.
    ---
    getPosition: =>

        if @_margin_modified

            @_updateMargin!

        return @transform.position



    --- @brief Set the position of the node.
    ---
    setPosition: (v) =>

        p_size = @parent\get "size"


        -- Left

        if @margin_left_type == @@MarginType.fromLeft

            @margin_left = v.x

        elseif @margin_right_type == @@MarginType.fromRight

            @margin_left = p_size.x - v.x

        else

            @margin_left = v.x / p_size.x


        -- Top

        if @margin_top_type == @@MarginType.fromTop

            @margin_top = v.y

        elseif @margin_top_type == @@MarginType.fromBottom

            @margin_top = p_size.y - v.y

        else

            @margin_top = v.y / p_size.y


        @_updateMargin {skip_left: true, skip_top: true}

        @transform.position = v




    --- @brief Get the size of the control.
    ---
    getSize: =>

        if @_margin_modified

            @_updateMargin!


        return @size


    --- @brief Set the size of the control.
    ---
    setSize: (v) =>

        p_size = @parent\get "size"


        -- Right

        if @margin_right_type == @@MarginType.fromLeft

            @margin_right = v.x + @transform.position.x

        elseif @margin_right_type == @@MarginType.fromRight

            @margin_right = p_size.x - v.x - @transform.position.x

        else

            @margin_right = (v.x + @transform.position.x) / p_size.x


        -- Bottom

        if @margin_bottom_type == @@MarginType.fromTop

            @margin_bottom = v.y + @transform.position.y

        elseif @margin_bottom_type == @@MarginType.fromBottom

            @margin_bottom = p_size.y - v.y - @transform.position.y

        else

            @margin_bottom = (v.y + @transform.position.y) / p_size.y


        @size = v
        @emit "resized"




    --- @brief Get the transform of the node.
    ---
    getTransform: =>

        if @_margin_modified

            @_updateMargin!

        return @transform


    --- @brief Set the transform of the node.
    ---
    --- @node This setter is forbidden, and will raise an error if called.
    ---
    setTransform: (v) =>

        error "Can't set the transform."




    --- @brief Get the left margin.
    ---
    getMarginLeft: =>

        return @margin_left


    --- @brief Set the left margin.
    ---
    setMarginLeft: (v) =>

        @margin_left = v
        @_margin_modified = true




    --- @brief Get the top margin.
    ---
    getMarginTop: =>

        return @margin_top


    --- @brief Set the left margin.
    ---
    setMarginTop: (v) =>

        @margin_Top = v
        @_margin_modified = true




    --- @brief Get the right margin.
    ---
    getMarginRight: =>

        return @margin_right


    --- @brief Set the left margin.
    ---
    setMarginRight: (v) =>

        @margin_right = v
        @_margin_modified = true




    --- @brief Get the bottom margin.
    ---
    getMarginBottom: =>

        return @margin_bottom


    --- @brief Set the left margin.
    ---
    setMarginBottom: (v) =>

        @margin_bottom = v
        @_margin_modified = true




    --- @brief Get the top and the left margin.
    ---
    getMarginTopLeft: =>

        return Vector\from @margin_left, @margin_top


    --- @brief Set the top and the left margin.
    ---
    setMarginTopLeft: (v) =>

        @margin_left = v.x
        @margin_top = v.y

        @_margin_modified = true




    --- @brief Get the bottom and the right margin.
    ---
    getMarginBottomRight: =>

        return Vector\from @margin_right, @margin_bottom


    --- @brief Set the bottom and the right margin.
    ---
    setMarginBottomRight: (v) =>

        @margin_right = v.x
        @margin_bottom = v.y

        @_margin_modified = true



{
    :NodeControl
}
