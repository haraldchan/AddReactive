/**
 * Extension methods for AutoHotkey GUI controls.
 * Provides utility functions for control lookup and manipulation.
 */
class GuiExt {
    /**
     * Patches the Gui and ListView prototypes with extended methods if enabled in ARConfig.
     */
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

    /**
     * Returns a control from a GUI by its name.
     * @param {Gui} gui - The GUI object.
     * @param {String|Func} name - The name of the control.
     * @returns {Object} The control object.
     * @throws {ValueError} If the control name is not found.
     */
    static getCtrlByName(gui, name) {
        if (name is String) {
            if (gui.arcs[name]) {
                return gui.arcs[name]
            }

            if (gui[name]) {
                return gui[name]
            }
        }

        if (name is Func) {
            for ctrl in gui {
                if (name(ctrl)) {
                    return ctrl
                }
            }

            for arName, arControl in gui.arcs {
                if (name(arControl)) {
                    return arControl
                }
            }
        }

        throw ValueError("Control not found.", -1, name)
    }

    /**
     * 
     * @param {Gui} gui 
     * @param {Func} fn 
     */
    static getCtrlsByMatch(gui, fn, includeArc := false) {
        ctrls := []

        for ctrl in gui {
            if (fn(ctrl)) {
                ctrls.Push(ctrl)
            }
        }

        if (includeArc) {
            for arName, arControl in gui.arcs {
                if (fn(arControl)) {
                    ctrls.Push(arControl)
                }
            }
        }

        if (!ctrls.Length) {
            throw ValueError("Control not found.", -1, fn)
        }

        return ctrls
    }

    /**
     * Returns the first control of a given type from a GUI.
     * @param {Gui} gui - The GUI object.
     * @param {string} ctrlType - The type of the control.
     * @returns {Object} The control object.
     * @throws {TypeError} If no control of the type is found.
     */
    static getCtrlByType(gui, ctrlType) {
        for ctrl in gui {
            if (ctrl.Type == ctrlType) {
                return ctrl
            }
        }
        throw TypeError("Control type not found.", -1, ctrlType)
    }

    /**
     * Returns all controls of a given type from a GUI.
     * @param {Gui} gui - The GUI object.
     * @param {string} ctrlType - The type of the control.
     * @returns {Array<Object>} Array of control objects.
     */
    static getCtrlByTypeAll(gui, ctrlType) {
        ctrlArray := []

        for ctrl in gui {
            if (ctrl.Type == ctrlType) {
                ctrlArray.Push(ctrl)
            }
        }

        return ctrlArray
    }

    /**
     * Returns a component from a GUI by its name.
     * @param {Gui} gui - The GUI object.
     * @param {string} componentName - The name of the component.
     * @returns {Object} The component object.
     * @throws {TypeError} If the component is not found.
     */
    static getComponent(gui, componentName) {
        for component in gui.components {
            if (component.name == componentName) {
                return component
            }
        }
        throw TypeError("Component not found.", -1, componentName)
    }

    /**
     * Returns a control from a GUI by its text or by a predicate function on its text.
     * @param {Gui} gui - The GUI object.
     * @param {string|Func} text - The text to match or a predicate function.
     * @returns {Object} The control object.
     * @throws {ValueError} If no control with the text is found.
     */
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

    /**
     * Returns the row numbers of checked items in a ListView control.
     * @param {Gui.ListView} LV - The ListView control.
     * @returns {Array<number>} Array of checked row numbers.
     */
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

    /**
     * Returns the row numbers of focused items in a ListView control.
     * @param {ListView} LV - The ListView control.
     * @returns {Array<number>} Array of focused row numbers.
     */
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
