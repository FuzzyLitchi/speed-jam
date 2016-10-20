
import Object from require "framework.core.object"


import max, min from math

lg = love.graphics



--- @brief A RGB color.
---
--- Public members :
---   - r : Red component (0 - 255)
---   - g : Green component (0 - 255)
---   - b : Blue component (0 - 255)
---
--- Supported meta-methods :
---   - Color + Color
---   - Color - Color
---   - Color * Color
---   - Color / Color
---   - Color * number
---   - Color / number
---
--- Building table parameters :
---   - r : Red component
---   - g : Green component
---   - b : Blue component
---
class Color extends Object


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @type = "Color"

        @r = @_opt t.r, 255
        @g = @_opt t.g, 255
        @b = @_opt t.b, 255

        @clamp!




    --- @brief Create a new instance from 3 numbers.
    ---
    --- Syntaxes :
    ---   - Color\from r, g, b
    ---   - Color\from grey
    ---
    --- @param r : The red component.
    --- @param g : The green component (optional).
    --- @param b : The blue component (optional).
    ---
    --- @return The new instance.
    ---
    @from: (r, g=r, b=r) =>

        return Color {
            :r, :g, :b
        }


    ---@brief Create a new instance from a table of data(r, g, b)
    ---
    --- Syntax:
    ---   - Color\fromData {r: number, g: number, b: number}
    ---
    --- @param data : Table of numbers(r, g, b)
    ---
    --- @return The created color.
    ---
    @fromData: (data) =>

        return Color {
            r: data.r,
            g: data.g,
            b: data.b
        }




    --- @brief Create a copy of the given instance.
    ---
    --- @param col : The instance to copy.
    --- @return The new instance.
    ---
    @copy: (col) =>

        return Color {
            r: col.r, g: col.g, b: col.b
        }




    --- @brief Create a new instance from the current Love2D's color.
    ---
    --- @return The actual Love's color, plus the alpha component.
    ---
    @current: =>

        r, g, b, a = lg.getColor!

        return Color {
            :r, :g, :b
        }, a




    --- @brief Get the serialization of the color.
    ---
    --- @return The serialized color as a table {r: number, g: number, b: number}.
    ---
    getData: =>

        return {
            r: @r,
            g: @g,
            b: @b
        }




    --- @brief Clamps the color components to 0 - 255.
    ---
    clamp: =>

        @r = max 0, min @r, 255
        @g = max 0, min @g, 255
        @b = max 0, min @b, 255




    --- @brief Unpack the color components.
    ---
    --- @return The 3 color components.
    ---
    unpack: =>

        return @r, @g, @b




    --- @brief Operator overload : a + b
    ---
    __add: (other) =>

        return Color {
            r: @r + other.r
            g: @g + other.g
            b: @b + other.b
        }


    --- @brief Operator overload : a - b
    ---
    __sub: (other) =>

        return Color {
            r: @r - other.r
            g: @g - other.g
            b: @b - other.b
        }


    --- @brief Operator overload : a * b
    ---
    __mul: (other) =>

        if type(other) == "number"

            return Color {
                r: @r * other
                g: @g * other
                b: @b * other
            }

        else

            r = ((@r / 255) * (other.r / 255)) * 255
            g = ((@g / 255) * (other.g / 255)) * 255
            b = ((@b / 255) * (other.b / 255)) * 255

            return Color {
                :r, :g, :b
            }


    --- @brief Operator overload : a / b
    ---
    __div: (other) =>

        if type(other) == "number"

            return Color {
                r: @r * other
                g: @g * other
                b: @b * other
            }

        else

            r = ((@r / 255) / (other.r / 255)) * 255
            g = ((@g / 255) / (other.g / 255)) * 255
            b = ((@b / 255) / (other.b / 255)) * 255

            return Color {
                :r, :g, :b
            }



    --- @brief Operator overload : a == b
    ---
    __eq: (other) =>

        return @r == other.r and @g == other.g and @b == other.b




    --- @brief Operator overload : tostring(a)
    ---
    __tostring: =>

        return "Color(#{@r}; #{@g}; #{@b})"




{
    :Color
}
