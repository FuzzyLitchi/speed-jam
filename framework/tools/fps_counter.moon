
import Love from require "framework.core"

import format from string


Love\connect "draw", ->

    fps = format "%07.2f", 1 / love.timer.getAverageDelta!
    mem = format "%013.4f", collectgarbage "count"

    love.graphics.print fps, 0, 0
    love.graphics.print "Mem : #{mem} Kb", 0, 16
