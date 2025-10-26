#SingleInstance Force
#Include "../../useAddReactive.ahk"
#Include "./information.ahk"
#Include "./record.ahk"
#Include "./settings.ahk"

MouseSpyWindowTitle := "MouseSpy"
store := useStore({
    signals: {
        curMouseCoordMode: signal("Screen"),
        curMouseInfo: signal({
            Screen: { x: 0, y: 0 },
            Client: { x: 0, y: 0 },
            window: WinExist("ahk_exe explorer.exe"),
            control: 0,
            color: "0xFFFFFF"
        }),
        followMouse: signal(true),
        anchorPos: signal({ Screen:{ x: 0, y: 0 }, Client: { x: 0, y: 0 } })
    },
    methods: {
        updater: (this) => this.curMouseInfo.set(this.useMethod("handleMousePosUpdate")()),
        handleMousePosUpdate: (this) => (
            CoordMode("Mouse", "Screen")
            MouseGetPos(&initScreenX, &initScreenY, &window, &control)
            CoordMode("Mouse", "Client")
            MouseGetPos(&initClientX, &initClientY),
            ; return 
            WinGetTitle(window) == MouseSpyWindowTitle 
                ? this.curMouseInfo.value 
                : {
                    Screen: { x: Integer(initScreenX), y: Integer(initScreenY) },
                    Client: { x: Integer(initClientX), y: Integer(initClientY) },
                    window: window,
                    control: control,
                    color: PixelGetColor(initScreenX, initScreenY)
                }
        ),
        moveToAnchor: (this, params*) => (
            CoordMode("Mouse", this.curMouseCoordMode.value)
            MouseMove(this.anchorPos.value[A_CoordModeMouse]["x"], this.anchorPos.value[A_CoordModeMouse]["y"])
        )
    }
})

MouseSpyGui := Gui("+AlwaysOnTop", MouseSpyWindowTitle)
MouseSpyGui.SetFont("s9", "Tahoma")
MouseSpyGui.OnEvent("Close", (*) => ExitApp())
MouseSpy(MouseSpyGui)
MouseSpyGui.Show()

MouseSpy(App) {
    config := JSON.parse(FileRead("./mousespy.config.json", "UTF-8"))
    suspendText := computed(store.followMouse, isFollowing => isFollowing ? "(Hold Ctrl or Shift to suspend updates)" : "(Update suspended)")
    
    return (
        ; { follow switch
        App.AddCheckBox("vfollowStatus x10 w100 h20 Checked", "Follow Mouse")
           .OnEvent("Click", (ctrl, _) => store.followMouse.set(ctrl.value)),
        App.ARText("vsuspendStatus x+10 h20 w260 0x200 +Right", "{1}", suspendText),
        ; }

        ; { tabs
        Tab3 := App.AddTab3("x10 w370", ["Information", "Record", "Settings"]),

        Tab3.UseTab("Info"),
        MouseSpy_Information(App, config, MouseSpyWindowTitle, suspendText),

        Tab3.UseTab("Record"),
        MouseSpy_Record(App, config),

        Tab3.UseTab("Settings"),
        MouseSpy_Settings(App, config, MouseSpyWindowTitle),

        Tab3.UseTab(0)
        ; }
    )
}