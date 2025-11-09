class useStore {
    /**
     * Creates a new store with signals, deriveds, and actions.
     * @param {Object} storeConfig Configuration object for the store.
     * ```
     * store := useStore({
     *     states: {
     *         count: 0
     *     },
     *     deriveds: {
     *         doubled: this => this.count.value * 2,
     *     },
     *     methods: {
     *         showAdd: this => MsgBox(this.count.value + this.doubled.value)
     *     }
     * })
     * ```
     */
    __New(storeConfig) {
        this.__store := signal(0)
        this.__states := storeConfig.HasOwnProp("states") ? storeConfig.states : {}
        this.__deriveds := storeConfig.HasOwnProp("deriveds") ? storeConfig.deriveds : {}
        this.__methods := storeConfig.HasOwnProp("methods") ? storeConfig.methods : {}
        this.methods := {}

        for name, state in this.__states.OwnProps() {
            s := signal(state)
            s.addStore(this.__store)
            this.DefineProp(name, { value: s })
        }

        for name, derived in this.__deriveds.OwnProps() {
            d := derived
            this.DefineProp(name, { value: computed(this.__store, (*) => d(this)) })
        }

        for name, method in this.__methods.OwnProps() {
            this.methods.%name% := method.MaxParams == 0 ? method : method.Bind(this)
        }
    }

    /** 
     * Get the method by its name.
     * @returns {Func} The method function.
    */
    useMethod(methodName) {
        if (!this.methods.HasOwnProp(methodName)) {
            throw ValueError("Method '" . methodName . "' does not exist in the store.", -1, methodName)
        }

        return this.methods.%methodName%
    }
}
