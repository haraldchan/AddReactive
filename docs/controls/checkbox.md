# AddReactive CheckBox 控件

像其他 AddReactive 控件一样，AddReactive CheckBox 可以订阅 `signal` 响应式地更新自身的文本。此外，它还可以通过特定格式的 `depend` 令复选框值响应一个 `signal`。

> 目前 AddReactive CheckBox 控件暂未支持 `shareCheckStatus()`。

<br>

决定 AddReative CheckBox 值的 `signal` 应作为一个固定使用 `checkValue` 键的对象的值传入：
```go
oGui := Gui(, "CheckBox")

label := signal("check all")
isChecked := signal(false)

oGui.AddReactiveCheckBox("...", "{1}", [label, {checkValue: isChecked}])
```
<br>

### ‼️ 注意点
 
使用 `signal` 控制复选框值时，控件的 `Click` 事件会被占用，因此直接在 CheckBox 控件上添加新的 `Click` 事件将会令响应同步失效。如果需要添加事件，可以使用 `effect()` 实现：
```go
// 根据复选框的值 (绑定 isChecked.value ) 更新 CheckBox 文本
effect(isChecked, new => 
    label.set(new = true ? "de-select all" : "select all")
)
```