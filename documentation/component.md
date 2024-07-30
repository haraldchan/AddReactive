# 组件范式

使用 AutoHotkey 编写 Gui 界面十分便捷，但在需要动态更新界面的文本或值，以及在编写完整功能的应用控件变多之后会令 Gui 的代码变得繁杂，降低易读性。因此，AddReactive 提倡使用 **函数化组件** 的形式编写 Gui 界面，让 AutoHotkey 应用的代码管理更加健康。
<br>

> 组件化编写只是一种范式倡议而非强制，即使不使用它，AddReactive 的响应式函数 `signal` 、`computed` 、`effect` 和 AddReactive 控件仍可单独使用。
<br>

### 什么是组件?

本质上，组件是一个返回一系列控件的函数。其内部可以包含自己的 `signal` 、`effect` 、事件回调函数等等。每个组件只包含应该关心与其关注点相关的内容。

```go
Increment(gui) {
    count := signal(0)

    return gui.AddReactiveText("w300 h25", "count: {1}", count)
              .OnEvent("Click", (*) => count.set(c => c + 1))
}
```

<br>

组件可以在 Gui 对象或其他组件函数中嵌套调用：

```go
oGui := Gui(, "Ahk is awesome!")
App(oGui)
oGui.Show()

App(gui) {

    return (
        gui.AddText("w300 h25", "component, also awesome"),
        Increment(gui)
    )
}
```

<br>

> ‼️ 注意点
>
> 返回多行时，需要用括号包裹，行与行之间需要用半角逗号分割（被视为连续片段的换行则不需要）。

<br>

### 传递数据

AddReactive 组件化提倡 **单向数据流**，即组件函数除了返回一系列的控件以外不应返回值，以保持对数据和组件行为的清晰可追踪性。

当嵌套的组件形成父子关系时，便可通过在父组件中为子组件传递参数的形式实现：

```go
// 父组件
App(gui) {
    initNumber := 5

    return Increment(gui, initNumber)
}

// 子组件
Increment(gui, number) {
    num := signal(number)

    return (
        gui.AddReactiveText("w300 h25", "counter: {1}", num),
        gui.AddButton("w300 h30", "++")
           .OnEvent("Click", (*) => num.set(n => n + 1))
    )
}
```

<br>

### 作为参数传递 `signal`

当多个子组件依赖同一份数据时，单向数据流将显得更加重要（如果子组件各自返回、互相读取数据，行为和数据流将混乱不堪）。在这种情况下可以将 `signal` 提升放置于父组件内，并作为参数传递给各个子组件：

```go
App(gui) {
    num := signal(5)

    return (
        gui.AddReactiveText("w300 h25", "number is :{1}", num),
        Double(gui, num),
        Triple(gui, num)
    )
}

// 接收到父组件的 signal，即可调用其 .set() 方法改变它的值
Double(gui, num) {
    doubling(*) {
        num.set(n => n * 2)
    }

    return AddButton("w300 h25", "I can double it!")
               .OnEvent("Click", doubling)
}

// 根据组件自身关注点对父组件 signal 作出响应改变
Triple(gui, num) {
    tripling(*) {
        num.set(n => n * 3)
    }

    return AddButton("w300 h25", "I can triple it!")
               .OnEvent("Click", tripling)
}
```

<br>

### 应用结构与组件树

当组件变得越来越多时，将所有组件放在同一个文件里会让维护变得越发艰难。根据组件之间的功能关系，适当对组件进行分割，存放到不同文件里是更好的实践。

通过明确组件之间的关系建立明确的文件结构，在明确其关注点的同时也更有利于在应用开发中的对组件的复用。
```
Project
├── lib
├── App
│   ├── Components
│   │   ├── ListView.ahk
│   │   ├── SearchBar.ahk
│   │   └── Button.ahk
│   └── Tabs
│       ├── History.ahk
│       └─── CurrentPage.ahk
└── assets
    ├── icon.png
    └── ...
```