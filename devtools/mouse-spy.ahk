#SingleInstance Force
#Include "../useAddReactive.ahk"

AppWindowTitle := "MouseSpy"
MouseSpyGui := Gui("+AlwaysOnTop", AppWindowTitle)
MouseSpyGui.SetFont("s9")
MouseSpyGui.OnEvent("Close", (*) => ExitApp())

MouseSpy(MouseSpyGui)
MouseSpyGui.Show()


MouseSpy(App) {
    followMouse := signal(true)
    suspendText := computed(followMouse, isFollowing => isFollowing ? "(Hold Ctrl or Shift to suspend updates)" : "(Update suspended)")
    effect(followMouse, isFollowing => 
        SetTimer(updater, isFollowing ? 150 : 0)
        App["followStatus"].Value := isFollowing
    )

    curMouseInfo := signal(updateMousePos())
    SetTimer(updater() => curMouseInfo.set(updateMousePos(followMouse.value)), 150)
    updateMousePos(isFollowing := true) {
        CoordMode "Pixel", "Screen"
        CoordMode "Mouse", "Screen"
        MouseGetPos(&initScreenX, &initScreenY, &window, &control)
        CoordMode "Mouse", "Client"
        MouseGetPos(&initClientX, &initClientY)

        return WinGetTitle(window) == AppWindowTitle 
            ? curMouseInfo.value 
            : {
                Screen: { x: Integer(initScreenX), y: Integer(initScreenY) },
                Client: { x: Integer(initClientX), y: Integer(initClientY) },
                window: window,
                control: control,
                color: PixelGetColor(initScreenX, initScreenY)
            }
    }

    effect(curMouseInfo, cur => App["colorIndicator"].SetFont(Format("s13 c{1}", StrReplace(cur["color"], "0x", ""))))
    
    curWindowInfo := computed(curMouseInfo, updateWindowInfo)
    updateWindowInfo(curMouseInfo) {
        w := curMouseInfo["window"]

        return {
            winTitle: WinGetTitle(w),
            ahkClass: WinGetClass(w),
            ahkExe:   WinGetProcessName(w),
            ahkPid:   WinGetPID(w),
            ahkId:    w
        }
    }


    anchorPos := signal({ Screen: { x: 0, y: 0 }, Client: { x: 0, y: 0 } })
    distance := computed(
        [curMouseInfo, anchorPos], 
        (curMP, curAP) => (
            x := curMP["Screen"]["x"] - curAP["Screen"]["x"],
            y := curMP["Screen"]["y"] - curAP["Screen"]["y"],
            { 
                x: x < 0 ? " - " . Abs(x) : " + " . x, 
                y: y < 0 ? " - " . Abs(y) : " + " . y
            }
        )

    )

    selectImage(*) {
        imageExts := ["jpg", "jpeg", "gif", "png", "tiff", "bmp", "ico"]
        App.Opt("+OwnDialogs")
        selected := FileSelect("3")
        StrLower(SplitPath(selected,,,&selectedExt))
        if (!selected || !ArrayExt.find(imageExts, ext => ext == selectedExt)) {
            MsgBox("Please choose a image file.")
            return
        }
        App["imageAnchorFilepath"].Value := selected
    }

    curCoordMode := "Screen"
    moveToAnchor(*) {
        CoordMode "Mouse", curCoordMode
        MouseMove anchorPos.value[A_CoordModeMouse]["x"], anchorPos.value[A_CoordModeMouse]["y"]
    }


    onMount() {
        CoordMode("Mouse", "Screen")

        HotIfWinExist(AppWindowTitle)
        Hotkey "~*Ctrl", (*) => followMouse.set(false)
        Hotkey "~*Ctrl up", (*) => followMouse.set(true)
        Hotkey "~*Shift", (*) => followMouse.set(false)
        Hotkey "~*Shift up", (*) => followMouse.set(true)
        Hotkey "!m", (*) => moveToAnchor()
        
        HotIf((*) => WinExist(AppWindowTitle) && App["useMousePosAnchor"].Value)
        Hotkey "^s", (*) => anchorPos.set(updateMousePos())
    }

    style := {
        labelText: "xs10 yp+25 w60 h20 0x200",
        editLong: "x+10 w250 h20 ReadOnly",
    }


    return (
        ; { follow switch
        App.AddCheckBox("vfollowStatus x10 w100 h20 Checked", "Follow Mouse")
           .OnEvent("Click", (ctrl, _) => followMouse.set(ctrl.value)),
        App.ARText("vsuspendStatus x+10 h20 w240 0x200 +Right", "{1}", suspendText),
        ; }

        ; { window info 
        App.AddGroupBox("Section x10 w350 h160", "Window Info").SetFont("s10 bold"),
        App.AddText(style.labelText, "Win Title:"),
        App.AREdit(style.editLong,   "{1}", curWindowInfo, ["winTitle"]),
        App.AddText(style.labelText, "Win Class:"),
        App.AREdit(style.editLong,   "ahk_class {1}", curWindowInfo, ["ahkClass"]),
        App.AddText(style.labelText, "Win Exe:"),
        App.AREdit(style.editLong,   "ahk_exe {1}", curWindowInfo, ["ahkExe"]),
        App.AddText(style.labelText, "Win PID:"),
        App.AREdit(style.editLong,   "ahk_pid {1}", curWindowInfo, ["ahkPid"]),
        App.AddText(style.labelText, "Win ID:"),
        App.AREdit(style.editLong,   "ahk_id {1}", curWindowInfo, ["ahkId"]),
        ; }

        ; { current Mouse Pos
        App.AddGroupBox("Section x10 w350 h110", "Mouse Position").SetFont("s10 bold"),
        
        ; Screen
        App.AddText("xs10 yp+25 w60 h20 0x200", "Screen:"),
        App.AREdit(style.editLong, "{1}, {2}", curMouseInfo, [v => v["Screen"]["x"], v => v["Screen"]["y"]]),
        
        ; Client
        App.AddText("xs10 yp+25 w60 h20 0x200", "Client:"),
        App.AREdit(style.editLong, "{1}, {2}", curMouseInfo, [v => v["Client"]["x"], v => v["Client"]["y"]]),
        
        ; color
        App.AddText("xs10 yp+25 w50 h20 0x200", "Color: "),
        App.AddText("vcolorIndicator x+0 w20 h20 0x200", "■"),
        App.AREdit(style.editLong . " x+0", "{1}", curMouseInfo, ["color"]),
        ; }

        ; { anchoring & distance
        App.AddGroupBox("Section x10 w350 h250", "Anchoring / Distance").SetFont("s10 bold"),
        
        ; anchors
        App.AddText(style.labelText, "Screen:"), 
        App.AREdit("x+10 w80 ReadOnly", "{1}, {2}", anchorPos, [v => v["Screen"]["x"], v => v["Screen"]["y"]]),
        App.AddText("x+30 w50 h20 0x200", "Client:"), 
        App.AREdit("x+10 w80 ReadOnly", "{1}, {2}", anchorPos, [v => v["Client"]["x"], v => v["Client"]["y"]]),

        ; relative distance
        App.AddText(style.labelText . " yp+30", "Distance:"),
        App.AREdit(style.editLong, "x {1}, y {2}", distance, ["x", "y"]),

        ; anchor types
        App.AddText("xs10 yp+35 w150 h20 0x200", "Anchor Type").SetFont("s9 bold"),
        ; mouse pos anchor
        App.AddRadio("vuseMousePosAnchor xs10 yp+30 w180 h20 Checked", "Use mouse position")
           .OnEvent("Click", (*) => App["useImageAnchor"].Value := false),
        ; image anchor
        App.AddRadio("vuseImageAnchor xs10 yp+25 w80 h20", "Use image")
           .OnEvent("Click", (*) => App["useMousePosAnchor"].Value := false),
        App.AddEdit("vimageAnchorFilepath x+10 h20 w150", ""),
        App.AddButton("x+10 h20 w80", "Choose File").OnEvent("Click", selectImage),

        
        ; move to anchor
        App.AddText("xs10 yp+35 w150 h20 0x200", "Move to anchor").SetFont("s9 bold"),
        App.AddText("xs10 yp+25 w80 h20 0x200", "Coord Mode:"),
        App.AddRadio("x+10 w80 h20 Checked", "Screen").OnEvent("Click", (ctrl, _) => curCoordMode := ctrl.Text),
        App.AddRadio("x+0 w80 h20", "Client").OnEvent("Click", (ctrl, _) => curCoordMode := ctrl.Text),
        App.AddButton("x+0 h20 w80", "&Move").OnEvent("Click", moveToAnchor),
        ; }


        onMount()
    )
}