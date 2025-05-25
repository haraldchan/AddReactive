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
                out.%k% := ((&var) => value => var := value)(v)
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
            for k, setter in setters.OwnProps() {
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
