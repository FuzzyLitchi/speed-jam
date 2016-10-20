

tbl = table



--- @brief A scheduler.
---
class Scheduler


    --- @brief Create a new instance.
    ---
    new: =>

        @list = {}




    --- @brief Delay a function call.
    ---
    --- @param time : The time before the call.
    --- @param f : The function to call.
    ---
    delayed: (time, f) =>

        ent = {
            func: f
            time: time
        }


        tbl.insert @list, ent


    --- @brief Call the given function in the idle time.
    ---
    --- @param f : The function to call.
    ---
    differed: (f) =>

        ent = {
            func: f
            time: 0
        }


        tbl.insert @list, ent




    --- @brief Update the scheduler.
    ---
    --- @param dt : The delta-time.
    ---
    process: (dt) =>

        temp = {}


        for i, ent in ipairs @list

            if ent.time <= 0

                ent.func!
                tbl.insert temp, i

            ent.time -= dt


        tbl.sort temp

        for i, idx in ipairs temp

            tbl.remove @list, idx - i + 1



{
    :Scheduler
}
