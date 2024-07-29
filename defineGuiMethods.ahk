defineGuiMethods(guiProto) {
    guiProto.Prototype.getCtrlByName := getCtrlByName
    guiProto.Prototype.getCtrlByType := getCtrlByType
    guiProto.Prototype.getCtrlByTypeAll := getCtrlByTypeAll
    guiProto.ListView.Prototype.getCheckedRowNumbers := getCheckedRowNumbers
    guiProto.ListView.Prototype.getFocusedRowNumbers := getFocusedRowNumbers

    getCtrlByName(guiProto, vName) {
        for ctrl in guiProto {
            if (ctrl.Name = vName) {
                return ctrl
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

    static getCheckedRowNumbers(LV) {
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

    static getFocusedRowNumbers(LV) {
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