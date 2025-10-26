MouseSpy_Information(App, config, AppWindowTitle, suspendText) {
    effect(store.followMouse, isFollowing => 
        SetTimer(store.useMethod("updater"), isFollowing ? 150 : 0)
        App["followStatus"].Value := isFollowing
    )

    SetTimer(store.useMethod("updater"), 150)
    effect(store.curMouseInfo, cur => App["colorIndicator"].SetFont(Format("s13 c{1}", StrReplace(cur["color"], "0x", ""))))
    
    curWindowInfo := computed(store.curMouseInfo, updateWindowInfoUpdate)
    updateWindowInfoUpdate(curMouseInfo) {
        w := curMouseInfo["window"]
        try {
            ahkExe := WinGetProcessName(w)
        } catch {
            ahkExe := ""
        }

        return {
            winTitle: WinGetTitle(w),
            ahkClass: WinGetClass(w),
            ahkExe:   ahkExe,
            ahkPid:   WinGetPID(w),
            ahkId:    w
        }
    }

    distance := computed( 
        [store.curMouseInfo, store.anchorPos], 
        (curMP, curAP) => (
            x := curMP["Screen"]["x"] - curAP["Screen"]["x"],
            y := curMP["Screen"]["y"] - curAP["Screen"]["y"],
            { 
                x: x < 0 ? " - " . Abs(x) : " + " . x, 
                y: y < 0 ? " - " . Abs(y) : " + " . y
            }
        )
    )

    handleAnchorTypeToggling(ctrl, _) {
        isUsingMousePosAnchor := InStr(ctrl.Text, "mouse") ? true : false

        App["useMousePosAnchor"].Value := isUsingMousePosAnchor
        App["useImageAnchor"].Value := !isUsingMousePosAnchor

        App["imageAnchorFilepath"].Enabled := !isUsingMousePosAnchor
        App["chooseImageAnchorBtn"].Enabled := !isUsingMousePosAnchor
    }


    handleSelectImageAnchor(*) {
        imageExts := ["jpg", "jpeg", "gif", "png", "tiff", "bmp", "ico"]
        
        App.Opt("+OwnDialogs")
        selectedFile := FileSelect("3")
        SplitPath(selectedFile,,,&selectedExt)
        
        if (!selectedFile || !ArrayExt.find(imageExts, ext => ext == StrLower(selectedExt))) {
            MsgBox("Please choose a image file.")
            return
        }
        App["imageAnchorFilepath"].Value := selectedFile

        CoordMode "Pixel", "Screen"
        foundScreen := ImageSearch(&foundXScreen, &foundYScreen, 0, 0, A_ScreenWidth, A_ScreenHeight , selectedFile)
        CoordMode "Pixel", "Client"
        ImageSearch(&foundXClient, &foundYClient, 0, 0, A_ScreenWidth, A_ScreenHeight, selectedFile)
        if (!foundScreen) {
            MsgBox("Image not found.", AppWindowTitle, "T1")
            store.anchorPos.set({ Screen: { x: 0, y: 0 }, Client: { x: 0, y: 0 } })
            return
        }

        store.anchorPos.set({ 
            Screen: { x: foundXScreen, y: foundYScreen }, 
            Client: { x: foundXClient, y: foundYClient } 
        })
    }

    style := {
        labelText: "xs10 yp+25 w60 h20 0x200",
        editLong: "x+10 w250 h20 ReadOnly",
    }

    return (
        ; { window info 
        App.AddGroupBox("Section w350 h160", "Window Info").SetFont("s10 bold"),
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
        App.AddGroupBox("Section x22 yp+40 w350 h110", "Mouse Position").SetFont("s10 bold"),
        
        ; Screen
        App.AddText("xs10 yp+25 w60 h20 0x200", "Screen:"),
        App.AREdit(style.editLong, "{1}, {2}", store.curMouseInfo, [v => v["Screen"]["x"], v => v["Screen"]["y"]]),
        
        ; Client
        App.AddText("xs10 yp+25 w60 h20 0x200", "Client:"),
        App.AREdit(style.editLong, "{1}, {2}", store.curMouseInfo, [v => v["Client"]["x"], v => v["Client"]["y"]]),
        
        ; color
        App.AddText("xs10 yp+25 w50 h20 0x200", "Color: "),
        App.AddText("vcolorIndicator x+0 w20 h20 0x200", "■"),
        App.AREdit(style.editLong . " x+0 ", "{1}", store.curMouseInfo, ["color"]),
        ; }

        ; { anchoring & distance
        App.AddGroupBox("Section x22 yp+40 w350 h250", "Anchoring / Distance").SetFont("s10 bold"),
        
        ; anchors
        App.AddText(style.labelText, "Screen:"), 
        App.AREdit("x+10 w80 ReadOnly", "{1}, {2}", store.anchorPos, [v => v["Screen"]["x"], v => v["Screen"]["y"]]),
        App.AddText("x+30 w50 h20 0x200", "Client:"), 
        App.AREdit("x+10 w80 ReadOnly", "{1}, {2}", store.anchorPos, [v => v["Client"]["x"], v => v["Client"]["y"]]),

        ; relative distance
        App.AddText(style.labelText . " yp+30", "Distance:"),
        App.AREdit(style.editLong, "x {1}, y {2}", distance, ["x", "y"]),

        ; anchor types
        App.AddText("xs10 yp+35 w150 h20 0x200", "Anchor Type").SetFont("s9 bold"),
        ; mouse pos anchor
        App.AddRadio("vuseMousePosAnchor xs10 yp+30 w180 h20 Checked", "Use mouse position")
           .OnEvent("Click", handleAnchorTypeToggling),
        ; image anchor
        App.AddRadio("vuseImageAnchor xs10 yp+25 w80 h20", "Use image")
           .OnEvent("Click", handleAnchorTypeToggling),
        App.AddEdit("vimageAnchorFilepath x+10 h20 w150 Disabled", ""),
        App.AddButton("vchooseImageAnchorBtn x+10 h20 w80 Disabled", "Choose File").OnEvent("Click", handleSelectImageAnchor),

        
        ; move to anchor
        App.AddText("xs10 yp+35 w150 h20 0x200", "Move to anchor").SetFont("s9 bold"),
        App.AddText("xs10 yp+25 w80 h20 0x200", "Coord Mode:"),
        App.AddRadio("x+10 w80 h20 Checked", "Screen").OnEvent("Click", (ctrl, _) => store.curMouseCoordMode.set(ctrl.Text)),
        App.AddRadio("x+0 w80 h20", "Client").OnEvent("Click", (ctrl, _) => store.curMouseCoordMode.set(ctrl.Text)),
        App.AddButton("x+0 h20 w80", "Move").OnEvent("Click", store.useMethod("moveToAnchor"))
        ; }

    )
}