# Computed

Computed 是追踪 signal 的值变化的计算属性。与 `signal` `不同，computed` 是 **只读** 的。
<br>
<br>

### 创建 computed

Computed 可以通过 `computed()` 函数进行创建。它接收两个参数，分别是订阅对象 `signal` 以及一个描述如何改变值的函数：

```go
count := signal(2)

doubled := computed(count, c => c * 2) // doubled.value : 4
```
<br>

### 订阅多个 signal 的 computed

`computed` 可以同时订阅多个 `signal` ：

```go
first := signal(1)
second := signal(10)
third := signal(20)

// 当订阅多个 signal 时，可以数组形式传入第一参数。描述改变值的函数的参数分别为各个订阅 signal 的值
sum := computed([first, second, third], (f, s, r) => f + s + r) // sum.value : 31
```
<br>