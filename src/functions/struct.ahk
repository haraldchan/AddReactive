class Struct {
    /**
     * Creates predefined set of fields with specific data types.
     * ```
     * Person := Struct({
     *  name: String,
     *  age:  Integer,
     *  tel:  Number
     * })
     * ```
     * @param {Object} structObject An object defining the structure and data types for each field.
     */
    __New(structObject) {
        this.structObject := structObject
        this.typeMap := Map()

        for key, type in this.structObject.OwnProps() {
            this.typeMap[key] := type
        }
    }

    /**
     * Returns a Struct instance fulfills predefined data structure.
     * @param {Object|Map|OrderedMap} data 
     * ```
     * staff := Person.new({ 
     *   name: "Amy", 
     *   age:   29, 
     *   tel:   88372153
     * })
     * ```
     * @returns {StructInstance} 
     */
    new(data) {
        return Struct.StructInstance(data, this.typeMap)
    }

    class StructInstance {
        __New(data, typeMap) {
            this.data := data
            this._keys := []
            this._values := []

            this.validateFields(data, typeMap)

            for key, val in (data is Map ? data : data.OwnProps()) {
                this._keys.Push(key)

                ; value type check
                ; objects
                if (isPlainObject(val) || val is Map) {
                    this._values.Push(Struct.StructInstance(val, typeMap[key].typeMap))
                    continue
                }

                ; array
                if (val is Array) {
                    k := key
                    if (!val.every(item => item is typeMap[k][1])) {
                        throw TypeError(Format(
                            "Expected item type of index:{1} does not match.`n Expected: {2}, Current: {3}",
                            val.findIndex(item => Type(item) != typeMap[k][1]),
                            this.getTypeName(typeMap[k][1]),
                            Type(val.find(item => Type(item) != typeMap[k][1]))
                        ))
                    }
                    ; primitives
                } else if (Type(val) != this.getTypeName(typeMap[key])) {
                    throw TypeError(Format(
                        "Expected value type of key:{1} does not match.`n Expected: {2}, Current: {3}",
                        key,
                        this.getTypeName(typeMap[key]),
                        Type(val)
                    ))
                }

                this._values.Push(val)
            }
        }

        __Item[key] {
            get {
                if (this._keys.find(k => k = key) = "") {
                    throw ValueError(Format("Key:{1} not found.", key))
                }

                return this._values[this._keys.findIndex(item => item = key)]
            }

            set {
                if (this._keys.find(k => k = key) = "") {
                    throw ValueError(Format("Key:{1} not found.", key))
                }

                this._values := this._values.with(this._keys.findIndex(item => item = key), value)
            }
        }

        __Enum(NumberOfVars) {
            return NumberOfVars == 1 ? enumK : enumKV

            enumK(&key) {
                if (A_Index > this._keys.Length) {
                    return false
                }

                key := this._keys[A_Index]
            }

            enumKV(&key, &value) {
                if (A_Index > this._keys.Length) {
                    return false
                }

                key := this._keys[A_Index]
                value := this._values[A_Index]
            }
        }

        getTypeName(classType) {
            if (classType is Struct) {
                return "Struct"
            }

            if (classType is Array) {
                itemType := this.getTypeName(classType[1])
                return "Array of " . itemType . "s"
            }

            switch classType {
                ; primitives
                case Number:
                    return "Number"
                case Integer:
                    return "Integer"
                case Float:
                    return "Float"
                case String:
                    return "String"

                    ; objects
                case Func:
                    return "Func"
                case Enumerator:
                    return "Enumerator"
                case Closure:
                    return "Closure"
                case Class:
                    return "Class"
                case Map:
                    return "Map"
                case Array:
                    return "Array"
                case Buffer:
                    return "Buffer"
                case ComObject:
                    return "ComObject"
                case Gui:
                    return "Gui"

                    ; AddReactive funcs
                case OrderedMap:
                    return "OrderedMap"

                    ; Object
                case Object:
                    return "Object"
            }
        }

        validateFields(data, typeMap) {
            errMsg := "Struct fields not match, {1}: {2}"
            dataKeys := []

            if (data is Map || data is OrderedMap) {
                dataKeys := data.keys()
            } else if (isPlainObject(data)) {
                for key in data.OwnProps() {
                    dataKeys.Push(key)
                }
            }

            ; unknown field
            for key in dataKeys {
                if (!typeMap.has(key)) {
                    throw ValueError(Format(errMsg, "unknown", key))
                }
            }

            ; missing field
            for key, type in typeMap {
                k := key
                if (dataKeys.find(dKey => dKey = k) = "") {
                    throw ValueError(Format(errMsg, "missing", key))
                }
            }
        }

        /**
         * Returns a Map of converted StructInstance.
         * @returns {Map} 
         */
        mapify() {
            resMap := Map()

            for index, key in this._keys {
                val := this._values[index]
                resMap[key] := val is Struct.StructInstance
                    ? val.mapify()
                        : val
            }

            return resMap
        }

        /**
         * Returns a boolean indicating whether an element with the specified key exists in this struct instance or not.
         * @param key The key of the element to test for presence in the struct instance.
         * @returns {Boolean} true if an element with the specified key exists in the struct instance; otherwise false.
         */
        has(key) {
            return this._keys.find(item => item = key) != "" ? true : false
        }

        /**
         * Returns a JSON format string of converted StructInstance.
         * @returns {String} 
         */
        stringify() {
            return JSON.stringify(this.mapify())
        }
    }
}
