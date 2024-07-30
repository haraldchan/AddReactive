# AddReactive ListView 控件

AddReactive ListView 控件在面对列表数据需要频繁刷新时相当有用，它可以随订阅的 `signal` 动态地更新列表中的内容，因此在使用它时，我们可以将注意力重点放在如何更新数据而不用费心处理 ListView 本身的更新。
<br>

```go
// 控件选项
options := {...}

// 列配置与数据格式
columnDetails := {...}

// 数据来源
listContent := signal([...])

oGui.AddReactiveListView(options, columnDetails, listContent)
```
<br>

## 配置 AddReactive ListView 控件

### 控件选项

由于 ListView 控件的可选选项繁多，AddReactive ListView 控件接收对象作为参数对 ListView 进行设置。对象中固定使用 `lvOptions` 和 `itemOptions` 属性，对应 ListView 控件以及 `.Add()` 方法中针对每行项目的选项。其中 `itemOptions` 是可选项。

```go
options := {
    lvOptions: "Grid -ReadOnly -Multi LV0x4000 w550 r15",
    itemOptions: "Check" 
}
```

<br>

### 列配置与数据格式

在列的标题、宽度和呈现数据，固定使用一个包含`keys`、`titles` 和 `widths`属性的对象进行配置。其中 `widths` 为可选，如不传入，则设置为自动列宽。

`keys` 中的项目应与订阅 `singal` 中值的键相对应，`titles` 则对应其在 ListView 中的列标题。

```go
columnDetails := {
    keys: ["name", "gender", "idNum", "addr"],
    titles: ["姓名", "性别", "证件号码", "地址"],
    widths: [90, 40, 145, 120]
}
```
