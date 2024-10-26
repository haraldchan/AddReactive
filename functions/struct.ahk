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

            this.validateFields(data, typeMap)

            for key, val in ((data is Map || data is OrderedMap) ? data : data.OwnProps()) {
                ; key existence check
                if (!typeMap.has(key)) {
                    throw ValueError(Format("Unknown key:{1}.", key))
                }

                this._keys.Push(key)

                ; value type check
                if (val is Object) {
                    this._values.Push(Struct.StructInstance(val, typeMap[key].typeMap))
                    continue
                }


                if (!(Type(val) = this.getTypeName(typeMap[key]))) {
                    throw TypeError(Format(
                        "Expected value type of key:{1} does not match.`n Expected: {2}, Current: {3}", 
                        key, 
                        this.getTypeName(typeMap[key]),
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

        getTypeName(classType){
            if (classType is Struct) {
                return "Struct"
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
                case class:
                    return "Class"
                case Map:
                    return "Map"
                case Array:
                    return "Array"

                ; AddReactives
                case OrderedMap:
                    return "OrderedMap"

                ; Object
                case Object:
                    return "Object"  
            }
        }

        validateFields(data, typeMap){
            errMsg := "Struct fields not match, {1}: {2}"
            dataKeys := []

            if (data is Map || data is OrderedMap) {
                dataKeys := data.keys()
            } else if (data is Object) {
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
            for k, v in typeMap {
                key := k
                if (dataKeys.find(dKey => dKey = key) = "") {
                    throw ValueError(Format(errMsg, "missing", key))
                }
            }
        }
    }
}
