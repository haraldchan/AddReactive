#Include "./record/clickstep-options.ahk"
#Include "./record/keyrecord-options.ahk"

MouseSpy_Record(App, config) {
    curRecordMode := signal("clickStep")
    recordModes := Map(
        "clickStep", MouseSpy_Record_ClickStepOptions,
        "keyRecord", MouseSpy_Record_KeyRecordOptions
    )

    useRelative := signal(false)
    logMouseCoordMode := signal("Screen")
    recordedLog := signal("CoordMode(`"Mouse`", `"Screen`")")
    isKeyRecording := signal(false)

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
        ; { record options
        App.AddGroupBox("Section w350 h160", "Record Options").SetFont("s10 bold"),
        
        ; record mode
        App.AddText("xs10 yp+22 w100 h20 0x200", "Record Mode:"),
        App.AddRadio("x+10 w100 h20 Checked", "Click Step").onClick(handleRecordModeSetting),
        App.AddRadio("x+10 w100 h20", "Key Record").onClick(handleRecordModeSetting),
        
        Dynamic(
            curRecordMode, 
            recordModes, 
            { 
                App: App, 
                config: config, 
                curRecordMode: curRecordMode,
                logMouseCoordMode: logMouseCoordMode,
                useRelative: useRelative,
                recordedLog: recordedLog, 
                isKeyRecording: isKeyRecording
            }
        ),
        ; }

        ; { Click Log
        App.AddGroupBox("Section x22 y225 w350 h420", "Recorded Log").SetFont("s10 bold"),
        ; CoordMode
        App.AddText("xs10 yp+22 w100 h20 0x200", "Coord Mode:"),
        App.AddRadio("x+10 w60 h20 Checked", "Screen").onClick(handleSetLogMouseCoordMode),
        App.AddRadio("x+10 w60 h20", "Client").onClick(handleSetLogMouseCoordMode),
        App.AddCheckBox("x+10 w60 h20", "Relative").onClick((ctrl, _) => useRelative.set(ctrl.Value)),

        ; log code
        App.AREdit("xs10 yp+25 w330 r23 0x40", "{1}", recordedLog).onBlur((ctrl, _) => recordedLog.set(ctrl.Value)),
        App.AddButton("xs80 y+8 w80 h20", "Export").onClick(handleLogExport),
        App.AddButton("x+10 w80 h20", "Copy").onClick((*) => A_Clipboard := recordedLog.value),
        App.AddButton("x+10 w80 h20", "Clear").onClick(handleLogReset)
        ; }
    )
}