MouseSpy_Record_ClickStepOptions(props) {
    unpack({
        App: &App, 
        config: &config, 
        curRecordMode: &curRecordMode,
        logMouseCoordMode: &logMouseCoordMode,
        useRelative: &useRelative,
        recordedLog: &recordedLog, 
        isKeyRecording: &isKeyRecording
    }, props)
    
    comp := Component(App, A_ThisFunc)

    stepFillerTemplates := signal(config["stepFillerTemplates"], { name: "stepFillerTemplates" })

    effect(stepFillerTemplates, handleStepTemplatesUpdate)
    handleStepTemplatesUpdate(curTemplates) {
        config["stepFillerTemplates"] := curTemplates
        App["step-filler-snippet"].Value := config["stepFillerTemplates"][App["step-filler-ddl"].Text]

        FileDelete("./mousespy.config.json")
        FileAppend(JSON.stringify(config), "./mousespy.config.json", "UTF-8")
    }

    handleConfigTemplateUpdate(*) {
        App["step-filler-snippet"].Value := config["stepFillerTemplates"][App["step-filler-ddl"].Text]
    }

    effect(mouseStore.anchorPos, handleLogUpdateClickStep)
    handleLogUpdateClickStep(curAnchorPos, prevAnchorPos) {
        if (curRecordMode.value != "clickStep") {
            return
        }

        curMode := logMouseCoordMode.value

        if (useRelative.value) {
            x := curAnchorPos[curMode]["x"] - prevAnchorPos[curMode]["x"]
            y := curAnchorPos[curMode]["y"] - prevAnchorPos[curMode]["y"]

            xCoord := "x" . (x < 0 ? " - " . Abs(x) : " + " . x)
            yCoord := "y" . (y < 0 ? " - " . Abs(y) : " + " . y)
        } else {
            xCoord := curAnchorPos[curMode]["x"]
            yCoord := curAnchorPos[curMode]["y"]
        }

        newLog := Format(
            "{1}MouseMove {2}, {3}{4}{5}",
            recordedLog.value ? recordedLog.value . "`r`n" : "",
            xCoord,
            yCoord,
            "`r`n" . App["click-action-ddl"].Text,
            "`r`n" . config["stepFillerTemplates"][App["step-filler-ddl"].Text],
        )

        recordedLog.set(newLog)
    }

    comp.render := this => this.Add(
        App.AddText("xs10 y110 w100 h20 0x200", "Click action:"),        
        App.AddDDL("vclick-action-ddl x+10 w150 Choose1", ["Click", "Click 2", "Click `"Right`""]),
        
        App.AddText("xs10 y135 w100 h20 0x200", "Step filler snippets:"),
        
        App.ARDDL("vstep-filler-ddl x+10 w150 Choose1", stepFillerTemplates).onChange(handleConfigTemplateUpdate),
        
        App.ARButton("x+5 w30 h20", "+").onClick((*) => MouseSpy_Record_StepFillerEditor("add", stepFillerTemplates)),
        App.ARButton("x+5 w30 h20", "✎").onClick((*) => MouseSpy_Record_StepFillerEditor("edit", stepFillerTemplates, { name: App["step-filler-ddl"].Text, snippet: App["step-filler-snippet"].Value})),
        
        App.AddEdit("vstep-filler-snippet xs120 yp+25 w220 R3 ReadOnly", config["stepFillerTemplates"][App["step-filler-ddl"].Text])
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
        templName := Trim(SFE["template-name"].Value)
        templSnippet := SFE["template-snippet"].Value

        if (!templName || !Trim(SFE["template-snippet"].Value)) {
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
        SFE.AddEdit("vtemplate-name x+10 h20 w200", selectedTemplate.name),
        SFE.AddEdit("vtemplate-snippet x10 h400 w310", selectedTemplate.snippet),
        
        ; btns
        SFE.ARButton("x120 w80 h20", "&Save").onClick(handleTemplateUpdate),
        SFE.ARButton("x+10 w80 h20", "&Close").onClick((*) => SFE.Destroy()),
        SFE.ARButton("x+10 w20 h20 " . ((mode == "add" || stepFillerTemplates.value.Count == 1) && "Disabled") , "🗑")
           .onClick(handleTemplateUpdate),
        
        SFE.Show()
    )
}