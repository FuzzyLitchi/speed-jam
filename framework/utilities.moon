

--- @brief Mix two table.
---
--- @note This just shallow copy the tables' values.
---
--- @param list : Tables to mix.
---
--- @return The mixed table.
---
mix_table = (list) ->

    result = {}


    for tab in *list

        for k, v in pairs tab

            result[k] = v


    return result



{
    :mix_table
}
