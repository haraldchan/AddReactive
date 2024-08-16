class shareCheckStatus {
    /**
     * Bind values of CheckBox and ListView for check-all status.
     * @param CheckBox CheckBox control.
     * @param ListView ListView Control.
     * @param {Object} options Additional options.
     * 
     * @example shareCheckStatus(cb, lv, {CheckBox: (*) => {...}, ListView: (*) => {...}, {checkValue: isCheckedSignal}})
     */
    __New(CheckBox, ListView, options := { CheckBox: (*) => {}, ListView: (*) => {} }) {
        checkType(CheckBox, Gui.CheckBox, "First parameter is not a Gui.CheckBox")
        checkType(ListView, Gui.ListView, "Second parameter is not a Gui.ListView")
        checkType(options, Object, "Third parameter is not an Object")
        if options.hasOwnProp("CheckBox") {
            checkType(options.CheckBox, Func, "This property must be a callback function")
        }
        if options.hasOwnProp("ListView") {
            checkType(options.ListView, Func, "This property must be a callback function")
        }
        if options.hasOwnProp("checkValue") {
            checkType(options.checkValue, signal, "checkValue must be a signal")
        }        

        this.cbFn := options.hasOwnProp("CheckBox") ? options.CheckBox : (*) => {}
        this.lvFn := options.hasOwnProp("ListView") ? options.ListView : (*) => {}
        this.checkValueDepend := options.hasOwnProp("checkValue") ? options.checkValue : ""

        CheckBox.OnEvent("Click", (ctrl, _) => this.handleCheckAll(CheckBox, ListView))
        ListView.OnEvent("ItemCheck", (LV, item, isChecked) => this.handleItemCheck(CheckBox, LV, item, isChecked))
    }

    handleCheckAll(CB, LV) {
        LV.Modify(0, CB.Value = true ? "Check" : "-Check")
        this.runCustomFn(this.cbFn)
    }

    handleItemCheck(CB, LV, item, isChecked) {
        focusedRows := LV.getFocusedRowNumbers()

        for focusedRow in focusedRows {
            LV.Modify(focusedRow, isChecked ? "Check" : "-Check")
        }
        ; get checked rows aynchronously, wait for other items to change check status
        if (this.checkValueDepend = "") {
            setTimer(() => CB.Value := (LV.getCheckedRowNumbers().Length = LV.GetCount()), -1)
        } else {
            setTimer(() => this.checkValueDepend.set(LV.getCheckedRowNumbers().Length = LV.GetCount()), -1)
        }

        this.runCustomFn(this.lvFn)
    }

    runCustomFn(userFunctions) {
        checkType(userFunctions, [Func, Array], "Parameter is not a Function or Array")

        if (userFunctions is Func) {
            userFunctions()

        } else if (userFunctions is Array) {
            for fn in userFunctions {
                checkType(fn, Func, "Parameter is not a Function")
                fn()
            }
        }
    }
}