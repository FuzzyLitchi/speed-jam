
import Object from require "framework.core"


import sqrt, min, max from math
lg = love.graphics


--- @brief A 2D vector.
---
--- Supports the following meta-methods:
---   - Vector + Vector
---   - Vector - Vector
---   - Vector * Vector
---   - Vector / Vector
---   - Vector == Vector
---   - -Vector
---   - Vector * number
---   - Vector / number
---
--- Building table parameters :
---   - x : The X position of the vector (optional).
---   - y : The Y position of the vector (optional).
---
class Vector extends Object



    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @type = "Vector"

        @x = @_opt t.x, 0
        @y = @_opt t.y, 0




    --- @brief Create a new instance from two scalars.
    ---
    --- Syntaxes:
    ---   - Vector\from number
    ---   - Vector\from number, number
    ---
    --- @param x : The X position.
    --- @param y : The Y position (optional).
    ---
    --- @return The created vector.
    ---
    @from: (x, y=x) =>

        return Vector {:x, :y}


    ---@brief Create a new instance from a table of data(x, y)
    ---
    --- Syntaxes:
    ---   - Vector\fromData {x: number, y: number}
    ---   - Vector\fromData {x: number}
    ---
    --- @param data : Table of positions(x, y)
    ---
    --- @return The created vector.
    ---
    @fromData: (data) =>

        return Vector {x: data.x, y: data.y or data.x}


    --- @brief Create a copy of the given instance.
    ---
    --- @param vec : Vector to copy.
    ---
    --- @return The created vector.
    ---
    @copy: (vec) =>

        return Vector {x: vec.x, y: vec.y}




    --- @brief Get the top vector.
    ---
    --- @return The top vector (0; 1).
    ---
    @top: =>

        return Vector {x: 0, y: 1}


    --- @brief Get the bottom vector.
    ---
    --- @return The bottom vector (0; -1).
    ---
    @bottom: =>

        return Vector {x: 0, y: -1}


    --- @brief Get the right vector.
    ---
    --- @return The right vector (1; 0).
    ---
    @right: =>

        return Vector {x: 1, y: 0}


    --- @brief Get the left vector.
    ---
    --- @return The left vector (-1; 0).
    ---
    @left: =>

        return Vector {x: -1, y: 0}


    --- @brief Get the angle between two vectors.
    ---
    --- @param a : The first vector.
    --- @param b : The second vector.
    ---
    --- @return The angnle between the two vectors (a, b).
    ---
    @angleBetween: (a, b) =>
        cross = a.x * b.y - a.y * b.x
        dot   = a.x * b.x + a.y * b.y

        (math.atan2 cross, dot)




    --- @brief Get the squared length of the vector.
    ---
    --- @return The squared length of the vector.
    ---
    lengthSquared: =>

        return @x*@x + @y*@y


    --- @brief Get the length of the vector.
    ---
    --- @return The length of the vector.
    ---
    length: =>

        return sqrt @x*@x + @y*@y





    --- @brief Get the serialization of the vector.
    ---
    --- @return The serialized vector as a table {x: number, y: number}.
    ---
    getData: =>
      return {x: @x, y: @y}




    --- @brief Get the inverted vector of the current instance.
    ---
    --- 1 / Vector
    ---
    --- @return The inverted vector.
    ---
    inverted: =>

        x = 0
        y = 0

        if @x != 0

            x = 1 / @x

        if @y != 0

            y = 1 / @y


        return Vector {:x, :y}


    --- @brief Invert the current instance.
    ---
    --- 1 / Vector
    ---
    --- @return The current instance.
    ---
    invert: =>

        if @x != 0

            @x = 1 / @x

        if @y != 0

            @y = 1 / @y


        return @

    --- @brief Get the angle between the vector and another.
    ---
    --- @param b : The vector to get angle to.
    ---
    --- @return The angle between the vector and the other (b).
    ---
    angleBetween: (b) =>
        cross = @x * b.y - @y * b.x
        dot   = @x * b.x + @y * b.y

        (math.atan2 cross, dot)



    --- @brief Get rotated copy of the vector.
    ---
    --- @param a : The angle of rotation.
    ---
    --- @return The rotated copy of the vector.
    ---
    rotated: (a) =>
        return Vector {
            @x * (math.cos a) - @y * math.sin a,
            @x * (math.sin a) - @y * math.cos a,
        }

    --- @brief Rotate the vector by a given angle.
    ---
    --- @param a : The angle of rotation.
    ---
    --- @return The newly rotated vector.
    ---
    rotate: (a) =>
        @x = @x * (math.cos a) - @y * math.sin a
        @y = @x * (math.sin a) - @y * math.cos a

        @




    --- @brief Operator overload : a + b
    ---
    __add: (other) =>

        return Vector {
            x: @x + other.x
            y: @y + other.y
        }


    --- @brief Operator overload : a - b
    ---
    __sub: (other) =>

        return Vector {
            x: @x - other.x
            y: @y - other.y
        }


    --- @brief Operator overload : a * b
    ---
    __mul: (other) =>

        if type(other) == "number"

            return Vector {
                x: @x * other
                y: @y * other
            }

        else

            return Vector {
                x: @x * other.x
                y: @y * other.y
            }


    --- @brief Operator overload : a / b
    ---
    __div: (other) =>

        if type(other) == "number"

            return Vector {
                x: @x / other
                y: @y / other
            }

        else

            return Vector {
                x: @x / other.x
                y: @y / other.y
            }


    --- @brief Operator overload : -a
    ---
    __unm: =>

        return Vector {x: -@x, y: -@y}


    --- @brief Operator overload : a == b
    ---
    __eq: (other) =>

        return @x == other.x and @y == other.y


    --- @brief Operator overload : tostring a
    ---
    __tostring: =>

        return "Vector(#{@x}; #{@y})"





--- @brief A 2D rectangle, constructed by 2 vectors.
---
--- Public members :
---   - a : The top-left corner's position.
---   - b : The bottom-right corner's position.
---
--- Properties :
---   - size [get, set] : Get/set the size of the rectangle.
---   - center [get, set] : Get/set the center vector of the rectangle.
---
--- Building table arguments (processed in this order) :
---   - a : The top-left corner's position.
---   - b : The bottom-right corner's position.
---   - size : The size of the rectangle.
---   - center : The center of the rectangle.
---
class Rectangle extends Object


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : Building table.
    ---
    new: (t = {}) =>

        super t

        @type = "Rectangle"

        @a = @_opt t.a, Vector!
        @b = @_opt t.b, Vector!


        @property "size", "getSize", "setSize"
        @property "center", "getCenter", "setCenter"


        if t.size

            @set "size", t.size


        if t.center

            @set "center", t.center

    ---@brief Create a new instance from a table of data(a, b)
    ---
    --- Syntax:
    ---   - Rectangle\fromData {a: vector, b: vector}
    ---
    --- @param data : Table of positions(a, b)
    ---
    --- @return The created rectangle.
    ---
    @fromData: (data) =>

      return Rectangle {a: data.a, b: data.b}

    --- @brief Get the serialization of the rectangle.
    ---
    --- @return The serialized rectangle as a table {a: vector, b: vector}.
    ---
    getData: =>

      return {a: @a, b: @b}


    --- @brief @get "size"
    ---
    getSize: =>

        return @a - @b


    --- @brief @set "size"
    ---
    setSize: (size) =>

        @b = @a + size




    --- @brief @get "center"
    ---
    getCenter: =>

        return @a + @size / 2


    --- @brief @set "center"
    ---
    setCenter: (center) =>

        @a = center - @size / 2




    --- @brief Check if the given vector is in the current rectangle.
    ---
    --- @param vec : The vector.
    --- @return True if the vector is in the rectangle.
    ---
    contains: (vec) =>

        unless @a.x > vec.x and @b.x < vec.x and @a.y > vec.y and @b.y < vec.y

            return false

        return true


    --- @brief Check if the given rectangle intersects the current one.
    ---
    --- @param rect : The second rectangle.
    --- @param dest : The rectangle where to save the intersection rectangle
    ---               (optional).
    ---
    --- @return True if the rectangles intersect.
    ---
    intersect: (rect, dest=nil) =>

        left = max @a.x, rect.a.x
        top = max @a.y, rect.a.y
        right = min @b.x, rect.b.x
        bottom = min @b.y, rect.b.y

        if left < right and top < bottom

            if dest

                dest.a = Vector\from left, top
                dest.b = Vector\from right, bottom

            return true


        return false




--- @brief A linear transformation matrix.
---
--- @note Only usable for computing and can't be converted to a Transform.
---
class Matrix extends Object


   --- @brief Create a new instance.
   ---
   --- @param a : Nil, or a 3x3 indexed table.
   ---
   new: (a = nil) =>

       super!

       @type = "Matrix"


       @m = {
           1, 0, 0,
           0, 1, 0,
           0, 0, 1
       }


       if a == nil

           return


       if type(a) == "table" and #a == 9

           @m = {
               a[1], a[2], a[3],
               a[4], a[5], a[5],
               a[6], a[7], a[8]
           }


       else

           error "Invalid arguments."



   --- @brief Create a copy of the given matrix.
   ---
   --- @return A copy of the given matrix.
   ---
   @copy: (m) =>

       return Matrix m.m




   --- @brief Get the inverted matrix.
   ---
   --- @return The inverted matrix.
   ---
   getInverted: =>

       det  = @m[1] * ( @m[5] * @m[9] - @m[6] * @m[8] )
       det -= @m[2] * ( @m[4] * @m[9] - @m[6] * @m[7] )
       det += @m[3] * ( @m[4] * @m[8] - @m[5] * @m[7] )


       if det != 0

           a = {
                ( @m[5] * @m[9] - @m[6] * @m[8] ) / det
               -( @m[2] * @m[9] - @m[3] * @m[8] ) / det
                ( @m[2] * @m[6] - @m[3] * @m[5] ) / det

               -( @m[4] * @m[9] - @m[6] * @m[7] ) / det
                ( @m[1] * @m[9] - @m[3] * @m[7] ) / det
               -( @m[1] * @m[6] - @m[3] * @m[4] ) / det

                ( @m[4] * @m[8] - @m[5] * @m[7] ) / det
               -( @m[1] * @m[8] - @m[2] * @m[7] ) / det
                ( @m[1] * @m[5] - @m[2] * @m[4] ) / det
           }

           return Matrix a

       else

           return Matrix!




   --- @brief Transform a vector.
   ---
   --- @param vec : The vector to transform.
   ---
   --- @return The transformed vector.
   ---
   transformVector: (vec) =>

       fx = @m[1] * vec.x + @m[2] * vec.y + @m[3]
       fy = @m[4] * vec.x + @m[5] * vec.y + @m[6]

       return Vector fx, fy


   --- @brief Transform a 2D rectangle.
   ---
   --- @param rect : The rectangle to transform.
   ---
   --- @return The transformed rectangle.
   ---
   transformRect: (rect) =>

       pos = rect.a
       size = rect\get "size"

       points = {
           @transformVector(pos.x,          pos.y)
           @transformVector(pos.x,          pos.y + size.y)
           @transformVector(pos.x + size.x, pos.y)
           @transformVector(pos.x + size.x, pos.y + size.y)
       }

       left = points[1].x
       right = points[1].x
       top = points[1].y
       bottom = points[1].y


       for _, p in ipairs points

           if p.x < left
               left = p.x
           elseif p.x > right
               right = p.x

           if p.y < top
               top = p.y
           elseif p.y > bottom
               bottom = p.y

       return Rectangle {a: Vector(left, top), b: Vector(right, bottom)}




   --- @brief Combine the current matrix with the given one.
   ---
   --- @param m : The second matrix.
   ---
   --- @return self
   ---
   combine: (m) =>

       m = m.m

       c = {
           @m[1] * m[1] + @m[2] * m[4] + @m[3] * m[7],
           @m[1] * m[2] + @m[2] * m[5] + @m[3] * m[8],
           @m[1] * m[3] + @m[2] * m[6] + @m[3] * m[9],

           @m[4] * m[1] + @m[5] * m[4] + @m[6] * m[7],
           @m[4] * m[2] + @m[5] * m[5] + @m[6] * m[8],
           @m[4] * m[3] + @m[5] * m[6] + @m[6] * m[9],

           @m[7] * m[1] + @m[8] * m[4] + @m[9] * m[7],
           @m[7] * m[2] + @m[8] * m[5] + @m[9] * m[8],
           @m[7] * m[3] + @m[8] * m[6] + @m[9] * m[9]
       }


       for i, v in ipairs c

           @m[i] = v


       return self


   --- @brief Get the combine operation of the current and the given matrix.
   ---
   --- @param m : Second matrix.
   ---
   --- @return The transformed matrix.
   ---
   getCombined: (m) =>

       return Matrix(@m)\combine m




   --- @brief Apply a translation matrix on the current one.
   ---
   --- @param vec : The translation vector.
   ---
   --- @return self
   ---
   translate: (vec) =>

       m = Matrix {

           1, 0, vec.x,
           0, 1, vec.y,
           0, 0, 1

       }

       return @combine m




   --- @brief Apply a rotation matrix on the current one.
   ---
   --- @param angle : The rotation angle.
   --- @param center : The center vector of the rotation.
   ---
   --- @param self
   ---
   rotate: (angle, center = Vector!) =>

       rad = angle * math.pi / 180

       cos = m.cos angle
       sin = m.sin angle

       m = Matrix {

           cos, -sin, center.x * (1 - cos) + center.y * sin,
           sin,  cos, center.y * (1 - cos) - center.x * sin,
           0,    0,   1

       }

       return @combine m




   --- @brief: Apply a scaling matrix on the current one.
   ---
   --- @param vec : The scaling vector.
   --- @param center : The scaling center.
   ---
   --- @return self
   ---
   scale: (vec, center = Vector!) =>

       m = Matrix {

           vec.x, 0,     center.x * (1 - vec.x),
           0,     vec.y, center.y * (1 - vec.y),
           0,     0,     1

       }

       return @combine m




--- @brief A 2D transformation.
---
--- @note Only usable with Love2D coordinate system and can be converted to a
---     Matrix
---
--- Public members :
---   - position : The position vector.
---   - origin : The origin vector.
---   - scale : The scale vector.
---   - shear : The shear vector.
---   - rotation : The rotation angle.
---
--- Building table :
---   - position : The position vector.
---   - origin : The origin vector.
---   - scale : The scale vector.
---   - shear : The shear vector.
---   - rotation : The rotation angle.
---   - x, y : The position.
---   - ox, oy : The origin.
---   - sx, sy : The scale.
---   - r : The rotation.
---
class Transform extends Object


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = {}) =>

        super t

        @type = "Transform"

        @position = @_opt t.position, Vector!
        @origin = @_opt t.origin, Vector!
        @scale = @_opt t.scale, Vector\from 1, 1
        @shear = @_opt t.shear, Vector!

        @rotation = @_opt t.rotation, 0


        if t.x and t.y

            @position = Vector\from t.x, t.y

        if t.ox and t.oy

            @origin = Vector\from t.ox, t.oy

        if t.sx and t.sy

            @origin = Vector\from t.sx, t.sy

        if t.kx and t.ky

            @shear = Vector\from t.kx, t.ky

        if t.r

            @rotation = t.r


    --- @brief Create a new copy of the given instance.
    ---
    --- @param other : The instance to copy.
    --- @return The created instance.
    ---
    @copy: (other) =>

        return Transform {
            position: Vector\copy other.position
            origin: Vector\copy other.origin
            scale: Vector\copy other.scale
            shear: Vector\copy other.shear
            rotation: other.rotation
        }




    --- @brief Get the transform into the love.graphics.draw format.
    ---
    --- @return The last arguments for love.graphics.draw.
    ---
    toArgs: =>

        return @position.x, @position.y, @rotation, @scale.x, @scale.y, @origin.x, @origin.y, @shear.x, @shear.y




    --- @brief Apply the transform.
    ---
    apply: =>

        lg.translate @position.x, @position.y
        lg.rotate @rotation
        lg.scale @scale.x, @scale.y
        lg.shear @shear.x, @shear.y
        lg.translate -@origin.x, -@origin.y


    --- @brief Undo the transform.
    ---
    undo: =>

        lg.translate @origin.x, @origin.y
        lg.shear -@shear.x, -@shear.y
        lg.scale 1 / @scale.x, 1 / @scale.y
        lg.rotate -@rotation
        lg.translate -@position.x, -@position.y




    --- @brief Get the matrix of the transformation.
    ---
    --- @return The matrix corresponding to the actual transformation.
    ---
    getMatrix: =>

        m = Matrix!

        m\translate @position
        m\rotate @rotation
        m\scale @scale
        m\shear @shear
        m\translate -@origin

        return m


    --- @brief Get the matrix of the inverted transformation.
    ---
    --- @return The matrix corresponding to the actual transformation inverted.
    ---
    getInvertedMatrix: =>

        m = Matrix!

        m\translate @origin
        m\shear -@shear
        m\scale @scale\inverted!
        m\rotate -@rotation
        m\translate -@position

        return m


{
    :Vector,
    :Matrix,
    :Transform
}
