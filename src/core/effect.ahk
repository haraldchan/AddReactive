class effect {
    /**
     * Create a effect that runs when the value of depend signal changes.
     * ```
     * effect(signal, (new, prev) => MsgBox(Format("New: {1}, prev: {2}", new, prev)))
     * ````
     * @param {signal|signal[]} depend The signal associated with.
     * @param {(new?, prev?) => void} effectFn Callback function object. 
     * First param retrieves the new value of the signal, second param retrives previous value.
     */
    __New(depend, effectFn) {
        if (depend is Array) {
            for dep in depend {
                checkType(dep, signal)
            }
        } else {
            checkType(depend, signal)
        }
        checkType(effectFn, Func)
        
        this.depend := depend
        this.effectFn := effectFn
        
        if (depend is signal) {
            depend.addEffect(this)
        }

        if (depend is Array) {
            for dep in depend {
                dep.addEffect(this)
            }
        } 
    }
}