
import Object from require "framework.core"

import Easing from require "framework.scene_tree.easing"


state = {
    none: 0

    waiting_start: 1
    waiting_repeat: 2

    started: 3
    finished: 4
}



--- @brief A tween.
---
--- Public members :
---   - reference : The referenced member to update.
---   - clock : The clock to use with the tween.
---
--- Signals :
---   - started() : Emitted when the tween starts (after the starting delay).
---   - finished() : Emitted when the tween ends.
---
--- Building table :
---   - ref : The referenced member to update.
---   - clock : The clock to use with the tween.
---   - start_value : The starting value of the easing.
---   - end_value : The end value of the easing.
---   - start_delay : The starting delay.
---   - repeat_delay : The delay between each repeat.
---   - duration : The duration of the easing.
---   - repeat_count : The number of repeat (0 for none, and -1 for infinite).
---   - reflect : Invert the starting and ending value each repeat.
---   - easing : The easing function.
---
class Tween extends Object


    --- @brief Create a new instance from a building table.
    ---
    --- @param t : The building table.
    ---
    new: (t = nil) =>

        super t

        @type = "Tween"

        @reference = t.ref
        @state = state.none

        @clock = t.clock
        @time = 0

        @start_value = t.start_value
        @end_value = t.end_value

        @start_delay = @_opt t.start_delay, 0
        @repeat_delay = @_opt t.repeat_delay, 0

        @duration = @_opt t.duration, 1

        @repeat_count = @_opt t.repeat_count, 0
        @reflect = @_opt t.reflect, false

        @easing = @_opt t.easing, Easing.Linear.InOut


        @addSignal "started"
        @addSignal "finished"



    --- @brief Create a new tween with basic parameters.
    ---
    --- @param ref : The referenced member.
    --- @param startv : The starting value.
    --- @param endv : The ending value.
    --- @param easing : The easing function.
    --- @param duration : The duration of the easing.
    --- @param delay : The delay before the start.
    ---
    --- @return The created tween.
    ---
    @from: (ref, startv, endv, easing, duration, delay=0) =>

        return Tween {
            ref: ref
            start_value: startv
            end_value: endv
            easing: easing
            duration: duration
            start_delay: delay
        }




    --- @brief Update the tween.
    ---
    --- @param dt : The delta-time.
    ---
    process: (dt) =>

        if @state == state.none or @state == state.finished

            return


        if @clock

            @time += @clock\getDeltaTime!

        else

            @time += dt


        if @state == state.waiting_start

            @_processWaitingStart dt

        elseif @state == state.waiting_repeat

            @_processWaitingRepeat dt

        elseif @state == state.started

            @_processStarted dt




    --- @brief Update the tween when it is waiting for start.
    ---
    _processWaitingStart: (dt) =>

        if @time >= @start_delay

            @time = 0
            @state = state.started

            @_updateValue 0

            @emit "started"


    --- @brief Update the tween when it is waiting for repeat.
    ---
    _processWaitingRepeat: (dt) =>

        if @time >= @repeat_delay

            @time = 0
            @state = state.started

            if @reflect
                @invert!

            @_updateValue 0


    --- @brief Update the tween when it is started.
    ---
    _processStarted: (dt) =>

        if @time <= @duration

            @_updateValue @time / @duration

        else

            @_updateValue 1
            @time = 0

            if @repeat_count == 0

                @state = state.finished
                @emit "finished"

            elseif @repeat_count > 0

                @state = state.waiting_repeat

                @repeat_count -= 1

            elseif @repeat_count < 0

                @state = state.waiting_repeat




    --- @brief Update the referenced value.
    ---
    _updateValue: (t) =>

        unless @reference\isValid!

            error "Reference not valid"


        if t == 0

            @reference\set "value", @start_value

        elseif t == 1

            @reference\set "value", @end_value

        else

            v = @start_value + (@end_value - @start_value) * @.easing t

            @reference\set "value", v




    --- @brief Inverts the starting and ending value.
    ---
    invert: =>

        temp = @start_value
        @start_value = @end_value
        @end_value = temp




    --- @brief Starts the tween.
    ---
    start: =>

        @state = state.waiting_start
        @time = 0


    --- @brief Cancels the tween.
    ---
    cancel: =>

        @state = state.none


    --- @brief Finishs the tween.
    ---
    finish: =>

        @state = state.finished

        @_updateValue 1

        @finished\emit!




    --- @brief Checks if the tween is started.
    ---
    isStarted: =>

        return @state != state.none and @state != state.finished



    --- @brief: Checks if the tween is finished.
    ---
    isFinished: =>

        return @state == state.none or @state == state.finished




{
    :Tween
}
