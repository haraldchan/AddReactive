MouseSpy_Record(App, config, anchorPos) {
    curRecordMode := signal("clickStep")
    recordModes := Map(
        "clickStep", MouseSpy_Record_ClickStepOptions,
        "recording", MouseSpy_Record_RecordingOptions
    )

    logMouseCoordMode := "Screen"
    useRelative := false

    recordedLog := signal("")
    effect(anchorPos, handleLogUpdate)
    handleLogUpdate(curAnchorPos, prevAnchorPos) {
        if (useRelative) {
            x := curAnchorPos[logMouseCoordMode]["x"] - prevAnchorPos[logMouseCoordMode]["x"]
            y := curAnchorPos[logMouseCoordMode]["y"] - prevAnchorPos[logMouseCoordMode]["y"]

            xCoord := "x" . (x < 0 ? " - " . Abs(x) : " + " . x)
            yCoord := "y" . (y < 0 ? " - " . Abs(y) : " + " . y)
        } else {
            xCoord := curAnchorPos[logMouseCoordMode]["x"]
            yCoord := curAnchorPos[logMouseCoordMode]["y"]
        }

        newLog := Format(
            "{1}MouseMove {2}, {3}{4}",
            recordedLog.value ? recordedLog.value . "`r`n" : "",
            xCoord,
            yCoord,
            "`r`n" . config["stepFiller"],
        )

        recordedLog.set(newLog)
    }

    return (
        ; { record options
        App.AddGroupBox("Section w350 h120", "Record Options").SetFont("s10 bold"),
        
        ; record mode
        App.AddText("xs10 yp+22 w100 h20 0x200", "Record Mode:"),
        App.AddRadio("x+10 w100 h20 Checked", "Click step")
           .OnEvent("Click", (*) => curRecordMode.set("clickStep")),
        App.AddRadio("x+10 w100 h20", "Recording")
           .OnEvent("Click", (*) => curRecordMode.set("recording")),
        
        Dynamic(curRecordMode, recordModes, { App: App, config: config }),
        ; }

        ; { Click Log
        App.AddGroupBox("Section w350 h420 x22 y190", "Recorded Log").SetFont("s10 bold"),
        App.AddText("xs10 yp+22 w100 h20 0x200", "Coord Mode:"),
        App.AddRadio("x+10 w60 h20 Checked", "Screen")
           .OnEvent("Click", (*) => logMouseCoordMode := "Screen"),
        App.AddRadio("x+10 w60 h20", "Client")
           .OnEvent("Click", (*) => logMouseCoordMode := "Client"),
        App.AddCheckBox("x+10 w60 h20", "Relative")
           .OnEvent("Click", (ctrl, _) => useRelative := ctrl.Value),
        App.AREdit("xs10 yp+25 w330 r23 0x40", "{1}", recordedLog)
           .OnEvent("LoseFocus", (ctrl, _) => recordedLog.set(ctrl.Value)),
        App.AddButton("xs260 y+10 w80 h20", "Clear")
           .OnEvent("Click", (ctrl, _) => recordedLog.set(""))
        ; }
    )
}

MouseSpy_Record_ClickStepOptions(props) {
    App := props.App
    config := props.config
    ; stepFiller := config["stepFiller"]
    stepFillerTemplates := signal(config["stepFillerTemplates"])

    comp := Component(App, A_ThisFunc)
    
    handleConfigUpdate() {
        FileDelete("./mousespy.config.json")
        FileAppend(JSON.stringify(config), "./mousespy.config.json", "UTF-8")
    }

    handleStepFillerUpdate(ctrl, _) {
        config["stepFiller"] := ctrl.Value
        handleConfigUpdate()
    }

    comp.render := this => this.Add(
        App.AddText("xs10 y110 w100 h20 0x200", "Step filler:"),
        App.ARDDL("x+10 w220", stepFillerTemplates)
        ; App.AREdit("x+10 w220 R3", stepFiller).OnEvent("LoseFocus", handleStepFillerUpdate)
    )

    return comp
}

MouseSpy_Record_RecordingOptions(props) {
    App := props.App
    config := props.config
    stepFiller := config["stepFiller"]

    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddText("xs10 y110 w250 h20 0x200", "under construction..."),
    )

    return comp
}