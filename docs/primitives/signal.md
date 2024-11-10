# Signal

### 什么是 Signal?

Signal 是一个对变量的封装，它可以在自身的值更新时动态地实时通知关联订阅者。它的值可以是基础也可以是复杂数据类型。
<br>
<br>

### 创建与读写

Signal 可以通过 `signal()` 函数进行创建：

```go
count := signal(0) // 参数为 signal 的初始值
```

<br>

要对 `signal` 进行读写，可以通过 `.value` 属性及 `.set()` 方法实现：

```go
MsgBox(Format("count is: {1}"), count.value)

count.set(3) // count.value : 3
```

<br>

以函数作为 `.set()` 方法的参数，也可以实现对 `signal` 值的更新：

```go
count.set(3)

count.set(val => val + 1) // count.value : 4
```

<br>

> **‼️ 注意点**
>
> 需要注意的是，只有通过 `.set()` 方法更新 `singal` 的值，才能保持所有订阅者能够获取到最新的值。 虽然可以通过直接修改 `.value` 来改变值，但这样做会破坏响应性的关联，因此，即使 `.value` 可写，但仍然应被视为是只读的。

<br>

### 声明 `signal` 值类型

`signal` 的值默认为动态类型。需要对值的类型进行约束时，可使用 `.as()` 方法：

```go
count := signal(1).as(Integer)

name := signal("Thomas").as(String)


count.set("John") 
// TypeError: Expect Type: Integer. Current Type: String

name.set(42)     
// TypeError: Expect Type: String. Current Type: Integer
```

<br>

### 复杂数据类型的更新

`signal` 的值可以是 `Array` 、 `Map` 或 `Struct` 对象：

```go
numbers := signal([1, 2, 3])

apple := signal(Map("color", "red", "amount", 5))

// 基础对象也可以被接收，但在 singal 内部会被转换为 Map
staff := signal({name: "john", position: "manager"})
```

<br>

需要留意的是，`.set()` 方法并不能局部更新复杂数据类型的 `signal`，只能复制原值，部分更新后再调用 `.set()`：

```go
newApple := apple.value
newApple["color"] := "green"

apple.set(newApple) // apple.value => Map("color", "green", "amount", 5)
```

<br>

如果要局部更新复杂数据类型的 `signal` ，应使用 `.update()` 方法，传入参数 `key/index` 和 `newValue` 进行更新：

```go
numbers.update(1, 9) // numbers.value : [9, 2, 3]

apple.update("amount", 10) // apple.value["amount"] : 10
```

<br>

需要注意的是，如果值是多层嵌套的对象，传入单一属性键返回的是 **对象中第一个匹配的值** ，当需要更新 **指定某个属性** 的值，则应以数组形式传入第一参数：
```go
staff := signal({
    name: "John",
    age: 33,
    contact: {
        tel: 38573024,
        email: "johndoe@gmail.com"
    },
    company: {
        address: "xx street, no.xxx",
        tel: 49573820
    }
})

staff.update("tel", 13894769392) // 更新的是 staff.value["contact"]["tel"]

staff.update(["company", "tel"], 88683728) // 更新的是 staff.value["company"]["tel"]
```