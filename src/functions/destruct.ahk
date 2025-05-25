class destruct {
    __New(outputVars, source) {
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