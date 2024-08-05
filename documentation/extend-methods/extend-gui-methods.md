# Gui 扩展方法

### Gui.getCtrlByName

使用 `.getCtrlByName()` 可以通过传入一个字符串，获取与它拥有相同 `name` 属性的控件。搭配已命名的控件，在需要快速访问并对其进行操作时十分有效。

> **‼️ 注意点** 
>
> 如果 Gui 中有多个相同命名的控件， `.getCtrlByName()` 也只能获取到第一个。AddReactive 提倡将 `name` 作为控件的唯一 id 使用，以令获取、访问控件的效率更高。
```go
oGui := Gui(, "Gui Methods")

textCtrl := oGui.AddText("vText w300 h25", "A text control.")

// 获取 textCtrl 并修改它的文本
oGui.getCtrlByName("Text").Text := "Now, change the text."
```
<br>

### Gui.getCtrlByType / Gui.getCtrlByTypeAll

使用 `.getCtrlByType()` 可以通过传入一个字符串，获取与它类型相同的控件。此方法只能获取到 Gui 中第一个匹配类型的控件，适合获取如 `DateTime`、`MonthCal` 和 `ListView` 等通常只会在 Gui 中存在一个的控件：
```go
calendar := oGui.AddMonthCal("...")

// 获取并修改 calendar 的 Value
oGui.getCtrlByType("MonthCal").Value := "20240101"
```
<br>

如果需要一次获取多个同类型的控件，则可以使用 `.getCtrlByTypeAll()`。它将返回一个获取到所有匹配控件的数组：
```go
oGui.AddText("w300 h25", "first line.")
oGui.AddText("w300 h25", "second line.")
oGui.AddText("w300 h25", "third line.")

textCtrls := oGui.getCtrlByTypeAll("Text")

for ctrl in textCtrls {
    MsgBox(ctrl.Text)
    // 将分别弹出：“first line.”、“second line.”、“third line.”
}
```
<br>

## Gui.ListView 扩展方法

### Gui.ListView.getFocusedRows

使用 `.getFocusedRows()` 可以获取到当前 `ListView` 控件中所有被高亮的行号：
```go
oGui.AddListView("...")

focusedRows := oGui.getCtrlByType("ListView").getFocusedRows()
// focusedRows : [1, 2, 3, ...]
```
<br>

### Gui.ListView.getCheckedRows

当 `ListView` 控件选项中有 "Checked" 选项时，使用 `.getCheckedRows()` 可以获取到当前 `ListView` 控件中所有被选择的行号。
```go
oGui.AddListView("Checked ...")

checkedRows := oGui.getCtrlByType("ListView").getCheckdRows()
// checkedRows : [1, 2, 3, ...]
```