class Struct {
    __New(structObject) {
        this.structObject := structObject
        this.typeMap := Map()

        for key, type in this.structObject.OwnProps() {
            this.typeMap[key] := type
        }
    }

    new(newObject) {
        return StructInstance(newObject, this.typeMap)
    }
}

class StructInstance {
    __New(data, typeMap) {
        for key, val in (data is Map ? data : data.OwnProps()) {
            if (!(val is typeMap[key])) {
                throw TypeError(Format("Expected value type of key:{1} does not match.", key))
            }

            this.DefineProp(key, { Value: val })
        }
    }
}
