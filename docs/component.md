# 组件范式

使用 AutoHotkey 编写 Gui 界面十分便捷，但在需要动态更新界面的文本或值，以及在编写完整功能的应用控件变多之后会令 Gui 的代码变得繁杂，降低易读性。因此，AddReactive 提倡使用 **组件** 的形式编写 Gui 界面，让 AutoHotkey 应用的代码管理更加健康。

组件通过 **函数组件** 和 **类组件** 两种形式编写。

> 组件化编写只是一种范式倡议而非强制，即使不使用它，AddReactive 的响应式函数 `signal` 、`computed` 、`effect` 和 AddReactive 控件仍可单独使用。

<br>

### 应用结构与组件树

明确权责对组件进行分割可以令代码维护更加方便，但当组件变得越来越多时，将所有组件放在同一个文件里会让维护变得越发艰难。根据组件之间的功能关系，适当对组件进行分割，存放到不同文件里是更好的实践。

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

<br>

## 函数组件

### 什么是组件?

本质上，函数组件是一个返回一系列控件的函数。其内部可以包含自己的 `signal` 、`effect` 、事件回调函数等等。每个组件只包含应该关心与其关注点相关的内容。

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

    return gui.AddButton("w300 h25", "I can double it!")
               .OnEvent("Click", doubling)
}

// 根据组件自身关注点对父组件 signal 作出响应改变
Triple(gui, num) {
    tripling(*) {
        num.set(n => n * 3)
    }

    return gui.AddButton("w300 h25", "I can triple it!")
               .OnEvent("Click", tripling)
}
```

<br>

## 有状态组件 (Stateful component)

函数组件的使用简单直接，但在条件渲染组件等需要同时控制组件内所有控件状态时，则需要使用 `Component` 类并返回它的实例：

```go
Increment(gui, number) {
    // 使用  Component 类创建一个组件实例。需要传入的参数未 Gui 和 组件名称 (使用 A_ThisFunc 最为便利)
    i := Component(gui, A_ThisFunc)
    num := signal(number)

    ...
}
```

<br>

使用有状态组件时，挂载组件内部的控件应使用命名为 `render` 的函数进行添加。添加时使用 `Add` 方法：

```go
Increment(gui, number) {
    i := Component(gui, A_ThisFunc)
    num := signal(number)

    // render 函数应添加到组件实例 `i` 上，因此第一个参数为实例自身
    i.render := (this) => this.Add(
        gui.AddReactiveText("w300 h25", "counter: {1}", num),
        gui.AddButton("w300 h30", "++")
           .OnEvent("Click", (*) => num.set(n => n + 1))
    )

    // 返回时不在返回控件，而是组件实例。如果添加组件时需要立即渲染，应返回 i.render()
    return i
}
```

<br>

> **‼️ 注意点**
>
> 因 `Component.Add()` 方法只接收控件实例作为参数，链式调用原生控件的 `.OnEvent()` 方法将返回空字符串，因此如果想使用 OnEvent 直接绑定事件，只能使用 AddReactive 控件。

<br>

### 其他 `Component` 方法

`Component` 实例除了 `Add()` 以外，还具备更多的方法。

#### `visible()`

`visible()` 可以在 `Dynamic` 或其他需要动态显示/隐藏的的场景下使用：
```go
App(gui) {
    ...

    isShow := singal(true)

    handleVisible(ctrl, _){
        isShow.set(s => !s)
        gui.getComponent("Increment").visible(isShow.value)
    }

    return (
        Increment(gui, initNumber)
        gui.AddButton("...", "show/hide").OnEvent("Click", handleVisible)
    )
}

Increment(gui, number) {
    i := Component(gui, A_ThisFunc)
    ...

    return i
}
```

<br>

#### `submit()`

与原生 `Gui` 的 `Submit()` 方法类似，`Component` 的 `submit()` 方法可以收集组件内具名控件的值并返回一个对象：
```go
PersonalInfo(gui) {
    pi := Component(gui, A_ThisFunc)

    showInfo(*) {
        form := pi.submit()
        // form : { name: "John Doe", age: "30", tel: "888-88888888" }
    }

    pi.render := (this) => this.Add(
        gui.AddText("...", "name"),
        gui.AddEdit("...", "John Doe"),

        gui.AddText("...", "age"),
        gui.AddEdit("...", "30"),

        gui.AddText("...", "tel"),
        gui.AddEdit("...", "888-88888888"),

        gui.AddButton("...", "show info").OnEvent("Click", showInfo)
    )

    return pi
}
```

 <br>