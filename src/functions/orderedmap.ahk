; The OrderedMap object holds key-value pairs and remembers the original insertion order of the keys.
class OrderedMap extends Map {
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

        this._entries := []
        loop items.Length {
            if (Mod(A_Index, 2) = 0) {
                continue
            }

            k := items[A_Index]
            v := items[A_Index + 1]
            this._entries.Push([k, v])
        }

        this._keys := this._entries.map(entry => entry[1])
        this._values := this._entries.map(entry => entry[2])
    }

    __Item[key] {
        get => this._values[this._keys.findIndex(item => item = key)]
        set => this.setOne(key, value)
    }

    /**
     * Adds or updates an entry in this map with a specified key and a value.
     * @param key The key of the element to add to the OrderedMap object.
     * @param value The value of the element to add to the OrderedMap object.
     */
    setOne(key, value) {
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
     * Set one or more key-value pair.
     * @param {key, value, ...} keyValues 
     */
    set(keyValues*) {
        if (Mod(keyValues.Length, 2) != 0) {
            throw ValueError("Parameters must be key-value pairs.")
        }

        entriesToSet := []
        loop keyValues.Length {
            if (Mod(A_Index, 2) = 0) {
                continue
            }

            k := keyValues[A_Index]
            if (this._keys.find(eKey => eKey = k) != "") {
                throw Error("Key already exist.")
            }
            v := keyValues[A_Index + 1]
            entriesToSet.Push([k, v])
        }

        keysToSet := entriesToSet.map(entry => entry[1])
        valuesToSet := entriesToSet.map(entry => entry[2])

        this._entries.Push(entriesToSet*)
        this._keys.Push(keysToSet*)
        this._values.Push(valuesToSet*)
    }

    __Enum(NumberOfVars) {
        return EnumKVI

        EnumKVI(&key, &value := 0, &index := 0) {
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
     * Returns the index of specified key from OrderedMap.
     * @param key The key to search.
     * @returns {Integer} 
     */
    indexOf(key) {
        foundIndex := this._keys.findIndex(item => item = key)

        if (foundIndex = "") {
            throw Error("Key not found.", key)
        }

        return foundIndex
    }

    /**
     * Insert an [key, value] pair entry in OrderedMap.
     * @param {Array} entry a [key, value] pair
     * @param {Integer} index The position to insert the entry at.
     */
    insert(entry, index) {
        checkType(entry, Array)
        checkType(index, Integer)

        key := entry[1], value := entry[2]
        if (this._keys.find(eKey => eKey = key) != "") {
            throw Error("Key already exist.")
        }

        this._entries.InsertAt(index, [key, value])
        this._keys.InsertAt(index, key)
        this._values.InsertAt(index, value)
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