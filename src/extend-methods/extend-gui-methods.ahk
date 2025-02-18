defineGuiMethods(gui) {

    gui.Prototype.getCtrlByName := getCtrlByName
    /**
     * Returns a Gui.Control or AddReactive Control instance
     * @param {String} name the name of a Gui.Control or AddReactive control
     * @returns {Gui.Control|AddReactive}
     */
    getCtrlByName(gui, name) {
        for ctrl in gui {
            if (ctrl.Name == name) {
                return ctrl
            }
        }

        for arc in gui.arcs {
            if (arc.name == name) {
                return arc
            }
        }

        throw ValueError(Format("Control name ({1}) not found.", name))
    }

    gui.Prototype.getCtrlByType := getCtrlByType
    /**
     * Returns a Gui.Control instance
     * @param {String} ctrlType the type of a Gui.Control
     * @returns {Gui.Control}
     */
    getCtrlByType(gui, ctrlType) {
        for ctrl in gui {
            if (ctrl.Type == ctrlType) {
                return ctrl
            }
        }
        throw TypeError(Format("Control type ({1}) not found.", ctrlType))
    }

    gui.Prototype.getCtrlByTypeAll := getCtrlByTypeAll
    /**
     * Returns an array of Gui.Control instances
     * @param {String} ctrlType the type of Gui.Controls
     * @returns {Gui.Control[]}
     */
    getCtrlByTypeAll(gui, ctrlType) {
        ctrlArray := []

        for ctrl in gui {
            if (ctrl.Type == ctrlType) {
                ctrlArray.Push(ctrl)
            }
        }

        return ctrlArray
    }

    gui.Prototype.getComponent := getComponent
    /**
     * Returns a Component instace
     * @param {String} componentName the name of a component
     * @returns {Component}
     */
    getComponent(gui, componentName) {
        for component in gui.components {
            if (component.name == componentName) {
                return component
            }
        }
        throw TypeError(Format("Component({1}) not found.", componentName))
    }

    gui.Prototype.getCtrlByText := getCtrlByText
    /**
     * Returns a Gui.Control
     * @param {String|Func} text 
     */
    getCtrlByText(gui, text) {
        for ctrl in gui {
            if (text is Func && text(ctrl.Text)) {
                return ctrl
            } else if (ctrl.Text == text) {
                return ctrl
            }
        }

        throw ValueError(Format("Control with Text ({1}) not found.", text))
    }

    gui.ListView.Prototype.getCheckedRowNumbers := getCheckedRows
    /**
     * Returns an array of checked row numbers of a ListView
     * @param LV the Gui.ListView
     * @returns {Array} 
     */
    getCheckedRows(LV) {
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

    gui.ListView.Prototype.getFocusedRowNumbers := getFocusedRows
    /**
     * Returns an array of focused row numbers of a ListView
     * @param LV the Gui.ListView
     * @returns {Array} 
     */
    getFocusedRows(LV) {
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

defineGuiMethods(Gui)