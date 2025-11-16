#SingleInstance Force
#Include "../useAddReactive.ahk"

store := useStore("test-store", {
    states: {
        count: 0
    },
    deriveds: {
        doubled: this => this.count.value * 2,
    },
    methods: {
        showAdd: (this, formatStr) => MsgBox(Format(formatStr, this.count.value, this.doubled.value, this.count.value + this.doubled.value)),
    }
})

oGui := Gui("+Resize", "MouseSpy")
StoreTest(oGui)
oGui.Show()

StoreTest(App) {
    unpack({ 
        count:   &count,
        doubled: &doubled,
        methods: { showAdd: &showAdd }
    }, store)

    tripled := computed(count, c => c * 3, { name: "tripled" })

    return (
        App.ARText("x10 w200", "count:   {1}", count),
        App.ARText("x10 w200", "doubled: {1}", doubled),
        App.ARText("x10 w200", "tripled: {1}", tripled),
        App.AddButton("x10 w80", "++").OnClick((*) => count.set(n => n + 1)),
        App.AddButton("x10 w80", "add").OnClick((*) => showAdd("Sum: {1} + {2} = {3}"))
    )
}

DevToolsUI()