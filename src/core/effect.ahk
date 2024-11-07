class effect {
    /**
     * Create a effect that runs when the value of depend signal changes.
     * ```
     * effect(signal, (new, prev) => MsgBox(Format("New: {1}, prev: {2}", new, prev)))
     * ````
     * @param {signal} depend The signal associated with.
     * @param {(new?, prev?) => void} effectFn Callback function object. 
     * First param retrieves the new value of the signal, second param retrives previous value.
     */
    __New(depend, effectFn) {
        checkType(depend, [signal, computed])
        checkType(effectFn, Func)
        depend.addEffect(effectFn)
    }
}