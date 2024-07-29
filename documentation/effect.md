# Effect

effect 是一个当订阅的 signal 发生变化后立即运行的回调函数。
<br>
<br>

### 创建 Effect

effect 可以通过 `effect` 函数进行创建。它接收的参数分别为订阅对象 signal 以及signal 变化时需要执行的回调函数：

```C++
count := signal(0)

// 当 count.set() 被调用时，这个 effect 就会被执行
effect(count, () => MsgBox("count changed!"))
```
<br>

回调函数还可以接收一个或两个参数，可用于获取订阅对象 signal 的值：
```C++
count := signal(0)

effect(count, newVal => MsgBox(Format("new count: {1}", newVal)))
effect(count, (newVal, prevVal) => MsgBox(Format("new count: {1}; prev count: {2}", newValue, prevVal)))
```
<br>
<hr>

### 注意点
与 computed 相同，effect 被创建时即会被添加为 signal 的订阅者。因此 effect 不应被创建在其他可能被多次调用的函数里，否则将会导致出现不符合预期的多次执行。
```C++
count := signal(0)

oGui.AddButton("w300 h30", "++")
    .OnEvent("Click", () => 
        count.set(c => c + 1)
        // 这个 effect 在每次点击后将被触发 c + 1 次
        effect(count, newVal => MsgBox(Format("new count: {1}", newVal)))
    )
```