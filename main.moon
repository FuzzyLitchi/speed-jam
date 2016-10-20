{graphics:lg,} = love

import Love from require "framework.core"
import ScneeNode from require "framework.scene_tree"

require "framework.tools.fps_counter"

Love\connect "load", (args) ->

Love\connect "process", (dt) ->

Love\connect "draw", ->
