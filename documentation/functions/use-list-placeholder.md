# useListPlaceholder

`useListPlaceholder()` 可以在使用 `signal` 和 `AddReactiveListView` 数据未返回、没有数据或错误等情况是作为临时填充或提示。
<br>
<br>

### 提供填充

`useListPlaceholder()` 接收 `signal` 和 `columnDetails.keys`（即需要填充到 ListView 控件中列的键），以及需要临时填充字符串：

```go
oGui := Gui(, "Placeholder")

listContent := signal([])

options := {...}
columnsDetails := {
    keys: ["room", "name", "gender"],
    ...
}

handleListContentUpdate(){
    // 在获取列表数据前使用，将在列表上显示 "Loading..."
    useListPlaceholder(listContent, columnDetails, "Loading...")

    data := fetchData()

    if (data.Length = 0) {
        // 如果返回数组没有数据，显示 "No Data"
        useListPlaceholder(listContent, columnDetails, "No Data")
    } else {
        // 正常返回数据后，将会更新到 ListView 上
        listContent.set(data)
    }
}

oGui.AddReactiveListView(options, columnDetails, listContent)
```

<br>

### `columnDetails` 数据类型

在使用 `AddReactiveListView` 控件时，一般如上述例子一样使用 `columnsDetails` 对象来对列和数据格式进行配置。`useListPlaceholder` 除了可以接收像 `columnDetails` 这样包含 `keys` 属性的对象使用，也可以直接在第二参数传入包含键的数组：

```go
columnKeys := ["room", "name", "gender"]

// 使用键数组
useListPlaceholder(listContent, columnKeys, "Loading...")
```
