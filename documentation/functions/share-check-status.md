# shareCheckStatus

使用 `shareCheckStatus()` 可以关联 `CheckBox` 和 带有复选框 (Checked) 选项的 `ListView`，共享选中状态。被关联的控件必须同时为 **原生控件** 或 **AddReactive 控件**。
<br>
<br>

### 关联控件（原生控件）

向 `shareCheckStatus()` 传入 `CheckBox` 和 `ListView` 控件，即可关联：

```go
oGui := Gui(, "binding controls")

cb := oGui.AddCheckBox("...")
lv := oGui.AddListView("...")

shareCheckStatus(cb, lv)
```

<br>

在函数组件的范式中，推荐使用 Gui 扩展方法获取控件，在存在多个控件或组件嵌套时更加容易地获取控件而无需为控件声明变量：

```go
App(gui) {

    return (
        // ...

        gui.AddCheckBox("vcb ..."),
        gui.AddListView("vlv ..."),

        shareCheckStatus(
            gui.getCtrlByName("cb"),
            gui.getCtrlByName("lv")
        )
    )
}
```

<br>

> **‼️ 注意点**
>
> `shareCheckStatus()` 必须在 `CheckBox` 和 `ListView` 均已被添加到 Gui 之后才可生效。换而言之，它必须在添加语句后使用（不管是在组件内部还是在父组件之中），否则将无法正确获取到控件。

<br>

### 关联控件（AddReactive 控件）

当需要使用 `signal` 来关联控件复选状态时，可使用 `AddReactiveCheckBox` 和 `AddReactiveListView` 实现。此使用模式下，AddReactive 控件必须具名，并需在 `checkShareStatus()` 传入第三个参数 `options`：

```go
App(gui) {
    isCheckedAll := signal(false)

    return (
        // ...
        // 必须为具名"$"控件
        gui.AddReactiveCheckBox("$cb ..."),
        gui.AddListView("$lv ..."),
        // ...

        shareCheckStatus(
            gui.getCtrlByName("$cb"),
            gui.getCtrlByName("$lv"),
            // 在第三参数中将关联的 signal 以 checkStatus 属性值的形式传入
            { checkStatus: isCheckedAll }
        )
    )
}
```

<br>

### 添加事件

需要留意的是，`shareCheckStatus()` 会占用 `CheckBox` 的 "Click" 事件和 `ListView` 的 "ItemCheck" 事件。如果往控件上添加同类型事件将会覆盖 `shareCheckStatus()` ，令其失效。

需要为这两个事件添加额外行为时，可以向 `checkShareStatus()` 传入第三个参数 `options`。

```go
App(gui) {

    return (
        // ...

        gui.AddCheckBox("vcb ..."),
        gui.AddListView("vlv ..."),
        // ...

        shareCheckStatus(
            gui.getCtrlByName("cb"),
            gui.getCtrlByName("lv"),
            // 允许 options 对象只包含 CheckBox 或 ListView，但属性名称必须为 CheckBox、ListView。
            {
                CheckBox: (*) => MsgBox("Checked"),
                // 属性值也可以接收包含多个函数对象的数组
                ListView: [
                    (*) => MsgBox("Item checked!"),
                    (*) => MsgBox("Definitely checked!")
                ]
            }
        )
    )
}

```

<br>

> **‼️ 注意点**
>
> 因 `shareCheckStatus()` 是类，因此 `options` 中的函数对象第一参数为 `shareCheckStatus()` 本身。
