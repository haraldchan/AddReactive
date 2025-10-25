#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
DdlComboBoxTest(oGui)
oGui.Show()

DdlComboBoxTest(App) {
    arrList := signal(["amy", "chloe", "harald"])
    mapList := signal(Map("amy", 111, "chloe", 222, "harald", 333))

    handleAddToArr(*) {
        item := App.getCtrlByName("addToArr").Value
        arrList.set(arrList.value.append(item))
    }
    
    handleAddToMap(*) {
        k := App.getCtrlByName("addToMK").Value
        v := App.getCtrlByName("addToMV").Value
        newMap := mapList.value.deepClone()
        newMap[k] := v 
        mapList.set(newMap)
    }

    handleReset(*) {
        arrList.reset()
        mapList.reset()
    }

    showKV(ctrl) {
        curKey := ctrl.Text
        curVal := App.getCtrlByName("$cb").optionsValues[ctrl.Value]

        msgbox Format("selected key: {1}; value: {2}", curKey, curVal)
    } 

    return (
        ; ddl with array
        App.ARDropDownList("X20 w150 Choose1", arrList),
        App.AddEdit("vaddToArr w100", ""),
        App.AddButton("x+10 w50", "Add").OnEvent("Click", handleAddToArr),
        
        ; combobox with map
        App.ARComboBox("$cb X20 w150 Choose1", mapList).OnEvent(
            "Change", (ctrl, *) => showKV(ctrl),
            "ContextMenu", (ctrl, *) => MsgBox(ctrl.Text)
        ),
        App.AddEdit("vaddToMK w50", "key"),
        App.AddEdit("vaddToMV w50 x+10", "val"),
        App.AddButton("x+10 w50", "Add").OnEvent("Click", handleAddToMap),

        App.AddButton("w50", "reset").OnEvent("Click", handleReset)
    )
}