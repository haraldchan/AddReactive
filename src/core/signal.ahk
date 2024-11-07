class signal {
    /**
     * Creates a reactive signal variable.
     * @param {any} initialValue The initial value of the signal.This argument is ignored after the initial render.
     * @return {Signal}
     */
    __New(val) {
        this.value := isPlainObject(val) ? this.mapify(val) : val
        this.subs := []
        this.comps := []
        this.effects := []
        this.type := ""
    }

    /**
     * Set the new value of the signal.
     * @param {any} newSignalValue New state of the signal. Also accept function object.
     * @returns {void} 
     */
    set(newSignalValue) {
        if (this.type is Struct) {
            validateInstance := this.type.new(this.value.mapify())
            validateInstance := ""
        } else if (this.type != "") {
            checkType(newSignalValue, this.type)
        }

        prevValue := this.value

        if (newSignalValue == this.value) {
            return
        }

        this.value := newSignalValue is Func ? newSignalValue(this.value) : newSignalValue

        ; change to Map()
        if (newSignalValue.base == Object.Prototype) {
            this.value := this.mapify(this.value)
        }

        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update(this)
        }

        ; notify all computed signals
        for comp in this.comps {
            comp.sync(this)
        }

        ; run all effects
        for effect in this.effects {
            if (effect.MaxParams = 1) {
                effect(this.value)
            } else if (effect.MaxParams = 2) {
                effect(this.value, prevValue)
            } else {
                effect()
            }
        }
    }

    /**
     * Updates a specific field of Object/Map value.
     * @param key index/key of the field.
     * @param newValue New value to assign.
     */
    update(key, newValue) {
        if (!(this.value is Object)) {
            throw TypeError(Format("update can only handle Array/Object/Map; `n`nCurrent Type: {2}", Type(newValue)))
        }

        if (this.value is Map) {
            updater := Map()
        } else if (this.value is Array) {
            updater := []
        }

        updater := this.value
        updater[key] := newValue

        this.set(updater)
    }

    /**
     * Sets the type of value.
     * ```
     * num := signal(0).as(Integer)
     * 
     * str := signal("").as(String)
     * ```
     * @param {Class|Struct} type Classes or Struct to set.
     */
    as(type) {
        if (type is Struct) {
            ; try creating the same struct, not matching, it will throw error.
            validateInstance := type.new(this.value.mapify())
            validateInstance := ""
        } else {
            checkType(this.value, type)
        }
        
        this.type := type
        return this
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }

    addComp(computed) {
        this.comps.Push(computed)
    }

    addEffect(effectFn) {
        this.effects.Push(effectFn)
    }

    mapify(obj) {
        if (!(obj is Object)) {
            return obj
        }
        return JSON.parse(JSON.stringify(obj))
    }
}