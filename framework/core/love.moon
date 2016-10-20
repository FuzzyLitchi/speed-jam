
import Object from require "framework.core.object"
import Color from require "framework.core.color"


ls = love.system
lg = love.graphics
lw = love.window



--- @brief A Love interface.
---
--- Signals :
---   - load
---   - process
---   - draw
---   - directory-dropped
---   - errhand
---   - file-dropped
---   - focus
---   - key-pressed
---   - key-released
---   - low-memory
---   - mouse-focus
---   - mouse-moved
---   - mouse-pressed
---   - mouse-released
---   - quit
---   - resize
---   - text-edited
---   - text-input
---   - thread-error
---   - touch-moved
---   - touch-pressed
---   - touch-released
---   - visible
---   - wheel-moved
---   - gamepad-axis
---   - gamepad-pressed
---   - gamepad-released
---   - joystick-added
---   - joystick-axis
---   - joystick-hat
---   - joystick-pressed
---   - joystick-released
---   - joystick-removed
---
--- Properties :
---   - clipboard [get, set] :
---   - title [get, set] :
---   - color [get, set] :
---   - background_color [get, set] :
---   - alpha [get, set] :
---   - canvas [get, set] :
---
class _Love extends Object

    new: =>

        super {
            signals: {
                "load"
                "process"
                "draw"

                "directory-dropped"
                "errhand"
                "file-dropped"
                "focus"

                "key-pressed"
                "key-released"

                "low-memory"

                "mouse-focus"
                "mouse-moved"
                "mouse-pressed"
                "mouse-released"

                "quit"
                "resize"
                "text-edited"
                "text-input"
                "thread-error"

                "touch-moved"
                "touch-pressed"
                "touch-released"

                "visible"
                "wheel-moved"

                "gamepad-axis"
                "gamepad-pressed"
                "gamepad-released"
                "joystick-added"
                "joystick-axis"
                "joystick-hat"
                "joystick-pressed"
                "joystick-released"
                "joystick-removed"
            }

            properties: {
                {"clipboard", "getClipboard", "setClipboard"}
                {"title", "getTitle", "setTitle"}
                {"color", "getColor", "setColor"}
                {"background_color", "getBackgroundColor", "setBackgroundColor"}
                {"alpha", "getAlpha", "setAlpha"}
                {"canvas", "getCanvas", "setCanvas"}
            }
        }

        @type = "Love"
        @name = "LoveInterface"




    --- @brief Get the clipboard's content.
    ---
    getClipboard: =>

        return ls.getClipboardText!


    --- @brief Set the clipboard's content.
    ---
    setClipboard: (v) =>

        ls.setClipboardText tostring v




    --- @brief Get the window's title.
    ---
    getTitle: =>

        return lw.getTitle!


    --- @brief Set the window's title.
    setTitle: (v) =>

        lw.setTitle tostring v




    --- @brief Get the actual drawing color.
    ---
    getColor: =>

        r, g, b, a = lg.getColor!

        return Color\from r, g, b

    --- @brief Set the actual drawing color.
    ---
    setColor: (v) =>

        r, g, b, a = lg.getColor!

        lg.setColor v.r, v.g, v.b, a




    --- @brief Get the background color.
    ---
    getBackgroundColor: =>

        r, g, b, a = lg.getBackgroundColor!

        return Color\from r, g, b


    --- @brief Set the background color.
    ---
    setBackgroundColor: (v) =>

        lg.setBackgroundColor v.r, v.g, v.b, 255




    --- @brief Get the actual drawing alpha.
    ---
    getAlpha: =>

        r, g, b, a = lg.getColor!

        return a


    --- @brief Set the actual drawing alpha.
    ---
    setAlpha: (v) =>

        r, g, b, a = lg.getColor!

        lg.setColor r, g, b, v




    --- @brief Get the actual drawing canvas.
    ---
    getCanvas: =>

        return lg.getCanvas!


    --- @brief Set the actual drawing canvas.
    ---
    setCanvas: (v) =>

        lg.setCanvas v




Love = _Love!



love.load = (args) ->

    Love\emit "load", args


love.update = (dt) ->

    Love\emit "process", dt

love.draw = ->

    Love\emit "draw"



love.directorydropped = (path) ->

	Love\emit "directory-dropped", path

love.errhand_ = (msg) ->

	Love\emit "errhand", msg

love.filedropped = (file) ->

	Love\emit "file-dropped", file

love.focus = (focus) ->

	Love\emit "focus", focus

love.keypressed = (key, scancode, isrepeat) ->

	Love\emit "key-pressed", key, scancode, isrepeat

love.keyreleased =  (key, scancode) ->

	Love\emit "key-released", key, scancode

love.lowmemory = ->

	Love\emit "low-memory"

love.mousefocus = (focus) ->

	Love\emit "mouse-focus", focus

love.mousemoved = (x, y, dx, dy, istouch) ->

	Love\emit "mouse-moved", x, y, dx, dy, istouch

love.mousepressed = (x, y, button, istouch) ->

	Love\emit "mouse-pressed", x, y, button, istouch

love.mousereleased = (x, y, button, istouch) ->

	Love\emit "mouse-released", x, y, button, istouch

love.quit = ->

	Love\emit "quit"

love.resize = (w, h) ->

	Love\emit "resize", w, h

love.textedited = (text, start, length) ->

	Love\emit "text-edited", text, start, length

love.textinput = (text) ->

	Love\emit "text-input", text

love.threaderror = (thread, errorstr) ->

	Love\emit "thread-error", thread, errorstr

love.touchmoved = (id, x, y, dx, dy, pressure) ->

	Love\emit "touch-moved", id, x, y, dx, dy, pressure

love.touchpressed = (id, x, y, dx, dy, pressure) ->

	Love\emit "touch-pressed", id, x, y, dx, dy, pressure

love.touchreleased = (id, x, y, dx, dy, pressure) ->

	Love\emit "touch-released", id, x, y, dx, dy, pressure

love.visible = (visible) ->

	Love\emit "visible", visible

love.wheelmoved = (x, y) ->

	Love\emit "wheel-moved", x, y



love.gamepadaxis = (joystick, axis, value) ->

	Love\emit "gamepad-axis", joystick, axis, value

love.gamepadpressed = (joystick, button) ->

	Love\emit "gamepad-pressed", joystick, button

love.gamepadreleased = (joystick, button) ->

	Love\emit "gamepad-released", joystick, button

love.joystickadded = (added) ->

	Love\emit "joystick-added", addded

love.joystickaxis = (joystick, axis, value) ->

	Love\emit "joystick-axis", joystick, axis, value

love.joystickhat = (joystick, hat, direction) ->

	Love\emit "joystick-hat", joystick, hat, direction

love.joystickpressed = (joystick, button) ->

	Love\emit "joystick-pressed", joystick, button

love.joystickreleased = (joystick, button) ->

	Love\emit "joystick-released", joystick, button

love.joystickremoved = (joystick) ->

	Love\emit "joystick-removed", joystick



{
    :Love
}
