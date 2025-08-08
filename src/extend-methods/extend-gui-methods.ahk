class GuiExt {
    static patch() {
        if (!ARConfig.useExtendMethods) {
            return
        }

        for method, status in ARConfig.enableExtendMethods.gui.OwnProps() {
            if (method == "listview") {
                for lvMethod, lvStatus in status.OwnProps() {
                    if (lvStatus) {
                        Gui.ListView.Prototype.%lvMethod% := ObjBindMethod(this, lvMethod)
                    }
                }
                continue
            }

            if (status) {
                Gui.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    static getCtrlByName(gui, name) {
        if (gui.arcs[name]) {
            return gui.arcs[name]
        }

        if (gui[name]) {
            return gui[name]
        }

        throw ValueError("Control name not found.", -1, name)
    }

    static getCtrlByType(gui, ctrlType) {
        for ctrl in gui {
            if (ctrl.Type == ctrlType) {
                return ctrl
            }
        }
        throw TypeError("Control type not found.", -1, ctrlType)
    }

    static getCtrlByTypeAll(gui, ctrlType) {
        ctrlArray := []

        for ctrl in gui {
            if (ctrl.Type == ctrlType) {
                ctrlArray.Push(ctrl)
            }
        }

        return ctrlArray
    }

    static getComponent(gui, componentName) {
        for component in gui.components {
            if (component.name == componentName) {
                return component
            }
        }
        throw TypeError("Component not found.", -1, componentName)
    }

    static getCtrlByText(gui, text) {
        for ctrl in gui {
            if (text is Func && text(ctrl.Text)) {
                return ctrl
            } else if (ctrl.Text == text) {
                return ctrl
            }
        }

        throw ValueError("Control with Text not found.", -1, text)
    }

    static getCheckedRowNumbers(LV) {
        checkedRowNumbers := []
        loop LV.GetCount() {
            curRow := LV.GetNext(A_Index - 1, "Checked")
            try {
                if (curRow == prevRow || curRow == 0) {
                    Continue
                }
            }
            checkedRowNumbers.Push(curRow)
            prevRow := curRow
        }
        return checkedRowNumbers
    }

    static getFocusedRowNumbers(LV) {
        focusedRows := []
        rowNumber := 0
        loop {
            rowNumber := LV.GetNext(RowNumber)
            if (!rowNumber) {
                break
            }
            focusedRows.Push(rowNumber)
        }
        return focusedRows
    }
}
