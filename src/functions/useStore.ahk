class useStore {
    /**
     * Creates a new store with signals, deriveds, and actions.
     * @param {String} name Name of the store
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
    __New(storeName, storeConfig) {
        this.__store := signal(0)
        this.__states := storeConfig.HasOwnProp("states") ? storeConfig.states : {}
        this.__deriveds := storeConfig.HasOwnProp("deriveds") ? storeConfig.deriveds : {}
        this.__methods := storeConfig.HasOwnProp("methods") ? storeConfig.methods : {}
        this.methods := {}

        for name, state in this.__states.OwnProps() {
            s := useStore.state(state, { name: storeName . "::" . name })
            s.addStore(this.__store)
            this.DefineProp(name, { value: s })
        }

        for name, mutationFn in this.__deriveds.OwnProps() {
            mut := mutationFn
            this.DefineProp(name, { value: useStore.derived(this.__store, (*) => mut(this), { name: storeName . "::" . name }) })
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

    class state extends signal {
        __New(initialValue, options := { name: "", forceUpdate: false }) {
            super.__New(initialValue, options)

            this.stores := []
            this.deriveds := []

        }

        set(newSignalValue) {
            if (!this.forceUpdate && newSignalValue == this.value) {
                return
            }

            super.set(newSignalValue)

            for store in this.stores {
                store.set({ newValue: this.value })
            }
        }

        addStore(store) {
            this.stores.Push(store)
        }
    }

    class derived extends computed {
        
    }
}
