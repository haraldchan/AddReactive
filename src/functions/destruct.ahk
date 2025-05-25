class destruct {
    /**
     * Destructures an array or object into multiple variables by reference.
     * 
     * ```
     * arr := [1, 2, 3]
     * destruct([&a, &b, &c], arr)  ; assigns: a := 1, b := 2, c := 3
     * 
     * staff := { name: "John", age: 33 }
     * destruct({ name: &name, age: &age }, staff)  ; assigns: name := "John", age := 33
     * 
     * nested := { user: { name: "Jane", location: { city: "Paris" } } }
     * destruct({ user: { name: &userName, location: { city: &city } } }, nested)
     * ; assigns: userName := "Jane", city := "Paris"
     * ```
     * 
     * Supports deep nesting and type-safe value mapping from the source object or array.
     * 
     * @param {Array<VarRef>|Object<string, VarRef>} outputVars - An array or object containing VarRefs to receive values.
     * @param {Array|Object} source - An array, Map, or plain object whose values are destructured into outputVars.
     * @throws {ValueError} If a key or index is missing in the source.
     */
    __New(outputVars, source) {
        checkType(outputVars, [Array, Map, Object.Prototype])
        checkType(source, [Array, Map, Object.Prototype])

        this._resolve(this._refs(outputVars), source)
    }

    _refs(rawRefs) {
        if (rawRefs is Array) {
            return rawRefs.map((&var) => value => var := value)
        } else if (rawRefs is Map || isPlainObject(rawRefs)) {
            out := {}
            for k, v in (rawRefs is Map ? rawRefs : rawRefs.OwnProps()) {
                if (IsObject(v)) {
                    this._refs(v)
                } else {
                    out.%k% := ((&var) => value => var := value)(v)
                }
            }

            return out
        }
    }

    _resolve(setters, source) {
        if (source is Array) {
            for setter in setters {
                if (A_Index > source.Length) {
                    throw IndexError("Index out of range", -1, A_Index)
                }

                if (setter is Array) {
                    this._resolve(setter, source[A_Index])
                }

                setter(source[A_Index])
            }
        }

        if (source is Map || isPlainObject(source)) {
            isMap := source is Map

            for k, setter in setters.OwnProps() {
                if (setter is Map || isPlainObject(setter)) {
                    this._resolve(setter, isMap ? source[k] : source.%k%)
                }

                if (isMap ? source.has(k) : source.HasOwnProp(k)) {
                    setter(isMap ? source[k] : source.%k%)
                } else {
                    throw ValueError("Key not found.", -1, k)
                }
            }
        }
    }
}