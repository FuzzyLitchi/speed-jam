import Object from require "framework.core"

--- @brief Generic backend for data pipeline.
---
class Backend extends Object


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

    --- @brief Save the given data.
    ---
    --- @param data : serialized data.
    ---
    save: (data) =>


    --- @brief Load the given data.
    ---
    load: =>



{
    :Backend
}
