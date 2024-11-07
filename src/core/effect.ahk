class effect {
    /**
     * Create a effect that runs when the value of depend signal changes.
     * @param {signal} depend The signal associated with.
     * @param {(new?, prev?) => void} effectFn Callback function object. 
     * First param retrieves the new value of the signal, second param retrives previous value.
     * @example effect(signal, (new, prev) => MsgBox(Format("New: {1}, prev: {2}", new, prev)))
     */
    __New(depend, effectFn) {
        depend.addEffect(effectFn)
    }
}