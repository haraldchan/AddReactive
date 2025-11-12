#Include "./key-logger.ahk"

MouseSpy_Record_KeyRecordOptions(props) {
    App := props.App
    config := props.config
    recordedLog := props.recordedLog
    isKeyRecording := props.isKeyRecording

    comp := Component(App, A_ThisFunc)

    effect(isKeyRecording, handleRecordToggle)
    handleRecordToggle(recording) {
        App["key-record-toggler"].Enabled := !recording
        App["key-record-toggler"].Text := recording ? "Recording..." : "Start"
        App["recording-indicator"].Text := recording ? "Press ``Esc`` to stop." : ""
        
        if (recording) {
            KeyLogger(recordedLog, isKeyRecording, false)
        }
    }

    comp.render := this => this.Add(
        App.ARButton("vkey-record-toggler xs10 y110 w80 h20", "Start").onClick((*) => isKeyRecording.set(true)),
        App.AddText("vrecording-indicator x+10 w200 h20 0x200", "")
    )

    return comp
}