#SingleInstance Force
#Include "../useAddReactive.ahk"

store := useStore({
    states: {
        count: 0
    },
    deriveds: {
        doubled: this => this.count.value * 2,
    },
    methods: {
        showAdd: this => MsgBox(this.count.value + this.doubled.value)
    }
})

oGui := Gui("+Resize", "MouseSpy")
UseStoreTest(oGui)
oGui.Show()

UseStoreTest(App) {

    return (
        App.ARText("x10 w200", "count:   {1}", store.count),
        App.ARText("x10 w200", "doubled: {1}", store.doubled),
        App.AddButton("x10 w80", "++").OnClick((*) => store.count.set(n => n + 1)),
        App.AddButton("x10 w80", "add").OnClick((*) => store.useMethod("showAdd")())
    )
}