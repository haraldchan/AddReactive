class destruct {
    __New(outputVars, source) {
        this._resolve(this._refs(outputVars), source)
    }

    _refs(rawRefs) {
        if (rawRefs is Array) {
            return rawRefs.map(v => val => v := val)
        } else if (rawRefs is Map || isPlainObject(rawRefs)) {
            out := {}
            for k, v in (rawRefs is Map ? rawRefs : rawRefs.OwnProps()) {
                out.%k% := val => v := val
            }

            return out
        }
    }

    _resolve(setters, source) {
        if (source is Array) {
            Loop Min(setters.Length, source.Length) {
                setters[A_Index](source[A_Index])
            }
        }

        if (source is Map) {
            for k, setter in setters {
                if (source.has(k)) {
                    setter(source[k])
                }
            }
        }

        if (isPlainObject(source)) {
            for k, setter in setters.OwnProps() {
                if (source.HasOwnProp(k)) {
                    setter(source.%k%)
                }
            }
        }
    }
}

a := "", b := ""
destruct([&a, &b], [1, 2])
MsgBox a ", " b  ; 1, 2

name := "", age := ""
destruct({ name: &name, age: &age }, { name: "Ada", age: 42 })
MsgBox name ", " age  ; Ada, 42