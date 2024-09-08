# Dynamic

`Dynamic` 是 AddReactive 的内置类组件。搭配 `signal` 和一个作为数据索引的 `Map` 对象使用可以实现 **子组件** 的动态渲染：

```js
oGui := Gui(,"Dynamic Rendering")
App(oGui)
oGui.Show()

App(gui){
    color := signal("red")
    colorComponents := Map(
        "red", Map(Red, gui),
        "blue", Map(Blue, gui),
        "green", Map(Green, gui),
    )

    Dynamic(color, colorComponents)
}

// Dynamic 动态渲染只能使用类组件
class Red extends Component {
    static name := "Red"

    __New(gui){
        super.__New(gui)
        this.render(gui)
    }

    render(gui){
        super.Add(
            gui.AddText("...")
        )
    }
}

class Blue extends Component {
    ...
}

class Green extends Component {
    ...
}
```

<br>

### `Dynamic` 的参数

`Dynamic` 接收 `color` 和 `colorComponent` 两个参数作为 **状态** 和 **组件索引** 。

`Dynamic` 的第二参数必须是一个 `Map` 对象，其中的键应为第一参数 `signal` 将会出现的值，值则为另一个 `Map` 对象，键值分别为需要被呈现的子组件以及组件参数。如果需要传入额外的参数，则子组件对应的值需要以数组形式传入：
```js
App(gui){
    template := "Current color: {1}"

    color := signal("red")
    colorComponents := Map(
        "red", Map(Red, [gui, template]),
        "blue", Map(Blue, [gui, template]),
        "green", Map(Green, [gui, template]),
    )

    Dynamic(color, colorComponents)
}

class Red extends Component {
    static name := "Red"

    __New(gui, template){
        super.__New(gui)
        this.template := template
        this.render(gui)
    }

    render(gui){
        super.Add(
            gui.AddText("...", Format(this.template, this.name))
        )
    }
}
// ...
```