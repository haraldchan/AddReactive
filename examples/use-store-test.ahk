#SingleInstance Force
#Include "../useAddReactive.ahk"

mouseStore := useStore({
    states: {
        curMouseInfo: { Screen: { x: 0, y: 0} }
    },
    deriveds: {
        doubledX: this => this.curMouseInfo.value["Screen"]["x"] * 2,
    },
    methods: {
        handleMousePosUpdate: (this) => (
            CoordMode("Mouse", "Screen")
            MouseGetPos(&initScreenX, &initScreenY, &window, &control),
            WinGetTitle(window) == "MouseSpy" 
            ? this.curMouseInfo.value 
            : { Screen: { x: Integer(initScreenX), y: Integer(initScreenY) } }
        ),
        updater: (this) => this.curMouseInfo.set(this.useMethod("handleMousePosUpdate")()),
        greet: (this, name) => MsgBox("hi, " . name)
    }
})

oGui := Gui("+Resize", "MouseSpy")
UseStoreTest(oGui)
oGui.Show()

UseStoreTest(App) {
    SetTimer(mouseStore.useMethod("updater"), 50)

    return (
        App.AddText("x20", "X:"),
        App.AREdit("x+10 w100", "{1}", mouseStore.curMouseInfo, v => v["Screen"]["x"]),
        App.AddText("x20", "Y:"),
        App.AREdit("x+10 w100", "{1}", mouseStore.curMouseInfo, v => v["Screen"]["y"]),
        App.AddText("x20", "DoubledX:"),
        App.AREdit("x+10 w100", "{1}", mouseStore.doubledX),
        
        App.AddButton("x20 w100", "stop")
           .OnEvent("Click", (ctrl, *) => SetTimer(mouseStore.useMethod("updater"), 0)),
        App.AddButton("x+10 w100", "resume")
           .OnEvent("Click", (ctrl, *) => SetTimer(mouseStore.useMethod("updater")))
    )
}