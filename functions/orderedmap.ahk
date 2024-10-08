; The OrderedMap object holds key-value pairs and remembers the original insertion order of the keys.
class OrderedMap {
    /**
     * OrderedMap holds key-value pairs and remembers the original insertion order of the keys.
     * ```
     * ; Create
     * om := OrderedMap(key1, value1, key2, value2, ...)
     * 
     * ; Enumerate
     * For key, val [, index] in OrderedMap
     * ```
     * @param {...Any} items Key, values to be set 
     */
    __New(items*) {
        if (Mod(items.Length, 2) != 0) {
            throw ValueError("Parameters must be key-value pairs.")
        }

        this._keys := []
        this._values := []
        this._entries := []

        for i, item in items {
            if (Mod(i, 2) != 0) {
                this._keys.Push(item)
            } else {
                this._values.Push(item)
            }
        }

        for key in this._keys {
            this._entries.Push([key, this._values[A_Index]])
        }
    }

    __Item[key] {
        get => this._values[this._keys.findIndex(item => item = key)]
        set => this.set(key, value)
    }

    __Enum(nov) {
        return EnumKVI

        EnumKVI(&key, &value, &index := 0) {
            if (A_Index > this._keys.Length) {
                return false
            }

            index := A_Index
            key := this._keys[index]
            value := this._values[index]
        }
    }

    ; methods
    /**
     * Returns an Array that contains all keys in insertion order.
     * @returns {Array} 
     */
    keys() {
        return this._keys
    }

    /**
     * Returns an Array that contains all values in insertion order.
     * @returns {Array} 
     */
    values() {
        return this._values
    }

    /**
     * Returns an Array of all [key, value] pairs in insertion order.
     * @returns {Array} [[key, value], [key, value] ...]
     */
    entries() {
        return this._entries
    }

    /**
     * Adds or updates an entry in this map with a specified key and a value.
     * @param key The key of the element to add to the OrderedMap object.
     * @param value The value of the element to add to the OrderedMap object.
     */
    set(key, value) {
        ; key not exist
        if (this._keys.find(item => item = key) = "") {
            this._keys.Push(key)
            this._values.Push(value)
            this._entries.Push([key, value])
        } else {
            this._values := this._values.with(this._keys.findIndex(item => item = key), value)
            this._entries := []
            for key in this._keys {
                this._entries.Push([key, this._values[A_Index]])
            }
        }
    }

    /**
     * Returns the specified key from OrderedMap by value.
     * @param value The value to search.
     * @returns {Any} 
     */
    keyOf(value) {
        foundIndex := this._values.findIndex(item => item = value)
        
        if (foundIndex = "") {
            throw Error("Value not found.", value)
        }

        return this._keys[foundIndex]
    }

    /**
     * Returns a boolean indicating whether an element with the specified key exists in this map or not.
     * @param key The key of the element to test for presence in the OrderedMap object.
     * @returns {Boolean} true if an element with the specified key exists in the OrderedMap object; otherwise false.
     */
    has(key) {
        return this._keys.find(item => item = key) != "" ? true : false
    }

    /**
     * Removes all key-value pairs.
     */
    clear() {
        this._keys := []
        this._values := []
        this._entries := []
    }

    /**
     * Removes the specified element from OrderedMap by key.
     * @param key The key of the element to remove from the OrderedMap object.
     * @returns {Any} The removed [key, value] pair.
     */
    delete(key) {
        index := this._keys.findIndex(item => item = key)
        target := this._entries[index]

        this._keys.RemoveAt(index)
        this._values.RemoveAt(index)
        this._entries.RemoveAt(index)

        return target
    }
}