# 扩展方法

AddReactive 在原生 AutoHotkey 的的基础上为 `Array` 、`Map` 、`Gui` 等提供了更多方法，令开发更加灵活方便。

因为扩展方法是直接添加到类原型上的，因此使用他们的方式与原生无异：
```go
arr := [1, 2, 3, 4, 5]

// 筛选
filtered := arr.filter(num => num > 3) // filtered : [4, 5]

// 处理元素
plusOne := arr.map(num => num + 1) // plusOne : [2, 3, 4, 5, 6]

// 求和
sum := arr.reduce((acc, cur) => acc + cur, 0) // sum : 15
```
