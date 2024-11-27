#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
ddlComboBox(oGui)
ogui.Show()

ddlComboBox(App) {
    arrList := signal(["amy", "chloe", "harald"])
    mapList := signal(Map("amy", 111, "chloe", 222, "harald", 333))

    handleAddToArr(*) {
        item := App.getCtrlByName("addToArr").Value
        arrList.set(arrList.value.concat(item))
    }
    
    handleAddToMap(*) {
        k := App.getCtrlByName("addToMK").Value
        v := App.getCtrlByName("addToMV").Value
        newMap := mapList.value
        newMap[k] := v 
        mapList.set(newMap)
    }

    return (
        ; ddl with array
        App.ARDropDownList("w150", arrList),
        App.AddEdit("vaddToArr w100", ""),
        App.AddButton("x+10 w50", "添加").OnEvent("Click", handleAddToArr)
        
        ; combobox with map
        App.ARComboBox("w150", mapList)
        App.AddEdit("vaddToMK w50", "key"),
        App.AddEdit("vaddToMV w50 x+10", "val"),
        App.AddButton("x+10 w50", "添加").OnEvent("Click", handleAddToMap)
    )
}