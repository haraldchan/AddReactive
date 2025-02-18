# 事件绑定

AddReactive 控件添加事件的方式与原生 AutoHotkey 相同，同样使用 `.OnEvent()` 方法为控件添加事件。但 AddReactive 控件可以一次性为控件添加多个不同类型的事件，更为便利。
<br>
<br>

### 添加多个事件

向AddReactive 的 `.OnEvent()` 传入键值分别为事件类型和回调函数的 `Map` 对象：

```go
oGui.AddReactiveText("w300 h25", "event-binding...")
    .OnEvent(Map(
        "Click", (*) => MsgBox("Clicked!"),
        "DoubleClick", (*) => MsgBox("Double clicked!"),
        "ContextMenu", (*) => MsgBox("Right clicked!"),
    ))

// 像原生 ahk 一样只传入事件类型和回调函数也可以绑定事件
oGui.AddReactiveText("w300 h25", "event-binding...")
    .OnEvent("Click", (*) => MsgBox("just an event"))
```

<br>