# AddReactive 控件

AddReactive 控件是 `Gui.Add()` 的扩展。它可以通过订阅 `signal` 和 `computed` 来更新自身呈现文本或内容。
<br>
<br>

### 使用 AddReactive 控件

与原生 AutoHotkey 类似，可以通过 `Gui.AddReactive()` 方法添加一个控件：
```go
oGui := Gui(, "AddReactive Controls")

oGui.AddReactive("Text", "w300 h20", "Hello World!")

// 或使用等效的方法添加控件，与原生 ahk 相同
oGui.AddReactiveText("w300 h20", "Hello World!")
```
<br>

### 响应式 AddReactive 控件

如果只是像上面例子一样添加控件，其本质与 ahk 原生控件别无二致。要令 AddReactive 控件具备响应式动态更新的能力，需要添加订阅 `signal` 或 `computed` ：
```go
count := signal(0)

// 在控件文本参数中传入格式化字符串, 其后的参数传入希望订阅的 signal，如同使用 Format() 一样
showCount := oGui.AddReactiveText("w300 h20", "count is {1}", count)
```
<br>

具备订阅对象的 AddReactive 控件在其订阅对象更新时，也会同步更新：
```go
count.set(5)

// showCount.Text : count is 5
```
<br>

### 多个订阅对象的控件

正如 `Format()` 可以接收多个输入值，AddReactive 控件同样可以订阅多个 `signal` :
```go
count := signal(1)
doubled := computed(count, c => c * 2)

// 订阅多个 signal/computed 时
showNums := oGui.AddReactiveText("w300 h25", "count: {1}, doubled: {2}", [count, doubled])

// showNums.Text : count: 1, doubled: 2
```
<br>