# Gui 扩展方法

### Gui.getCtrlByName

使用 `.getCtrlByName()` 可以通过传入一个字符串，获取与它拥有相同 `name` 属性的控件。搭配已命名的控件，在需要快速访问并对其进行操作时十分有效。

> **‼️ 注意点**
>
> 如果 Gui 中有多个相同命名的控件， `.getCtrlByName()` 也只能获取到第一个。AddReactive 提倡将 `name` 作为控件的唯一 id 使用，以令获取、访问控件的效率更高。

```go
oGui := Gui(, "Gui Methods")

oGui.AddText("vTextCtrl w300 h25", "A text control.")

// 获取 TextCtrl 并修改它的文本
oGui.getCtrlByName("Text").Text := "Now, change the text."
```

<br>

使用 `"vname"` 原生选项只能获取到控件本身，如果需要获取到 AddReactive 控件实例，则需要以 `"$name"` 来获取。为了避免与原生 `name` 属性冲突，AddReactive 控件不论是添加时还是获取时都必须带有 "$" 符号：

```go
oGui.AddReactiveText("$arText vTextCtrl w300 h25", "A reactive text control.")

// 获取的是 AddReactive 控件，可以使用 AddReactive 控件实例方法
oGui.getCtrlByName("$arText").OnEvent(Map(
    "Click", (*) => MsgBox("Clicked!"),
    "DoubleClick", (*) => MsgBox("Double clicked!")
))

```

<br>

如需获取获取到控件本身而非 AddReactive 控件实例，可以访问 `.ctrl` 属性：

```go
oGui.AddReactiveText("$arText vTextCtrl w300 h25", "A reactive text control.")

textCtrl := oGui.getCtrlByName("$arText").ctrl
// 等效于：oGui.getCtrlByName("TextCtrl")，因此应用中只需使用"$"命名
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

### Gui.getComponent

使用`.getComponent()` 可以获取有状态组件实例：
```go
oGui := Gui(gui)

comp(gui) {
    c := Component(gui, A_ThisFunc)

    c.render := this => this.Add(...)

    return c
}

oGui.getComponent("comp").visible(false) // 可以获取实例并对其进行响应操作
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
