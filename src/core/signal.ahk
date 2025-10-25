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
        this.initValue := this.value
        this.subs := []
        this.comps := []
        this.effects := []
        this.type := ""
        this.debugger := false
        
        ; debug mode
        if (!IsSet(DebugUtils) && !IsSet(debugger)) {
            return
        }

        if (ARConfig.debugMode && !(this is debugger)) {
            this.createDebugger := DebugUtils.createDebugger
            this.debugger := this.createDebugger(this)
            if (InStr(this.debugger.value["caller"]["file"], "\AddReactive\devtools")) {
                this.debugger := false
            } else {
                IsSet(CALL_TREE) && CALL_TREE.addDebugger(this.debugger)
            }
        }
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
            validateInstance := this.type.new(newSignalValue is Struct.StructInstance ? newSignalValue.mapify() : newSignalValue)
            validateInstance := ""
        } else if (this.type is Array && this.type[1] is Struct) {
            for item in newSignalValue {
                validateInstance := this.type[1].new(item is Struct.StructInstance ? item.mapify() : item)
                validateInstance := ""
            }
        } else if (this.type != "") {
            checkType(newSignalValue, this.type)
        }

        prevValue := this.value
        this.value := newSignalValue is Func ? newSignalValue(this.value) : newSignalValue
        if (isPlainObject(this.value) || this.value is Array || this.value is Map) {
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
            if (effect.depend is signal) {
                e := effect.effectFn
                if (effect.effectFn.MaxParams == 1) {
                    e(this.value)
                } else if (effect.effectFn.MaxParams == 2) {
                    e(this.value, prevValue)
                } else {
                    e()
                }
            } else if (effect.depend is Array) {
                e := effect.effectFn
                e(effect.depend.map(dep => dep.value)*)
            }
        }

        ; notify signal tracker
        if (ARConfig.debugMode && this.debugger) {
            this.debugger.notifyChange()
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

        updater := this._mapify(this.value)
        if (key is Array) {
            this._setExactMatch(key, updater, newValue)
        } else {

            this._setFirstMatch(key, updater, newValue)
        }

        this.set(updater)
    }

    /**
     * Resets the signal to its initial value.
     */
    reset() => this.set(this.initValue)

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
            validateInstance := this.type.new(this.value is Struct.StructInstance ? this.value.mapify() : this.value)
            validateInstance := ""

        } else if (datatype is Array && datatype[1] is Struct) {
            for item in this.value {
                validateInstance := this.type[1].new(item is Struct.StructInstance ? item.mapify() : item)
                validateInstance := ""
            }
        } else {
            checkType(this.value, datatype)
        }

        return this
    }

    /**
     * Interface for AddReactiveControl instances to subscribe.
     * @param {AddReactive} AddReactiveControl 
     */
    addSub(AddReactiveControl) {
        this.subs.Push(AddReactiveControl)
    }

    /**
     * Interface for computed instances to subscribe.
     * @param {computed} computed 
     */
    addComp(computed) {        
        this.comps.Push(computed)
    }

    /**
     * Interface for effect instances to subscribe.
     * @param {effect} effect
     */
    addEffect(effect) {
        this.effects.Push(effect)
    }

    /**
     * Reformat an Object to Map.
     * @param {Object} obj Object to be change.
     * @returns {Any|Map}
     */
    _mapify(obj) {
        if (!isPlainObject(obj) && !(obj is Array) && !(obj is Map)) {
            return obj
        }

        if (isPlainObject(obj) || obj is Map) {
            res := Map()
            for key, val in (obj is Map ? obj : obj.OwnProps()) {
                if (isPlainObject(val) || val is Array || val is Map) {
                    res[key] := this._mapify(val)
                } else {
                    res[key] := val
                }
            }

            return res
        }

        if (obj is Array) {
            res := []
            for item in obj {
                if (isPlainObject(item) || item is Map) {
                    res.Push(this._mapify(item))
                } else {
                    res.Push(item)
                }
            }

            return res
        }
    }
}