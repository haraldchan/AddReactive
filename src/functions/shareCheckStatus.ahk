; An AddReactive function that helps you binding check status between a CheckBox and a ListView control.
class shareCheckStatus {
    /**
     * Bind values of CheckBox and ListView for check-all status.
     * ```
     * shareCheckStatus(cb, lv, {CheckBox: (*) => {...}, ListView: (*) => {...}, checkStatus: isCheckedSignal})
     * ```
     * @param CheckBox AddReactive CheckBox.
     * @param ListView AddReactive Control.
     * @param {Object} options Additional options.
     */
    __New(CheckBox, ListView, options := {}) {
        ; param type checking
        checkType(CheckBox, [Gui.CheckBox, AddReactiveCheckBox], "First parameter is not a Gui.CheckBox or AddReactiveCheckBox")
        checkType(ListView, [Gui.ListView, AddReactiveListView], "Second parameter is not a Gui.ListView or AddReactiveListView")
        if (!(CheckBox is Gui.CheckBox && ListView is Gui.ListView)
            && !(CheckBox is AddReactiveCheckBox && ListView is AddReactiveListView)
        ) {
            Throw TypeError("CheckBox and ListView control have to be both navive or AddReactive controls.")
        }
        checkType(options, Object, "Third parameter is not an Object")
        if options.hasOwnProp("CheckBox") {
            checkType(options.CheckBox, Func, "This property must be a callback function")
        }
        if options.hasOwnProp("ListView") {
            checkType(options.ListView, Func, "This property must be a callback function")
        }
        if options.hasOwnProp("checkStatus") {
            checkType(options.checkStatus, signal, "checkStatus must be a signal")
        }

        this.cb := CheckBox
        this.lv := ListView

        o := useProps(options, {
            CheckBox: (*) => {},
            ListView: (*) => {},
            checkStatus: signal(false)
        })

        this.cbFn := o.CheckBox
        this.lvFn := o.ListView
        this.checkStatusDepend := o.checkStatus

        ; diversing native/AR control
        if (this.cb is AddReactiveCheckBox && this.lv is AddReactiveListView) {
            checkType(options.checkStatus, signal, "checkStatus is not a signal.")
            ; add checkStatusDepend, sub signal
            CheckBox.checkStatusDepend := options.checkStatus
            options.checkStatus.addSub(CheckBox)
            ListView.checkStatusDepend := options.checkStatus
            options.checkStatus.addSub(ListView)

            CheckBox.ctrl.OnEvent("Click", (ctrl, _) => this._handleCheckAll(ctrl, ListView.ctrl))
            ListView.ctrl.OnEvent("ItemCheck", (LV, item, isChecked) => this._handleItemCheck(CheckBox.ctrl, LV, item, isChecked))
        } else {
            CheckBox.OnEvent("Click", (ctrl, _) => this._handleCheckAll(CheckBox, ListView))
            ListView.OnEvent("ItemCheck", (LV, item, isChecked) => this._handleItemCheck(CheckBox, LV, item, isChecked))
        }
    }

    _handleCheckAll(CB, LV) {
        if (this.cb is AddReactiveCheckBox && this.lv is AddReactiveListView) {
            this.checkStatusDepend.set(cur => !cur)
        } else {
            LV.Modify(0, CB.Value = true ? "Check" : "-Check")
        }
        this._runCustomFn(this.cbFn)
    }

    _handleItemCheck(CB, LV, item, isChecked) {
        ; multi-check
        focusedRows := LV.getFocusedRowNumbers()
        for focusedRow in focusedRows {
            LV.Modify(focusedRow, isChecked ? "Check" : "-Check")
        }

        prevCheckedRows := []
        if (this.checkStatusDepend = "") {
            SetTimer(() => CB.Value := (LV.getCheckedRowNumbers().Length = LV.GetCount()), -1)
        } else {
            SetTimer(() => (
                prevCheckedRows := LV.getCheckedRowNumbers(),
                this.checkStatusDepend.set(LV.getCheckedRowNumbers().Length = LV.GetCount())), -1)
            Sleep 30
            if (isChecked = false) {
                for row in prevCheckedRows {
                    LV.Modify(row, "+Check")
                }
            }
        }
        this._runCustomFn(this.lvFn)
    }

    _runCustomFn(userFunctions) {
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