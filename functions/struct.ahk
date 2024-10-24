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

class StructInstance extends Struct {
    __New(newObject, typeMap) {
        for key, val in newObject.OwnProps() {
            if (!(val is typeMap[key])) {
                throw TypeError("Expect Type: {1}. Current Type: {2}", Type(typeMap[key]), Type(val))
            }

            this.DefineProp(key, { Value: val })
        }
    }
}

Person := Struct({
    name: String,
    age: Number,
    fn: Func
})

p := Person.new({ name: "hc", age: 35, fn: () => {} })