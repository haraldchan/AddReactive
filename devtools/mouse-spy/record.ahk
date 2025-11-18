#Include "./record/clickstep-options.ahk"
#Include "./record/keyrecord-options.ahk"

MouseSpy_Record(App, config) {
    curRecordMode := signal("clickStep", { name: "clickStep" })
    recordModes := Map(
        "clickStep", MouseSpy_Record_ClickStepOptions,
        "keyRecord", MouseSpy_Record_KeyRecordOptions
    )

    useRelative := signal(false, { name:"useRelative" })
    logMouseCoordMode := signal("Screen", { name: "logMouseCoordMode" })
    recordedLog := signal("CoordMode(`"Mouse`", `"Screen`")", { name: "recordedLog" })
    isKeyRecording := signal(false, { name: "isKeyRecording" })

    handleRecordModeSetting(ctrl, _) {
        if (ctrl.Text == "Click Step") {
            curRecordMode.set("clickStep")
            isKeyRecording.set(false)
        } else {
            curRecordMode.set("keyRecord")
        }
    }

    handleSetLogMouseCoordMode(ctrl, _){
        logMouseCoordMode.set(ctrl.Text)

        recordedLog.set(recordedLog.value . "`r`n" . Format("CoordMode(`"Mouse`", `"{}`")", logMouseCoordMode.value))
    }

    handleLogReset(*) {
        recordedLog.set(Format("CoordMode(`"Mouse`", `"{}`")", logMouseCoordMode.value))
    }

    handleLogExport(*) {
        WinSetAlwaysOnTop(false, MouseSpyWindowTitle)

        savename := FileSelect("S8", "new-recorded.ahk", "MouseSpy - Export Log", "AutoHotkey (*.ahk)")
        if (!savename) {
            return
        }

        if (FileExist(savename)) {
            FileDelete(savename)
        }
        
        FileAppend(recordedLog.Value, savename, "UTF-8")
        WinSetAlwaysOnTop(true, MouseSpyWindowTitle)
    }

    return (
        StackBox(App,
            {
                name: "record-options",
                fontOptions: "s10 bold",
                groupbox: {
                    title: "Record Options",
                    options: "Section w345 h175"
                }
            },
            () => [                
                ; record mode
                App.AddText("xs10 yp+22 w100 h20 0x200", "Record Mode:"),
                App.AddRadio("x+10 w100 h20 Checked", "Click Step").onClick(handleRecordModeSetting),
                App.AddRadio("x+10 w100 h20", "Key Record").onClick(handleRecordModeSetting),
                
                Dynamic(App,
                    curRecordMode, 
                    recordModes, 
                    { 
                        config: config, 
                        curRecordMode: curRecordMode,
                        logMouseCoordMode: logMouseCoordMode,
                        useRelative: useRelative,
                        recordedLog: recordedLog, 
                        isKeyRecording: isKeyRecording
                    }
                ),
            ]
        ),

        StackBox(App,
            {
                name: "record-log",
                fontOptions: "s10 bold",
                groupbox: {
                    title: "Record Log",
                    options: "Section x22 y+5 w345 h420"
                }
            },
            () => [
                ; CoordMode
                App.AddText("xs10 yp+22 w100 h20 0x200", "Coord Mode:"),
                App.AddRadio("x+10 w60 h20 Checked", "Screen").onClick(handleSetLogMouseCoordMode),
                App.AddRadio("x+10 w60 h20", "Client").onClick(handleSetLogMouseCoordMode),
                App.AddCheckBox("x+10 w60 h20", "Relative").onClick((ctrl, _) => useRelative.set(ctrl.Value)),

                ; log code
                App.AREdit("xs10 yp+25 w325 r23 0x40", "{1}", recordedLog).onBlur((ctrl, _) => recordedLog.set(ctrl.Value)),
                App.AddButton("xs80 y+8 w80 h20", "Export").onClick(handleLogExport),
                App.AddButton("x+10 w80 h20", "Copy").onClick((*) => A_Clipboard := recordedLog.value),
                App.AddButton("x+10 w80 h20", "Clear").onClick(handleLogReset)
            ]
        )
    )
}