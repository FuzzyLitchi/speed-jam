
import Object from require "framework.core.object"


--- @brief A reference on an object.
---
--- Properties :
---    - value [get] : Get the object (overloaded by children classes).
---    - object [get] : Get the object.
---
class ObjectReference extends Object


    --- @brief Create a new instance.
    ---
    --- @param obj : The referenced object.
    ---
    new: (obj) =>

        super!

        @type = "ObjectReference"

        @_object = setmetatable {}, { __mode: 'v' }
        @_object.ref = obj

        @__is_ref = true

        @property "value", "getObject", "setObject"
        @property "object", "getObject", "setObject"




    --- @brief Check if the reference is still valid.
    ---
    --- @return True if the reference is still valid.
    ---
    isValid: =>

        if @_object.ref == nil

            return false

        return true




    --- @brief Get the referenced object.
    ---
    --- @return The referenced object.
    ---
    getObject: =>

        if not @isValid!

            error "Invalid reference."


        return @_object.ref


    --- @brief Set the referenced object.
    ---
    --- @note This is not allowed, so calling this function raise an error.
    ---
    setObject: (v) =>

        error "Can't set the referenced object."




--- @brief A reference to a member of an object.
---
--- Public members:
---    - member : The referenced member's name.
---
--- Properties :
---    - value [get, set] : Get/Set the value of the member.
---
class MemberReference extends ObjectReference


    --- @brief Create a new instance.
    ---
    --- @param obj : The referenced object.
    --- @param member_name : The name of the referenced member.
    --- @param force_member : Force the use of a member (disallow properties).
    ---
    new: (obj, member_name, force_member = false) =>

        super obj

        @type = "MemberReference"

        @member = member_name
        @force_member = force_member

        @property "value", "getValue", "setValue"




    --- @brief Check if the reference is valid.
    ---
    --- @return True if the reference is valid.
    ---
    isValid: =>

        if not super!

            return false

        if @_object.ref.get != nil and not @force_member

            return @_object.ref\get(@member) != nil

        else

            return @_object.ref[@member] != nil




    --- @brief Get the value of the referenced member.
    ---
    --- @return The value of the referenced member.
    ---
    getValue: =>

        if not @isValid!

            error "Invalid reference."


        if @_object.ref.get != nil and not @force_member

            return @_object.ref\get(@member)

        else

            return @_object.ref[@member]


    --- @brief Set the value of the referenced member.
    ---
    --- @param v : The new value of the member.
    --- @return The new value.
    ---
    setValue: (v) =>

        if not @isValid!

            error "Invalid reference."


        if @_object.ref.get != nil and not @force_member

            @_object.ref\set @member, v

        else

            @_object.ref[@member] = v

        return v




    --- @brief Meta-method : MemberReference arg, arg...
    ---
    --- Calls the referenced member if it is a function.
    ---
    __call: (...) =>

        if not @isValid!

            error "Invalid reference."

        mem = nil


        if @_object.ref.get != nil and not force_member

            mem = @_object.ref\get(@member)

        else

            mem = @_object.ref[@member]


        if type(mem) != "function"

            error "Reference is not pointing to a function."

        return mem @_object.ref, ...



{
    :ObjectReference
    :MemberReference
}
