; MouseSpy_Record(App, config, anchorPos) {
MouseSpy_Record(App, config) {
    curRecordMode := signal("clickStep")
    recordModes := Map(
        "clickStep", MouseSpy_Record_ClickStepOptions,
        "recording", MouseSpy_Record_RecordingOptions
    )

    logMouseCoordMode := "Screen"
    useRelative := false

    recordedLog := signal("")
    effect(store.anchorPos, handleLogUpdate)
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
            "`r`n" . config["stepFillerTemplates"][App["stepFillerDDL"].Text],
        )

        recordedLog.set(newLog)
    }

    return (
        ; { record options
        App.AddGroupBox("Section w350 h140", "Record Options").SetFont("s10 bold"),
        
        ; record mode
        App.AddText("xs10 yp+22 w100 h20 0x200", "Record Mode:"),
        App.AddRadio("x+10 w100 h20 Checked", "Click step")
           .OnEvent("Click", (*) => curRecordMode.set("clickStep")),
        App.AddRadio("x+10 w100 h20", "Recording")
           .OnEvent("Click", (*) => curRecordMode.set("recording")),
        
        Dynamic(curRecordMode, recordModes, { App: App, config: config }),
        ; }

        ; { Click Log
        App.AddGroupBox("Section w350 h420 x22 y210", "Recorded Log").SetFont("s10 bold"),
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
    
    comp := Component(App, A_ThisFunc)

    stepFillerTemplates := signal(config["stepFillerTemplates"])

    effect(stepFillerTemplates, handleStepTemplatesUpdate)
    handleStepTemplatesUpdate(curTemplates) {
        config["stepFillerTemplates"] := curTemplates
        App["stepFillerSnippet"].Value := config["stepFillerTemplates"][App["stepFillerDDL"].Text]

        FileDelete("./mousespy.config.json")
        FileAppend(JSON.stringify(config), "./mousespy.config.json", "UTF-8")
    }

    handleConfigTemplateUpdate(*) {
        App["stepFillerSnippet"].Value := config["stepFillerTemplates"][App["stepFillerDDL"].Text]
    }

    comp.render := this => this.Add(
        App.AddText("xs10 y110 w100 h20 0x200", "Step filler snippets:"),
        
        App.ARDDL("vstepFillerDDL x+10 w150 Choose1", stepFillerTemplates).onChange(handleConfigTemplateUpdate),
        
        App.ARButton("x+5 w30 h20", "+").onClick((*) => MouseSpy_Record_StepFillerEditor("add", stepFillerTemplates)),
        App.ARButton("x+5 w30 h20", "✎").onClick((*) => MouseSpy_Record_StepFillerEditor("edit", stepFillerTemplates, { name: App["stepFillerDDL"].Text, snippet: App["stepFillerSnippet"].Value})),
        
        App.AddEdit("vstepFillerSnippet xs120 yp+25 w220 R3 ReadOnly", config["stepFillerTemplates"][App["stepFillerDDL"].Text])
    )

    return comp
}


MouseSpy_Record_StepFillerEditor(mode, stepFillerTemplates, selectedTemplate := { name: "", snippet: "" }) {
    if (WinExist("Edit Snippet")) {
        return
    }

    SFE := Gui("+AlwaysOnTop", "Edit Snippet")
    SFE.SetFont("s9", "Tahoma")
    SFE.OnEvent("Close", (*) => SFE.Destroy())


    handleTemplateUpdate(ctrl, _) {
        templName := Trim(SFE["templateName"].Value)
        templSnippet := SFE["templateSnippet"].Value

        if (!templName || !Trim(SFE["templateSnippet"].Value)) {
            return
        }

        newTemplates := MapExt.deepClone(stepFillerTemplates.value)

        if (mode == "add") {
            newTemplates[templName] := templSnippet
        }

        if (mode == "edit") {
            if (!newTemplates.Has(templName)) {
                newTemplates.Delete(selectedTemplate.name)
            }

            newTemplates[templName] := templSnippet
        }

        if (ctrl.Text == "🗑") {
            confirm := Msgbox("Are you sure to delete this template?", "Edit Snippet", "YesNo 4096")
            if (confirm == "Yes") {
                newTemplates.Delete(selectedTemplate.name)
            } else {
                return
            }
        }

        ; set new templates
        stepFillerTemplates.set(newTemplates)
        SFE.Destroy()
    }


    return (
        ; template name & snippet
        SFE.AddText("x10 h20 w100 0x200", "Template Name:"),
        SFE.AddEdit("vtemplateName x+10 h20 w200", selectedTemplate.name),
        SFE.AddEdit("vtemplateSnippet x10 h400 w310", selectedTemplate.snippet),
        
        ; btns
        SFE.ARButton("x120 w80 h20", "&Save").onClick(handleTemplateUpdate),
        SFE.ARButton("x+10 w80 h20", "&Close").onClick((*) => SFE.Destroy()),
        SFE.ARButton("x+10 w20 h20 " . ((mode == "add" || stepFillerTemplates.value.Count == 1) && "Disabled") , "🗑")
           .onClick(handleTemplateUpdate),
        
        SFE.Show()
    )
}


MouseSpy_Record_RecordingOptions(props) {
    App := props.App
    config := props.config

    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddText("xs10 y110 w250 h20 0x200", "under construction..."),
    )

    return comp
}