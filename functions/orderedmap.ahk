
class OrderedMap {
    /**
     * OrderedMap holds key-value pairs and remembers the original insertion order of the keys.
     * ```
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
    keys() {
        return this._keys
    }

    values() {
        return this._values
    }

    entries() {
        return this._entries
    }

    set(key, newValue) {
        ; key not exist
        if (this._keys.find(key) != "") {
            this._keys.Push(key)
            this._values.Push(newValue)
            this._entries.Push([key, newValue])
        } else {
            this._values.with(this._keys.findIndex(item => item = key), newValue)
        }
    }

    /**
     * Returns the key of a certain value.
     * @param value search by value
     * @returns {Any} 
     */
    keyOf(value) {
        return this._keys[this._values.findIndex(item => item = value)]
    }

    /**
     * 
     * @param key 
     * @returns {Integer} 
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
     * Removes a key-value pair.
     */
    delete(key) {
        index := this._keys.findIndex(item => item = key)
        this._keys.RemoveAt(index)
        this._values.RemoveAt(index)
        this._entries.RemoveAt(index)
    }
}