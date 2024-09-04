defineGuiMethods(gui) {
    gui.Prototype.getCtrlByName := getCtrlByName
    gui.Prototype.getCtrlByType := getCtrlByType
    gui.Prototype.getCtrlByTypeAll := getCtrlByTypeAll
    gui.ListView.Prototype.getCheckedRowNumbers := getCheckedRows
    gui.ListView.Prototype.getFocusedRowNumbers := getFocusedRows
    gui.Prototype.arcs := []
    gui.Prototype.arcGroups := []

    getCtrlByName(gui, name) {
        for ctrl in gui {
            if (ctrl.Name = name) {
                return ctrl
            }
        }

        for arc in gui.arcs {
            if (arc.name = name) {
                return arc
            }
        }

        throw ValueError(Format("Control name ({1}) not found.", name))
    }

    getCtrlByType(gui, ctrlType) {
        for ctrl in gui {
            if (ctrl.Type = ctrlType) {
                return ctrl
            }
        }
        throw TypeError(Format("Control type ({1}) not found.", ctrlType))
    }

    getCtrlByTypeAll(gui, ctrlType) {
        ctrlArray := []

        for ctrl in gui {
            if (ctrl.Type = ctrlType) {
                ctrlArray.Push(ctrl)
            }
        } 

        return ctrlArray
    }

    static getCheckedRows(LV) {
        checkedRowNumbers := []
        loop LV.GetCount() {
            curRow := LV.GetNext(A_Index - 1, "Checked")
            try {
                if (curRow = prevRow || curRow = 0) {
                    Continue
                }
            }
            checkedRowNumbers.Push(curRow)
            prevRow := curRow
        }
        return checkedRowNumbers
    }

    static getFocusedRows(LV) {
        focusedRows := []
        rowNumber := 0  
        loop {
            rowNumber := LV.GetNext(RowNumber)  
            if(!rowNumber) {
                break
            }
            focusedRows.Push(rowNumber)
        }
        return focusedRows
    }
}

defineGuiMethods(Gui)