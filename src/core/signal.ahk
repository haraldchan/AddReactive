class signal {
    /**
     * Creates a reactive signal variable.
     * ```
     * count := signal(0)
     * current := count.value ; current: 0
     * 
     * ; change the value by .set(value) or .set(callback)
     * count.set(3)
     * count.set(cur => cur + 2)
     * ```
     * @param {any} initialValue The initial value of the signal.This argument is ignored after the initial render.
     * @return {Signal}
     */
    __New(initialValue) {
        this.value := isPlainObject(initialValue) || initialValue is Array || initialValue is Map
            ? this._mapify(initialValue) 
            : initialValue
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
        if (newSignalValue == this.value) {
            return
        }

        ; validates new value if it matches the Struct
        if (this.type is Struct) {
            validateInstance := newSignalValue is Struct.StructInstance
                ? this.type.new(newSignalValue.mapify())
                : this.type.new(newSignalValue)
            validateInstance := ""
        } else if (this.type is Array && this.type[1] is Struct) {
            for item in this.value {
                validateInstance := item is Struct.StructInstance
                    ? this.type[1].new(item.mapify())
                    : this.type[1].new(item)
                validateInstance := ""
            }
        } else if (this.type != "") {
            checkType(newSignalValue, this.type)
        }

        prevValue := this.value

        this.value := newSignalValue is Func ? newSignalValue(this.value) : newSignalValue

        ; change to Map()
        if (isPlainObject(newSignalValue) || newSignalValue is Array || newSignalValue is Map) {
            this.value := this._mapify(this.value)
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
     * @param {Array|any} key index/key of the field.
     * @param newValue New value to assign of mutation function.
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
        (key is Array) ? this._setExactMatch(key, updater, newValue) : this._setFirstMatch(key, updater, newValue)

        this.set(updater)
    }

    ; find nested key by exact query path
    _setExactMatch(keys, item, newValue, index := 1) {
        if (index == keys.Length) {
            item[keys[index]] := newValue is Func ? newValue(item[keys[index]]) : newValue
            return
        }

        for k, v in item {
            if (k == keys[index]) {
                this._setExactMatch(keys, v, newValue, index + 1)
            }
        }
    }

    ; find the first matching key
    _setFirstMatch(key, item, newValue) {
        if (item.Has(key)) {
            item[key] := newValue is Func ? newValue(item[key]) : newValue
            return
        }

        for k, v in item {
            if (v is Map || v is Struct.StructInstance) {
                this._setFirstMatch(key, v, newValue)
            }
        }
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
    as(datatype) {
        this.type := datatype

        if (datatype is Struct) {
            ; try creating the same struct instance for validate.
            validateInstance := this.value is Struct.StructInstance
                ? this.type.new(this.value.mapify())
                : this.type.new(this.value)
            validateInstance := ""
            
        } else if (datatype is Array && datatype[1] is Struct) {
            for item in this.value {
                validateInstance := item is Struct.StructInstance
                    ? this.type[1].new(item.mapify())
                    : this.type[1].new(item)
                validateInstance := ""
            }
        } else {
            checkType(this.value, datatype)
        }

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

    _mapify(obj) {
        if (!(obj is Object)) {
            return obj
        }
        return JSON.parse(JSON.stringify(obj))
    }
}