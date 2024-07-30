# Signal
### 什么是 signal?

signal 是一个对变量的封装，它可以在自身的值更新时实时通知关联订阅者。它的值可以是基础也可以是复杂数据类型。
<br>
<br>

### 创建与读写

signal 可以通过 `signal` 函数进行创建：

```go
count := signal(0) // 参数为 signal 的初始值
```
<br>

要对 signal 进行读写，可以通过 `.value` 属性及 `.set()` 方法实现：

```go
MsgBox(Format("count is: {1}"), count.value)

count.set(3) // count.value : 3
```
<br>

以函数作为 `.set()` 方法的参数，也可以实现对 signal 值的更新：

```go
count.set(3)

count.set(val => val + 1) // count.value : 4
```
<br>

> **‼️ 注意点** 
> 
>  需要注意的是，只有通过 `.set()` 方法更新 singal 的值，才能保持所有订阅者能够获取到最新的值。 虽然可以通过直接修改 `.value` 来改变值，但这样做会破坏响应性的关联，因此，即使 `.value` 可写，但仍然应被视为是只读的。

<br>

### 复杂数据类型的更新

signal 的值可以是数组和 `Map` 对象：
```go
numbers := signal([1, 2, 3])

apple := signal(Map("color", "red", "amount", 5))

// 基础对象也可以被接收，但在 singal 内部会被转换为 Map
staff := signal({name: "john", position: "manager"})
```
<br>

需要留意的是，`.set()` 方法并不能局部更新复杂数据类型的 `signal`，只能复制原值，部分更新后再次调用 `.set()`：
```go
newApple := apple.value
newApple["color"] := "green"

apple.set(newApple) // apple.value => Map("color", "green", "amount", 5)
```
<br>

如果要局部更新复杂数据类型的 `signal` ，应使用 `.update()` 方法，传入 key/index 和新的值进行更新：
```go

numbers.update(1, 9) // numbers.value : [9, 2, 3]

apple.update("amount", 10) // apple.value : Map("color", "green", "amount", 10)
```
<br>