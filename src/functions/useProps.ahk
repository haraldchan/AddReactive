class useProps {
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
     * @param {Object|Struct} propsDefaults Default values.
     * ```
     * StaffCard(props){
     *   staff := {
     *     name: "John Doe",
     *     age:  35,
     *     tel:  88372153
     *   }
     * 
     *   ; use Struct for more confined props defining
     *   staff := Struct({
     *     name: String,
     *     age:  Integer,
     *     tel:  Integer
     *   })
     * 
     *   info := optionalProps(props, staff)
     * }
     * ```
     * @return {Object}
     */
    __New(props, propsDefaults) {
        checkType(props, Object.Prototype)
        checkType(propsDefaults, [Object.Prototype, Struct])

        this.props := props
        this.propsDefaults := propsDefaults

        ; props defaults object
        if (isPlainObject(propsDefaults)) {
            this._addProps(this)
        }

        ; strict mode with Struct.StructInstance
        if (propsDefaults is Struct) {
            matchTest := propsDefaults.new(props)
            matchTest := ""

            this._addProps(this)
        }
    }

    _addProps(obj) {
        for name, value in (isPlainObject(this.propsDefaults) ? this.propsDefaults.OwnProps() : this.props.OwnProps()) {
            obj.DefineProp(name, { Value: this.props.HasOwnProp(name) ? this.props.%name% : value })
        }
    }
}