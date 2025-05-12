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
        this._lookupMap := Map()
        loop items.Length {
            if (Mod(A_Index, 2) = 0) {
                continue
            }

            k := items[A_Index]
            v := items[A_Index + 1]
            this._entries.Push([k, v])
            this._lookupMap[k] := v
        }
    }

    __Item[key] {
        get => this._lookupMap[key]
        set => this.setOne(key, value)
    }

    /**
     * Adds or updates an entry in this map with a specified key and a value.
     * @param key The key of the element to add to the OrderedMap object.
     * @param value The value of the element to add to the OrderedMap object.
     */
    setOne(key, value) {
        ; key not exist
        if (!this._lookupMap.has(key)) {
            this._entries.Push([key, value])
        ; key exists
            for entry in this._entries {
                if (entry[1] == key) {
                    entry[2] := value
                    break
                }
            }
        }

        this._lookupMap[key] := value
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
            if (this._lookupMap.has(k)) {
                throw Error(Format("Key:({1}) already exist.", k))
            }
            v := keyValues[A_Index + 1]
            entriesToSet.Push([k, v])
            this._lookupMap[k] := v
        }

        this._entries.Push(entriesToSet*)
    }

    __Enum(NumberOfVars) {
        return EnumKVI

        EnumKVI(&key, &value := 0, &index := 0) {
            if (A_Index > this._entries.Length) {
                return false
            }

            key := this._entries[A_Index][1]
            value := this._entries[A_Index][2]
        }
    }

    ; methods
    /**
     * Returns an Array that contains all keys in insertion order.
     * @returns {Array} 
     */
    keys() => this._entries.map(entry => entry[1])

    /**
     * Returns an Array that contains all values in insertion order.
     * @returns {Array} 
     */
    values() => this._entries.map(entry => entry[2])

    /**
     * Returns an Array of all [key, value] pairs in insertion order.
     * @returns {Array} [[key, value], [key, value] ...]
     */
    entries() => this._entries

    /**
     * Returns the specified key from OrderedMap by value.
     * @param value The value to search.
     * @returns {Any} 
     */
    keyOf(value) {
        foundEntry := this._entries.find(entry => entry[2] == value)

        if (!foundEntry) {
            throw Error("Value not found.", value)
        }

        return foundEntry[1]
    }

    /**
     * Returns the index of specified key from OrderedMap.
     * @param key The key to search.
     * @returns {Integer} 
     */
    indexOf(key) {
        foundIndex := this._entries.findIndex(entry => entry[1] == key)

        if (!foundIndex) {
            throw Error(Format("Key:({1}) not found.", key))
        }

        return foundIndex
    }

    /**
     * Insert an [key, value] pair entry in OrderedMap.
     * @param {Integer} index The position to insert the entry at.
     * @param {Array} entry a [key, value] pair
     */
    insert(index, entry) {
        checkType(index, Integer)
        checkType(entry, Array)

        if (index < 1 || index > this._entries.Length) {
            throw IndexError("Index out of range.")
        }

        key := entry[1], value := entry[2]
        if (this._lookupMap.has(key)) {
            throw Error(Format("Key:({1}) already exist.", key))
        }

        this._entries.InsertAt(index, [key, value])
        this._lookupMap[key] := value
    }

    /**
     * Returns a boolean indicating whether an element with the specified key exists in this map or not.
     * @param key The key of the element to test for presence in the OrderedMap object.
     * @returns {Boolean} true if an element with the specified key exists in the OrderedMap object; otherwise false.
     */
    has(key) => this._lookupMap.has(key)

    /**
     * Removes all key-value pairs.
     */
    clear() {
        this._entries := []
        this._lookupMap.Clear()
    }

    /**
     * Removes the specified element from OrderedMap by key.
     * @param key The key of the element to remove from the OrderedMap object.
     * @returns {Any} The removed [key, value] pair.
     */
    delete(key) {
        index := this._entries.findIndex(entry => entry[1] == key)
        if (!index) {
            throw Error(Format("Key:({1}) not found.", key))
        }
        
        this._entries.RemoveAt(index)
        
        return this._lookupMap.Delete(key)
    }
}