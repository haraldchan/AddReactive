defineMapMethods(_map) {

    _map.Prototype.keys := keys
    /**
     * Returns keys of a Map.
     * @returns {Array} 
     */
    keys(_map) {
        newArray := []

        for k, v in _map {
            newArray.Push(k)
        }

        return newArray
    }

    _map.Prototype.values := values
    /**
     * Returns values of a Map.
     * @returns {Array} 
     */
    values(_map) {
        newArray := []

        for k, v in _map {
            newArray.Push(v)
        }

        return newArray
    }

    _map.Prototype.getKey := getKey
    /**
     * Returns a key of a given value.
     * ```
     * cls := Map("red", "apple")
     * cls.getKey("Apple") ; -> "red"
     * ```
     * @param value 
     */
    getKey(_map, value) {
        for k, v in _map {
            if (v = value) {
                return k
            }
        }
    }

    _map.Prototype.deepClone := deepClone
    /**
     * Returns a deep copy of a Map.
     * @returns {Map} 
     */
    deepClone(_map) {
        newMap := Map()

        for k, v in _map {
            newMap[k] := v
        }

        return newMap
    }

}

defineMapMethods(Map)

class OrderedMap {
    __New(keyValues*) {
        this.keys := []
        this.values := []
        this.entries := []
        this.__Item := Map(keyValues*)

        for i, item in keyValues {
            if (Mod(i, 2) != 0) {
                this.keys.Push(item)
            } else {
                this.values.Push(item)
            }
        }

        for key in this.keys {
            this.entries.Push([key, this.values[A_Index]])
        }
    }

    getKey(val) {
        return this.keys[this.values.findIndex(item => item = val)]
    }

    __Enum(nov){
        return Enum3

        Enum3(&key, &value, &index := 0) {
            if (A_Index > this.keys.Length) {
                return false
            }

            index := A_Index
            key := this.keys[index]
            value := this.values[index]
        }
    }
}
