# Dynamic

`Dynamic` 是 AddReactive 的内置组件。搭配 `signal` 和一个作为数据索引的 `Map` 对象使用可以实现 **子组件** 的动态渲染：

```go
oGui := Gui()
App(oGui)
ogui.Show()

App(App) {
    color := signal("Red")
    colorComponents := Map(
        "Red", Red,
        "Blue", Blue,
        "Green", Green,
    )

    return (
        App.AddDropDownList("w150 Choose1", ["Red", "Blue", "Green"])
        .OnEvent("Change", (ctrl, _) => color.set(ctrl.Text)),
        
        Dynamic(
            color, 
            colorComponents, 
            ; pass in an object of props that use by all components in Dynamic
            { app: App, style: "x20 y50 w200" }
        )
    )
}

// Dynamic 动态渲染必须使用有状态组件
Red(props) {
    App := props.app

    R := Component(App, A_ThisFunc)
    R.render := (this) => this.Add(App.AddText(props.style, "RED TEXT"))
    
    return R
}

Blue(props) {
    ...
}

Green(props) {
    ...
}
```

<br>

### `Dynamic` 的参数

`Dynamic` 接收 `signal` 和 `componentEntries` 两个参数作为 **状态** 和 **组件索引** ，第三参数 `props` 则为函数对象需传入的参数。

`Dynamic` 的第二参数为组件函数对象：
```go
App(gui){
    template := "Current color: {1}"

    color := signal("Red")
    colorComponents := Map(
        "Red", Red,
        "Blue", Blue,
        "Green", Green,
    )

    Dynamic(color, colorComponents, { gui: gui, template: template })
}

// Dynamic 将会调用组件函数并将 props 对象作为参数传入
Red(props) {
    gui := props.gui
    template := props.template

    r := Component(gui, A_ThisFunc)

    r.render := (this) => this.Add(
        gui.AddText("...", Format(template, A_ThisFunc))
    )

    return r
}

Blue(App, template) {
    ...
}

Green(App, template) {
    ...
}
```