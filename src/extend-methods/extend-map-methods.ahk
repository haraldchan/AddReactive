/**
 * Extension methods for AutoHotkey Map objects.
 * Provides utility functions for key/value access and deep cloning.
 */
class MapExt {
    /**
     * Patches the Map prototype with extended methods if enabled in ARConfig.
     */
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

    /**
     * Returns an array of keys from a Map.
     * @param {Map} _map - The Map object.
     * @returns {Array} Array of keys.
     */
    static keys(_map) {
        newArray := []

        for k, v in _map {
            newArray.Push(k)
        }
 
        return newArray
    }

    /**
     * Returns an array of values from a Map.
     * @param {Map} _map - The Map object.
     * @returns {Array} Array of values.
     */
    static values(_map) {
        newArray := []

        for k, v in _map {
            newArray.Push(v)
        }

        return newArray
    }

    /**
     * Returns the key for a given value in a Map.
     * @param {Map} _map - The Map object.
     * @param {any} value - The value to search for.
     * @returns {any} The key corresponding to the value.
     * @throws {ValueError} If the value is not found.
     */
    static getKey(_map, value) {
        for k, v in _map {
            if (v = value) {
                return k
            }
        }

        throw ValueError("Value not found in Map.", -1, value)
    }

    /**
     * Sets the default value for a Map.
     * @param {Map} _map - The Map object.
     * @param {any} value - The default value to set.
     * @returns {Map} The updated Map object.
     */
    static setDefault(_map, value) {
        _map.Default := value
        return _map
    }

    /**
     * Deep clones a Map, OrderedMap, Array, or plain object.
     * @param {Map} _map - The object to clone.
     * @returns {Map} The deep-cloned object.
     */
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
