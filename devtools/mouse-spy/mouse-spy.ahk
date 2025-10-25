#SingleInstance Force
#Include "../../useAddReactive.ahk"
#Include "./information.ahk"
#Include "./record.ahk"
#Include "./settings.ahk"

MouseSpyWindowTitle := "MouseSpy"
Globals := {}

MouseSpyGui := Gui("+AlwaysOnTop", MouseSpyWindowTitle)
MouseSpyGui.SetFont("s9", "Tahoma")
MouseSpyGui.OnEvent("Close", (*) => ExitApp())
MouseSpy(MouseSpyGui)
MouseSpyGui.Show()

MouseSpy(App) {
    config := JSON.parse(FileRead("./mousespy.config.json", "UTF-8"))

    followMouse := signal(true)
    anchorPos := signal({ Screen:{ x: 0, y: 0 }, Client: { x: 0, y: 0 } })
    suspendText := computed(followMouse, isFollowing => isFollowing ? "(Hold Ctrl or Shift to suspend updates)" : "(Update suspended)")

    curMouseCoordMode := "Screen"
    
    return (
        ; { follow switch
        App.AddCheckBox("vfollowStatus x10 w100 h20 Checked", "Follow Mouse")
           .OnEvent("Click", (ctrl, _) => followMouse.set(ctrl.value)),
        App.ARText("vsuspendStatus x+10 h20 w260 0x200 +Right", "{1}", suspendText),
        ; }

        ; { tabs
        Tab3 := App.AddTab3("x10 w370", ["Information", "Record", "Settings"]),

        Tab3.UseTab("Info"),
        MouseSpy_Information(App, config, MouseSpyWindowTitle, followMouse, anchorPos, suspendText, curMouseCoordMode),

        Tab3.UseTab("Record"),
        MouseSpy_Record(App, config, anchorPos),

        Tab3.UseTab("Settings"),
        MouseSpy_Settings(App, config, MouseSpyWindowTitle, followMouse, anchorPos, curMouseCoordMode),

        Tab3.UseTab(0)
        ; }
    )
}