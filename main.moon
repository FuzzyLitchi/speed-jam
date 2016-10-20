{graphics:lg,} = love

import Love from require "framework.core"

require "framework.tools.fps_counter"

Love\connect "load", (args) ->

Love\connect "process", (dt) ->

Love\connect "draw", ->
