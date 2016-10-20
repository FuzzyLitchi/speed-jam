

tbl = table



--- @brief A signal where functions can be connected.
---
class Signal


    --- @brief Create a new instance.
    ---
    --- @param sch : A scheduler (optional).
    ---
    new: (sch = nil)=>

        @list = {}
        @scheduler = sch

        @_in_emit = false
        @_to_remove = {}




    --- @brief Connect a function to the signal.
    ---
    --- @param f : The function to connect.
    --- @param one_shot : The function will be called once ? (false by default)
    --- @param differed : Differate the function call (false by default)
    ---
    connect: (f, one_shot = false, differed = false) =>

        ent = {
            func: f
            one_shot: one_shot
            differed: differed
        }


        if differed and @scheduler == nil

            error "Can't differate a function because there are no scheduler"


        tbl.insert @list, ent


    --- @brief Disconnect a function from the signal.
    ---
    --- @param f : The function to disconnect.
    ---
    disconnect: (f) =>

        for i, ent in ipairs @list

            if ent.func == f

                if not @_in_emit

                    tbl.remove @list, i

                else

                    tbl.insert @_to_remove, i

                return




    --- @brief Emit the signal.
    ---
    --- @param ... : Parameters to pass to the functions.
    ---
    __call: (...) =>

        @_in_emit = true

        for idx, entry in ipairs @list

            if not entry.differed

                entry.func ...

            else

                func = entry.func
                args = {...}

                @scheduler\differed ->
                    func unpack args


            if entry.one_shot

                tbl.insert @_to_remove, idx


        tbl.sort @_to_remove


        for i, idx in ipairs @_to_remove

            tbl.remove @list, idx - i + 1


        @_to_remove = {}
        @_in_emit = false




{
    :Signal
}
