; defineMapMethods(_map) {

;     _map.Prototype.keys := keys
;     /**
;      * Returns keys of a Map.
;      * @returns {Array} 
;      */
;     keys(_map) {
;         newArray := []

;         for k, v in _map {
;             newArray.Push(k)
;         }

;         return newArray
;     }

;     _map.Prototype.values := values
;     /**
;      * Returns values of a Map.
;      * @returns {Array} 
;      */
;     values(_map) {
;         newArray := []

;         for k, v in _map {
;             newArray.Push(v)
;         }

;         return newArray
;     }

;     _map.Prototype.getKey := getKey
;     /**
;      * Returns a key of a given value.
;      * ```
;      * cls := Map("red", "apple")
;      * cls.getKey("Apple") ; -> "red"
;      * ```
;      * @param value 
;      */
;     getKey(_map, value) {
;         for k, v in _map {
;             if (v = value) {
;                 return k
;             }
;         }
;     }

;     _map.Prototype.deepClone := deepClone
;     /**
;      * Returns a deep copy of a Map.
;      * @returns {Map} 
;      */
;     deepClone(_map) {
;         if (_map is Map) {
;             res := _map is OrderedMap ? OrderedMap() : Map()

;             for key, val in _map {
;                 if (isPlainObject(val) || val is Array || val is Map) {
;                     res[key] := deepClone(val)
;                 } else {
;                     res[key] := val
;                 }
;             }

;             return res
;         }

;         if (isPlainObject(_map)) {
;             res := {}

;             for key, val in _map.OwnProps() {
;                 if (isPlainObject(val) || val is Array || val is Map) {
;                     res.%key% := deepClone(val)
;                 } else {
;                     res.%key% := val
;                 }
;             }

;             return res
;         }

;         if (_map is Array) {
;             res := []

;             for item in _map {
;                 if (isPlainObject(item) || item is Map) {
;                     res.Push(deepClone(item))
;                 } else {
;                     res.Push(item)
;                 }
;             }

;             return res
;         }
;     }
; }

; defineMapMethods(Map)

class MapExt {
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

defineMapMethods(MapProto) {
    if (!ARConfig.useExtendMethods) {
        return
    }

    for method, enabled in ARConfig.extendMethods.map.OwnProps() {
        if (enabled) {
            Map.Prototype.%method% := ArrayExt.%method%
            ; ObjBindMethod(Map.Prototype, method)
        }
    }

    ; if (ARConfig.extendMethods.array.some) {
    ;     MapProto.some := ArrayExt.some
    ; }
}