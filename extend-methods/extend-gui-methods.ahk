defineGuiMethods(guiProto) {
    guiProto.Prototype.getCtrlByName := getCtrlByName
    guiProto.Prototype.getCtrlByType := getCtrlByType
    guiProto.Prototype.getCtrlByTypeAll := getCtrlByTypeAll
    guiProto.ListView.Prototype.getCheckedRowNumbers := getCheckedRows
    guiProto.ListView.Prototype.getFocusedRowNumbers := getFocusedRows
    guiProto.Prototype.arcs := []

    getCtrlByName(guiProto, name) {
        for ctrl in guiProto {
            if (ctrl.Name = name) {
                return ctrl
            }
        }

        for arc in guiProto.arcs {
            if (arc.name = name) {
                return arc
            }
        }

        throw ValueError("Name not found.")
    }

    getCtrlByType(guiProto, ctrlType) {
        for ctrl in guiProto {
            if (ctrl.Type = ctrlType) {
                return ctrl
            }
        }
        throw TypeError("Control type not found.")
    }

    getCtrlByTypeAll(guiProto, ctrlType) {
        ctrlArray := []

        for ctrl in guiProto {
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