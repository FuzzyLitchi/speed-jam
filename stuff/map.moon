
import SceneNode, Vector, Tween, Easing from require "framework.scene_tree"
import Object from require "framework.core"

GRID_SIZE = 16

----------------------------------
-- A thing that moves on map.
----------------------------------
class MapNode extends SceneNode

    new: (t = {}) =>
        super t

        @map_position = @_opt t.map_position, Vector {
            x: @transform.position.x % GRID_SIZE
            y: @transform.position.y % GRID_SIZE
        }

        @type = "MapNode"

        @can_process = true

    _process: (dt) =>
        if (@transform.position - @map_position * GRID_SIZE)\length! > 0
            t = @\tween "position", @transform.position, @map_position, Easing.Quad
            t\start!

----------------------------------
-- Handling nothing. Just stands there.
-- ... also representing a grid. <3
----------------------------------
class Map extends Object
    new: (t = {}) =>
        @w = @_opt t.w, 32
        @h = @_opt t.h, 32

        @grid = {}
        for x = 1, @w
            row = {}
            for y = 1, @h
                row[#row + 1] = 0
            @grid[x] = row

    get_field: (x, y) =>
        (@grid[x][y])

    set_field: (x, y, a) =>
        @grid[x][y] = a

    field_empty: (x, y) =>
        (0 == @\get_field x, y)

    draw_map: =>
      for x = 1, @w
        for y = 1, @h
          if (x+y)%2==0
            --draw black
          else
            --draw white
