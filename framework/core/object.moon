
import Signal from require "framework.core.signal"
import Scheduler from require "framework.core.scheduler"


--- @brief Basic class for every framework's objects.
---
--- Contains a property systems.
---
--- Public member(s) :
---  - type [readonly] : Get the class' name.
---  - name : Get/set the instance's name.
---
class Object


    --- @brief Contructor
    ---
    --- Create a new instance from a building table.
    ---
    --- @param t : Building table.
    ---
    new: (t = {}) =>

        @type = "Object"
        @name = nil

        @scheduler = @_opt t.scheduler, Scheduler!

        @signals = {}

        @getters = {}
        @setters = {}


        if t.properties

            for prop in *t.properties

                @property prop[1], prop[2], prop[3]


        if t.signals

            for signal in *t.signals

                @addSignal signal



    --- @brief Optional parameter in building tables.
    ---
    --- @param v : The value of the parameter.
    --- @param def : The default value.
    ---
    --- @return The value of the parameter if not nil, or the default one.
    ---
    _opt: (v, def) =>

        unless v != nil

            return def

        return v




    --- @brief Create a new property.
    ---
    --- @param name : The property's name.
    --- @param getter : The getter method's name.
    --- @param setter : The setter method's name.
    ---
    property: (name, getter, setter) =>

        @getters[name] = @[getter]
        @setters[name] = @[setter]




    --- @brief Get a field in the object.
    ---
    --- @param name : The field name.
    --- @return The value of the field.
    ---
    get: (name) =>

        if @getters[name]

            return @getters[name] @


        return @[name]


    --- @brief Set a field in the object.
    ---
    --- @param name : The field's name.
    --- @param value : The new field's value.
    ---
    --- @return The new value of the field.
    ---
    set: (name, value) =>

        if @setters[name]

            return @setters[name] @, value


        @[name] = value
        return value




    --- @brief Add a signal to the object.
    ---
    --- @param name : The signal's name.
    ---
    addSignal: (name) =>

        if @signals[name] != nil

            error "Signal #{name} already exists."

        @signals[name] = Signal @scheduler




    --- @brief Connect a function to a signal.
    ---
    --- @param name : The signal's name.
    --- @param f : The function to connect.
    --- @param one_shot : The function will be called once ? (false by default)
    --- @param differed : Differate the function call (false by default)
    ---
    connect: (name, f, one_shot = false, differed = false) =>

        unless @signals[name] != nil

            error "No signal #{name}"

        @signals[name]\connect f, one_shot, differed


    --- @brief Disconnect a function from a signal.
    ---
    --- @param name : The signal's name.
    --- @param f : The function to disconnect.
    ---
    disconnect: (name, f) =>

        unless @signals[name] != nil

            error "No signal #{name}"

        @signals[name]\disconnect f


    --- @brief Emit a signal.
    ---
    --- @param name : The signal's name.
    --- @param ... : Arguments passed to the signal.
    ---
    emit: (name, ...) =>

        unless @signals[name] != nil

            error "No signal #{name}"

        @signals[name] ...



{
    :Object
}
