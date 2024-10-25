class Struct {
    /**
     * Creates predefined set of fields with specific data types.
     * ```
     * Person := Struct({
     *  name: String,
     *  age: Integer,
     *  tel: Number
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

            for key, val in ((data is Map || data is OrderedMap) ? data : data.OwnProps()) {
                ; key existence check
                if (!typeMap.has(key)) {
                    throw ValueError(Format("Unknown key:{1}.", key))
                }

                this._keys.Push(key)

                ; value type check
                if (!(val is typeMap[key])) {
                    throw TypeError(Format(
                        "Expected value type of key:{1} does not match.`n Expected: {2}, Current: {3}", 
                        key, 
                        Type(typeMap[key] is Struct ? "Struct" : Type(typeMap[key].Call(*))),
                        Type(val)
                    ))
                }

                this._values.Push((val is Struct) ? Struct.StructInstance(val, val.typeMap) : val)
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
            return enum

            enum(&key, &value) {
                if (A_Index > this._keys.Length) {
                    return false
                }

                key := this._keys[A_Index]
                value := this._values[A_Index]
            }
        }
    }
}