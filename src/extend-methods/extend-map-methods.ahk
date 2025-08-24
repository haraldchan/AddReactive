class MapExt {
    static patch() {
        if (!ARConfig.useExtendMethods) {
            return
        }

        for method, enabled in ARConfig.enableExtendMethods.map.OwnProps() {
            if (enabled) {
                Map.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    static keys(_map) {
        newArray := []

        for k, v in _map {
            newArray.Push(k)
        }
 
        return newArray
    }

    static values(_map) {
        newArray := []

        for k, v in _map {
            newArray.Push(v)
        }

        return newArray
    }

    static getKey(_map, value) {
        for k, v in _map {
            if (v = value) {
                return k
            }
        }
    }

    static setDefault(_map, value) {
        _map.Default := value
        return _map
    }

    static deepClone(_map) {
        if (_map is Map) {
            res := _map is OrderedMap ? OrderedMap() : Map()

            for key, val in _map {
                if (isPlainObject(val) || val is Array || val is Map) {
                    res[key] := this.deepClone(val)
                } else {
                    res[key] := val
                }
            }

            return res
        }

        if (isPlainObject(_map)) {
            res := {}

            for key, val in _map.OwnProps() {
                if (isPlainObject(val) || val is Array || val is Map) {
                    res.%key% := this.deepClone(val)
                } else {
                    res.%key% := val
                }
            }

            return res
        }

        if (_map is Array) {
            res := []

            for item in _map {
                if (isPlainObject(item) || item is Map) {
                    res.Push(this.deepClone(item))
                } else {
                    res.Push(item)
                }
            }

            return res
        }
    }
}
