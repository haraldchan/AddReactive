# 列表渲染

订阅了数据类型为 `Array` 或 `Map` 的 AddReactive 控件提供了多种实现以列表形式呈现动态内容的方式。当 `signal` 内的动态数据更新时，列表中对应的项目也将实时更新。
<br>
<br>

### 使用 `IndexList` 渲染数组

订阅数据类型为 `Array` 的 AddReactive 控件适合使用 `IndexList`。它会将数组中的值全部呈现到控件文本：

```go
fruits := signal(["apple", "orange", "banana"])

oGui.IndexList("Text", "w300 h25", "It's a(n) {1}!", fruits)

/* 在 Gui 窗口上：
It's a(n) apple!
It's a(n) orange!
It's a(n) banana!
*/
```

<br>

### 使用 `KeyList` 渲染对象

订阅数据类型为 对象或 `Map` 的 AddReactive 控件适合使用 `KeyList`。与 `IndexList` 不同的是，需要指定键在格式化字符串中的位置：

```go
staff := signal([
    { name: "Amy", pos: "manager" },
    { name: "Chloe", pos: "supervisor" },
    { name: "Elody", pos: "attendent" }
])

oGui.KeyList(
    "Edit",
    "w300 h25",
    // 以形式指定对应键值的输出位置（与 Format() 类似）
    "staff name: {1}, position: {2}", staff, ["name", "pos"]
)

/* 在 Gui 窗口上：
staff name: Amy, position: manager
staff name: Chloe, position: supervisor
staff name: Elody, position: attendent
*/
```

<br>

### 条件渲染

`IndexList` 和 `KeyList` 使用简单，但它们只会将 `signal` 中的所有值全部渲染到 Gui 窗口中。想要进行条件渲染，需要使用 AddReactive 控件中的 `key` 参数。

对 `Array` 进行列表渲染时，可以通过控制 `A_Index` 来控制渲染项目：

```go
fruits := signal(["apple", "orange", "banana", "strawberry"])

loop fruits.value.Length {
    // 只输出偶数索引项目
    if (Mod(A_Index, 2) = 0) {
        continue
    } else {
        oGui.AddReactiveText("w300 h25", "It's a(n) {1}!", fruits, A_Index)
    }
}

/* 在 Gui 窗口上：
It's a(n) orange!
It's a(n) strawberry!
*/
```

<br>

对对象或 `Map` 进行列表渲染时，同样通过将 `A_Index` 作为参数达到效果。但需要将它和指定顺序的键放到一个数组中：

```go
staff := signal([
    { name: "Amy", pos: "manager" },
    { name: "Chloe", pos: "supervisor" },
    { name: "Elody", pos: "attendent" }
])

for staff in staff.value.Length {
    if (staff["pos"] = "manager") {
        continue
    } else {
        oGui.AddReactiveEdit(
            "w300 h25",
            "staff name: {1}, position: {2}", staff, [[A_Index], "name", "pos"]
        )
    }
}

/* 在 Gui 窗口上：
staff name: Chloe, position: supervisor
staff name: Elody, position: attendent
*/
```

<br>

直接使用指定下标索引作为 `key` 参数，也可以指定渲染单条项目：

```go
staff := signal([
    { name: "Amy", pos: "manager" },
    { name: "Chloe", pos: "supervisor" },
    { name: "Elody", pos: "attendent" }
])

oGui.AddReactiveEdit(
    oGui.AddReactiveEdit(
        "w300 h25",
        "staff name: {1}, position: {2}", staff, [[1], "name", "pos"]
    )
)

/* 在 Gui 窗口上：
staff name: Amy, position: manager
*/
```