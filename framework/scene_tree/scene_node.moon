
import Object, MemberReference from require "framework.core"

import Transform, Vector, Matrix from require "framework.scene_tree.transform"
import Tween from require "framework.scene_tree.tween"


tbl = table



--- @brief Base class for every scene node.
---
--- Public members :
---   - parent [readonly] : The parent node.
---   - index_in_parent [readonly] : The index of the current node in the parent.
---   - is_spatial : Did the node has a position, etc ?
---   - apply_transform_only_for_children : Just read the name.
---   - transform : The transform of the node.
---   - can_process : Can the node process ?
---   - can_draw : Can the node draw ?
---   - children_can_process : Can the children process ?
---   - children_can_draw : Can the children draw ?
---   - is_visible : Is the node visible ?
---   - alpha : Alpha of the node and its children.
---   - self_alpha : Alpha of the node (and not its children).
---   - has_size : Does the node have a size ?
---   - size : The size of the node.
---
--- Properties :
---   - position [get, set] : The position of the node.
---   - origin [get, set] : The origin of the node.
---   - scale [get, set] : The scale of the node.
---   - shear [get, set] : The shear of the node.
---   - rotation [get, set] : The rotation of the node.
---
--- Signals :
---   - enter-tree(node) : When the node enters the tree.
---   - exit-tree(node) : When the node exits the tree.
---   - ready(node) : When the node is ready.
---
--- Building table :
---     Same as public member, except for "parent" and "index_in_parent".
---
class SceneNode extends Object


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @type = "SceneNode"

        @parent = nil
        @index_in_parent = nil

        @is_spatial = @_opt t.is_spatial, true
        @apply_transform_only_for_children = @_opt t.transform_for_children, true
        @transform = @_opt t.transform, Transform!

        @children = @_opt t.children, {}
        @tweens = {}

        @can_process = @_opt t.can_process, true
        @can_draw = @_opt t.can_draw, true

        @children_can_process = @_opt t.chilren_can_process, true
        @children_can_draw = @_opt t.children_can_draw, true

        @is_visible = @_opt t.is_visible, true

        @alpha = 1
        @self_alpha = 1

        @has_size = @_opt t.has_size, true
        @size = @_opt t.size, Vector!

        @in_tree = false
        @ready = false


        @property "position", "getPosition", "setPosition"
        @property "origin", "getOrigin", "setOrigin"
        @property "scale", "getScale", "setScale"
        @property "shear", "getShear", "setShear"
        @property "rotation", "getRotation", "setRotation"

        @addSignal "enter-tree"
        @addSignal "exit-tree"
        @addSignal "ready"


        if t.position

            @set "position", t.position

        if t.origin

            @set "origin", t.origin

        if t.scale

            @set "scale", t.scale

        if t.shear

            @set "shear", t.shear

        if t.rotation

            @set "rotation", t.rotation



        for idx, child in ipairs @children

            child.parent = @
            child.index_in_parent = idx




    --- @brief Method called when the node enters the scene tree.
    ---
    _enterTree: =>

        for child in *@children

            child\_enterTree!


        @emit "enter-tree", self


        unless @ready

            @_ready!


    --- @brief Method called when the node exits the scene tree.
    ---
    --- @param old_parent : The old parent which removed the current instance
    ---        (nil if the node is still in its parent).
    ---
    _exitTree: (old_parent) =>

        for child in *@children

            child\_exitTree nil


        @emit "exit-tree", self, old_parent


    --- @brief Method called when the node is in the scene tree and when all
    ---     its children are ready.
    ---
    _ready: =>

        @ready = true

        @emit "ready", self




    --- @brief Updates the node.
    ---
    --- @param dt : The delta-time.
    ---
    process: (dt) =>

        if @scheduler

            @scheduler\process dt


        tmp = {}

        for idx, tween in ipairs @tweens

            tween\process dt

            if tween\isFinished!

                tbl.insert tmp, idx


        tbl.sort tmp

        for i, idx in ipairs tmp

            tbl.remove @tweens, idx - i + 1



        if @can_process

            @_process dt


        if @children_can_process

            for child in *@children

                child\process dt


    --- @brief Draws the node.
    ---
    draw: =>

        unless @is_visible and (@can_draw or @children_can_draw)

            return


        transform_applied = false


        if @is_spatial and not @apply_transform_only_for_children

            @get("transform")\apply!
            transform_applied = true


        if @can_draw

            @_draw!



        if @children_can_draw and #@children != 0

            if @is_spatial and @apply_transform_only_for_children

                @get("transform")\apply!
                transform_applied = true

            for child in *@children

                child\draw!


        if transform_applied

            @get("transform")\undo!




    --- @brief Custom update function. Meant to be overloaded.
    ---
    --- @param dt : The delta-time.
    ---
    _process: (dt) =>


    --- @brief Custom draw function. Meant to be overloaded.
    ---
    _draw: =>



    --- @brief Get the position of the node.
    ---
    getPosition: =>

        return @transform.position


    --- @brief Get the origin of the node.
    ---
    getOrigin: =>

        return @transform.origin


    --- @brief Get the scale of the node.
    ---
    getScale: =>

        return @transform.scale


    --- @brief Get the shearing of the node.
    ---
    getShear: =>

        return @transform.shear


    --- @brief Get the rotation of the node.
    ---
    getRotation: =>

        return @transform.rotation




    --- @brief Set the position of the node.
    ---
    setPosition: (v) =>

        @transform.position = v


    --- @brief Set the origin of the node.
    ---
    setOrigin: (v) =>

        @transform.origin = v


    --- @brief Set the scale of the node.
    ---
    setScale: (v) =>

        @transform.scale = v


    --- @brief Set the shearing of the node.
    ---
    setShear: (v) =>

        @transform.shear = v


    --- @brief Set the rotation of the node.
    ---
    setRotation: (v) =>

        @transform.rotation = v




    --- @brief Add a tween to the node.
    ---
    --- @param tween : The tween to add.
    --- @return The added tween.
    ---
    addTween: (tween) =>

        tbl.insert @tweens, tween
        return tween


    --- @brief Create a new tween which will update the specified member.
    ---
    --- @param member : The member to update.
    --- @param startv : The starting value.
    --- @param endv : The ending value.
    --- @param duration : The duration of the easing.
    --- @param delay : The start delay of the tween (0 by default).
    ---
    --- @return The created tween.
    ---
    tween: (member, startv, endv, easing, duration, delay=0) =>

        ref = MemberReference @, member

        twn = Tween\from ref, startv, endv, easing, duration, delay

        @addTween twn
        return twn




    --- @brief Add a child to the node.
    ---
    --- @param child : The child to add.
    ---
    addChild: (child) =>

        if child.parent != nil and child.parent != @

            error "Child already has a parent."

        if child.parent == @

            error "Child already in the node."


        tbl.insert @children, child
        child.parent = @
        child.index_in_parent = #@children


        if @in_tree

            child\_enterTree!


    --- @brief Remove a child from the node.
    ---
    --- @param child : The child to remove.
    ---
    removeChild: (child) =>

        if child.parent != self

            error "Child not in the current node."

        index = child.index_in_parent

        tbl.remove @children, child.index_in_parent
        child.parent = nil
        child.index_in_parent = nil


        if @in_tree

            child\_exitTree @


        for i = index, #@children

            @children[i].index_in_parent -= 1




    --- @brief Get the final transformation matrix of the current node.
    ---
    getFinalTransform: =>

        if @parent == nil

            unless @is_spatial

                return Matrix!

            return @transform\getMatrix!

        else

            unless @is_spatial

                return @parent\getFinalTransform!\combine Matrix!

            return @parent\getFinalTransform!\combine @transform\getMatrix!


    --- @brief Get the final inverted transformation matrix of the current node.
    ---
    getFinalInvertedTransform: =>

        if @parent == nil

            unless @is_spatial

                return Matrix!

            return @transform\getInvertedMatrix!

        else

            unless @is_spatial

                return @parent\getFinalInvertedTransform!\combine Matrix!

            return @parent\getFinalInvertedTransform!\combine @transform\getInvertedMatrix!




    --- @brief Get the final alpha of the node and its children.
    ---
    --- @note This function takes in account the alpha of the parent nodes and
    ---     don't take in account self alpha.
    ---
    --- @return The final alpha.
    ---
    getAlpha: =>

        if @parent == nil

            return @alpha

        else

            return @parent\getFinalAlpha! * @alpha


    --- @brief Get the final alpha of the node.
    ---
    --- @note This function takes in account the alpha of the parent nodes and
    ---     the self alpha value.
    ---
    --- @return The final self alpha.
    ---
    getSelfAlpha: =>

        return @getFinalAlpha! * @self_alpha



{
    :SceneNode
}
