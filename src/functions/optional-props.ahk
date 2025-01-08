class optionalProps {
    /**
     * Define optional props with an object for default values. (Or with StructInstance for type checking).
     * ```
     * StaffCard({ name: "Jenny", age: 22 })
     * 
     * StaffCard(props){
     *   ; define default values
     *   info := optionalProps(props, {
     *     name: "John Doe",
     *     age:  35,
     *     tel:  88372153
     *   })
     * }
     * ```
     * @param {Object} props Props object received in a component.
     * ```
     * jenny := { name: "Jenny", age: 22 }
     * ```
     * @param {Object|StructInstance} propsDefaults Default values.
     * ```
     * StaffCard(props){
     *   defaultStaff := {
     *     name: "John Doe",
     *     age:  35,
     *     tel:  88372153
     *   }
     * 
     *   ; use StructInstance for more confined props defining
     *   defaultStaff := Struct({
     *     name: String,
     *     age:  Integer,
     *     tel:  Integer
     *   }).new({
     *     name: "John Doe",
     *     age:  35,
     *     tel:  88372153
     *   })
     * 
     *   info := optionalProps(props, defaultStaff)
     * }
     * ```
     * @return {Object}
     */
    __New(props, propsDefaults) {
        checkType(props, Object.Prototype)
        checkType(propsDefaults, [Object.Prototype, Struct.StructInstance])

        this.props := props
        this.propsDefaults := propsDefaults

        ; props defaults object
        if (isPlainObject(propsDefaults)) {
            this._addProps(this)
        }

        ; strict mode with Struct.StructInstance
        if (propsDefaults is Struct.StructInstance) {
            propsObj := {}
            this._addProps(propsObj)

            matchTest := propsDefaults.baseStruct.new(propsObj)
            matchTest := ""

            this._addProps(this)
        }
    }

    _addProps(obj) {
        for name, defaultValue in (isPlainObject(this.propsDefaults) ? this.propsDefaults.OwnProps() : this.propsDefaults) {
            obj.DefineProp(name, { Value: this.props.HasOwnProp(name) ? this.props.%name% : defaultValue })
        }
    }
}