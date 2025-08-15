class NumberExt {
    static patch() {
        if (!ARConfig.useExtendMethods) {
            return
        }

        for method, enabled in ARConfig.enableExtendMethods.integer.OwnProps() {
            if (enabled) {
                Integer.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    static times(int, fn) {
        loop int {
            (fn.MaxParams == 1) ? fn.Call(A_Index) : fn.Call()
        }
    }
}