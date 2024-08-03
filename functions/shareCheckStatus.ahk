class shareCheckStatus {
    __New(CheckBox, ListView, customFn := { CheckBox: (*) => {}, ListView: (*) => {} }) {
        checkType(CheckBox, Gui.CheckBox, "First parameter is not a Gui.CheckBox")
        checkType(ListView, Gui.ListView, "Second parameter is not a Gui.ListView")
        checkType(customFn, Object, "Third parameter is not an Object")

        this.cbFn := customFn.hasOwnProp("CheckBox") ? customFn.CheckBox : (*) => {}
        this.lvFn := customFn.hasOwnProp("ListView") ? customFn.ListView : (*) => {}

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
        setTimer(() => CB.Value := (LV.getCheckedRowNumbers().Length = LV.GetCount()), -1)

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