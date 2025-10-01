/**
 * Extension methods for AutoHotkey Integer objects.
 * Provides utility functions for integer operations.
 */
class NumberExt {
    /**
     * Patches the Integer prototype with extended methods if enabled in ARConfig.
     */
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

    /**
     * Executes a function a specified number of times.
     * @param {Integer} int - The number of times to execute.
     * @param {Func} fn - The function to execute. Receives (A_Index) or (int, A_Index) as arguments.
     */
    static times(int, fn) {
        loop int {
            (fn.MaxParams == 1) ? fn(A_Index) : (fn.MaxParams == 2) ? fn(int, A_Index) : fn()
        }
    }
}