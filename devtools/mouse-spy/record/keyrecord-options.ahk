#Include "./key-logger.ahk"

MouseSpy_Record_KeyRecordOptions(props) {
    unpack({
        App: &App,
        config: &config,
        recordedLog: &recordedLog,
        isKeyRecording: &isKeyRecording
    }, props)

    comp := Component(App, A_ThisFunc)

    effect(isKeyRecording, handleRecordToggle)
    handleRecordToggle(recording) {
        App["key-record-toggler"].Enabled := !recording
        App["key-record-toggler"].Text := recording ? "Recording..." : "Start"
        App["recording-indicator"].Text := recording ? "Press ``Esc`` to stop." : "<- Click to record."

        if (recording) {
            KeyLogger({
                recordedLog: recordedLog, 
                isKeyRecording: isKeyRecording, 
                replaceSleep: { 
                    isReplace: App["replace-sleep"].Value, 
                    stepFiller: config["stepFillerTemplates"][App["step-filler-ddl"].Text] 
                },
                saveLog: false
            })
        }
    }

    comp.render := this => this.Add(
        App.ARButton("vkey-record-toggler xs10 y110 w80 h20", "Start").onClick((*) => isKeyRecording.set(true)),
        App.AddText("vrecording-indicator x+10 w200 h20 0x200", "<- Click to record."),
        App.AddCheckbox("vreplace-sleep xs10 y+10 w200", "Replace `"Sleep`" with Step Filler"),
    )

    return comp
}