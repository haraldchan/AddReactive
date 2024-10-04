# Dynamic

`Dynamic` 是 AddReactive 的内置组件。搭配 `signal` 和一个作为数据索引的 `Map` 对象使用可以实现 **子组件** 的动态渲染：

```go
oGui := Gui(,"Dynamic Rendering")
App(oGui)
oGui.Show()

App(gui){
    color := signal("Red")
    colorComponents := Map(
        "Red", Red(gui),
        "Blue", Blue(gui),
        "Green", Green(gui),
    )

    Dynamic(color, colorComponents)
}

// Dynamic 动态渲染必须使用有状态组件
Red(gui) {
    r := Component(gui, A_ThisFunc)

    r.render := (this) => this.Add(gui.AddText(...))

    return r
}

Blue(App) {
    ...
}

Green(App) {
    ...
}
```

<br>

### `Dynamic` 的参数

`Dynamic` 接收 `color` 和 `colorComponent` 两个参数作为 **状态** 和 **组件索引** 。

`Dynamic` 的第二参数为组件实例，需要传入额外参数时，与调用组件时相同即可：
```go
App(gui){
    template := "Current color: {1}"

    color := signal("Red")
    colorComponents := Map(
        "Red", Red(gui, template),
        "Blue", Blue(gui, template),
        "Green", Green(gui, template),
    )

    Dynamic(color, colorComponents)
}

Red(gui) {
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