# Effect

Effect 是一个当订阅的 `signal` 发生变化后立即运行的回调函数。
<br>
<br>

### 创建 Effect

Effect 可以通过 `effect()` 函数进行创建。它接收的参数分别为订阅对象 signal 以及 signal 变化时需要执行的回调函数：

```go
count := signal(0)

/* 当 count.set() 被调用时，这个 effect 就会被执行 */
effect(count, () => MsgBox("count changed!"))
```

<br>

回调函数还可以接收一个或两个参数，可用于获取订阅对象 `signal` 的值：

```go
count := signal(0)

effect(count, newVal => MsgBox(Format("new count: {1}", newVal)))
effect(count, (newVal, prevVal) => MsgBox(Format("new count: {1}; prev count: {2}", newValue, prevVal)))
```

<br>

### 订阅多个 signal 的 Effect

与 `computed` 类似, `effect` 也可以订阅多个 `signal` 或是 `computed`。这种情况下，回调函数的参数数量必须与订阅对象数量一致，参数获取的是订阅对象最新的值。

```go
count := signal(1)
doubleCount := computed(count, c => c * 2)

effect(
    [count, doubleCount], 
    (newCount, newDoubleCount) => MsgBox("Current sum: " . (newCount + newDoubleCount))
)
```

<br>

> **‼️ 注意点**
>
> 与 `computed` 相同，`effect` 被创建时即会被添加为 `signal` 的订阅者。因此 `effect` 不应被创建在其他可能被多次调用的函数里，否则将会导致出现不符合预期的多次执行。
>
> ```go
> count := signal(0)
>
> oGui.AddButton("w300 h30", "++")
>    .OnEvent("Click", () =>
>        count.set(c => c + 1)
>        /* 这个 effect 在每次点击后将被触发 c + 1 次 */
>        effect(count, newVal => MsgBox(Format("new count: {1}", newVal)))
>    )
> ```
