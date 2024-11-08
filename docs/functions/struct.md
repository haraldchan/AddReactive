# Struct

`Struct` 可用于定义对象的“结构”，在需要严格控制对象的是相当有用。它也可以用于描述对象的数据类型。
<br>
<br>

### 创建与实现

```go
// 向 Struct 传入 Object/Map 定义数据类型
Person := Struct({
    name: String,
    age:  Integer,
    // 值为数组且需要限定元素内容时，可以如下声明
    hobbies: [String]
})

// 通过 Struct 的 new 创建一个实例
John := Person.new({
    name: "John",
    age: 26,
    hobbies: ["tennis", "jog", "code"]
})
```

<br>

### 结构与类型限制

`Struct` 的实例结构必须与其相同（属性名、嵌套关系、数据类型），不允许缺少属性：
```go
Jeff := Person.new({
    name: "Jeff",
    age: 33
})

// ValueError: Struct fields not match, missing: hobbies
```
同样，也不能有更多的属性：
```go
Jennifer := Person.new({
    name: "Jennifer",
    age: 29,
    hobbies: ["calligraphy", "movie"],
    favColor: "cyan"
})

// ValueError: Struct fields not match, unknown: favColor
```

<br>

### 取值与赋值

`Struct` 使用方括号进行取值与赋值操作：

```go
name := John["name"] // name: "John"

John["age"] := 30    // John["age"]: 30
```
<br>

对 `Struct` 的属性进行赋值时，必须符合定义是的对象类型：
```go
John["age"] := "30" 

// TypeError:  Expected value type of key:age does not match. Expected: Integer, Current: String
```
<br>

与创建时相同，`Struct` 不允许通过赋值设置定义新的属性：
```go
John["car"] := "Lambo"

// ValueError: key:car not found.
```
<br>

### `Struct` 嵌套

定义多层嵌套的 `Struct` 时，可定义多个 `Struct`：
```go
Contact := Struct({
    tel:   Integer,
    email: String
})

Person := Struct({
    name: String,
    age:  Integer,
    contact: Contact
})

// 创建 Struct 实例时传入符合实现结构的 Object/Map
Jonny := Person.new({
    name: "Jonny",
    age: 34,
    contact: {
        tel: 82341245,
        email: "jonny@gmail.com"
    }
})

email := Jonny["contact"]["email"] // email:  "jonny@gmail.com"
```

<br>

### 枚举遍历

使用 `for` 循环来遍历 `Struct` 的属性键值：
```go
For key [, value] in Struct.StructInstance
```
```go
for key, value in Jonny {
    MsgBox(Format("key: {1}, value: {2}", key, value))
}
```