class useStore {
    /**
     * Creates a new store with signals, deriveds, and actions.
     * @param {Object} storeConfig Configuration object for the store.
     */
    __New(storeConfig) {
        this.signals := storeConfig.HasOwnProp("signals") ? storeConfig.signals : {}
        this.deriveds := storeConfig.HasOwnProp("deriveds") ? storeConfig.deriveds : {}
        this.methods := storeConfig.HasOwnProp("methods") ? storeConfig.methods : {}
        this.boundMethods := {}

        for name, _signal in this.signals.OwnProps() {
            this.DefineProp(name, { value: _signal })
        }

        for name, derived in this.deriveds.OwnProps() {
            this.DefineProp(name, { value: derived(this) })
        }

        for name, method in this.methods.OwnProps() {
            this.boundMethods.%name% := method.MaxParams == 0 ? method : method.Bind(this)
        }
    }

    /**
     * Add a new signal to the store.
     * @param {String} name The name of the signal.
     * @param {signal} _signal The signal object.
     */
    addSignal(name, _signal) {
        checkType(name, String)
        checkType(_signal, signal)

        this.DefineProp(name, { value: _signal })
    }

    /**
     * Add a new derived signal to the store.
     * @param {String} name The name of the derived signal.
     * @param {Func} derivedFn The computed function that defines the computed. 
     */
    addDerived(name, derivedFn) {
        checkType(name, String)
        checkType(derivedFn, computed)

        this.DefineProp(name, { value: derivedFn(this) })
    }

    /**
     * Add a new method to the store.
     * @param {String} name The name of the method.
     * @param {Func} methodFn The method function.
     */
    addMethod(name, methodFn) {
        checkType(name, String)
        checkType(methodFn, Func)

        this.boundMethods.%name% := methodFn.MaxParams == 0 ? methodFn : methodFn.Bind(this)
    }

    /** 
     * Get the method by its name.
     * @returns {Func} The method function.
    */
    useMethod(methodName) {
        if (!this.boundMethods.HasOwnProp(methodName)) {
            throw ValueError("Action '" . methodName . "' does not exist in the store.", -1, methodName)
        }

        return this.boundMethods.%methodName%
    }
}
