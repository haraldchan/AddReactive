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