
import Backend from require "framework.data.backend"

--- @brief Recursively generate INI synatx from table.
---
--- @param data : The table of data.
---
--- @param rec_sec : Analyzed section content (for internal use).
---
--- @return The generated INI content as a string.
---
generate_ini = (data, rec_sec) ->
    output = ""
    for section, param in pairs data
        if "table" == type param
            unless rec_sec
                output ..= ("\n[%s]\n")\format section
            else
                output ..= ("\n[%s.%s]\n")\format rec_sec, section
            for k, v in pairs param
                unless "table" == type v
                    if "string" == type v
                        output ..= ("%s = \"%s\"\n")\format k, tostring v
                    else
                        output ..= ("%s = %s\n")\format k, tostring v
                else
                    unless rec_sec
                        rec_sec = ("%s.%s")\format section, k
                    else
                        rec_sec = ("%s.%s.%s")\format rec_sec, section, k
                    output ..= ("\n[%s]\n")\format rec_sec
                    output ..= generate_ini v, rec_sec
        else
            if "string" == type param
                output ..= ("%s = \"%s\"\n")\format section, tostring param
            else
                output ..= ("%s = %s\n")\format section, tostring param

    output


--- @brief Data backend for handling INI data.
---
--- Building table parameters :
---   - namespace : The namespace from which to load and save data (optional).
---   - path : The path to from which to load and save data (optional).
---
class IniBackend extends Backend


    --- @brief Create new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @type = "DataBackend"

        @path = @_opt t.path, nil
        @namespace = @_opt t.namespace, "data"



    --- @brief Save given table to specified path, as INI data.
    ---
    --- @param data : The data to save.
    ---
    --- @return The generated INI data (convenience)
    ---
    save: (data) =>
        ini_data = generate_ini {[@namespace]: data}
        love.filesystem.write @path, ini_data
        ini_data


    --- @brief Load data from specified path and parse as INI data.
    ---
    --- @return Namespace of table generated from loaded INI file (namespace defaults to 'data').
    ---
    load: =>
        data = love.filesystem.read @path

        output = {}
        section = ""

        i = 1 -- for keeping track of nested layer
        for line in (data .. "\n")\gmatch "(.-)\n"
            temp_section = line\match "^%[([^%[%]]+)%]$"

            if temp_section
                t = output
                for w, d in temp_section\gfind "([%w_]+)(.?)"
                    t[w] = t[w] or {}
                    t = t[w]

                section = temp_section

            p, v = line\match "^([%w|_]+)%s-=%s-(.+)$"

            if p and v
                if tonumber v
                    v = v
                elseif v\match "true"
                    v = true
                elseif v\match "false"
                    v = false
                elseif v\match "\".-\""
                    v = v\match "\"(.-)\""
                else
                    error "unexpected value: " .. v

                if tonumber p
                    p = tonumber p

                t = output
                for w, d in section\gfind "([%w_]+)(.?)"
                    if d == "."
                        t[w] = t[w]
                        t = t[w]
                    else
                        t[w][p] = v
            else
                unless temp_section or "" == line\gsub "^%s*(.-)%s*$", "%1"
                    error "failed trying to match line: " .. line

        output[@namespace]



    ---@brief Sets the path of the backend (required for loading/saving)
    ---
    setPath: (@path) =>

{
    :IniBackend,
}
