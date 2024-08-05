# Map 扩展方法

### Map.keys / Maps.values

使用 `.keys()` 、`.values()` 方法可以获取 `Map` 对象中的所有键和值：

```go
icecream := Map(
    "brand", "Haagen-Dazs", 
    "flavor", "strawberry",
    "size", "pint"
    "price", 7.99
)

keys := icecream.keys() // keys : ["brand", "flavor", "size", "price"]

values := icecream.values() // values : ["Haagen-Dazs", "strawberry", "pint", 7.99]
```
<br>

### Map.getKey

使用 `.getKey()` 方法可以通过值查询键（但当有多个相同的值时，只能返回第一个匹配的键）：
```go
size := icecream.getKey("pint") // size : "size"
```
<br>

### Map.deepClone

使用 `.deepClone()` 方法以获取一个深拷贝的 `Map` 对象。
```go
newIcecream := icecream.deepClone()
```
<br>

由于变量赋值是浅拷贝，因此当使用 `signal.set()` 方法来更新时，单纯使用变量赋值无法触发 `effect` ，而需要先使用 `.deepClone()`：
```go
icecream := signal(Map(
    "brand", "Haagen-Dazs", 
    "flavor", "strawberry",
    "size", "pint"
    "price", 7.99
))

effect(icecream, newIce => MsgBox(Format("New flavor! It's {1}", newIce["flavor"])))

// ❌ 不会触发 effect
newIcecream := icecream.value

// ✅ 深拷贝对象可以触发 effect
newIcecream := icecream.value.deepClone()

newIcecream["flavor"] := "vanilla"
icecream.set(newIcecream)

```
<br>

> **关于 `signal.udpate()`**
>
>  `signal.update()` 方法也会对值进行深拷贝后更新，因此可以触发 `effect`，也更加简洁，推荐使用它来更新复杂数据类型的 `signal`。