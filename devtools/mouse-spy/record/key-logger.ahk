KeyLogger(props) {
    unpack({
        recordedLog: &recordedLog,
        isKeyRecording: &isKeyRecording,
        replaceSleep: &replaceSleep,
        saveLog: &saveLog
    }, props)

    ih := InputHook("V")
    ih.KeyOpt("{All}", "N")
    ih.KeyOpt("{Esc}", "E")
    ih.Modifiers := ["LControl", "RControl", "LShift", "RShift", "LAlt", "RAlt"]
    
    ; custom properties
    ih.curLine := ""
    ih.strokeRecord := { key: "", state: "" }
    ih.ticker := 0
    ih.saveLog := saveLog
    ih.recordedLog := recordedLog
    ih.isKeyRecording := isKeyRecording

    ih.OnKeyDown := logKey.Bind(,,,"Down", replaceSleep)
    ih.OnKeyUp := logKey.Bind(,,,"Up", replaceSleep)
    ih.OnEnd := (ih) => ih.isKeyRecording.set(false)

    ih.Start()
    ih.Wait()
}

logKey(ih, vk, sc, state, replaceSleep) {
    keyName := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
    elapsed := ih.ticker ? A_TickCount - ih.ticker : 0 
    isModifier := ih.Modifiers.find(m => keyName == m)

    scriptLine := Format(
        "{3}Send `"{{1}{2}}`"", 
        keyName, 
        isModifier ? (" " . state) : "",
        ; elapsed ? "Sleep " . elapsed . "`r`n" : ""
        match(replaceSleep.isReplace, Map(
            replace => replace == true,      replaceSleep.stepFiller . "`r`n",
            replace => !replace && elapsed,  "Sleep " . elapsed . "`r`n",
            replace => !replace && !elapsed, ""
        ))
    )

    ; prevent recording same key on keep pushing down.
    if (ih.strokeRecord.key == keyName) {
        if (ih.strokeRecord.state == "Down" && state == "Up") {
            scriptLine := ""
        } 
        else if (ih.strokeRecord.state == state) {
            return
        }
    }

    strokeRecord := { 
        key: keyName, 
        state: state, 
        elapsed: elapsed , 
        script: scriptLine 
    }

    logLine := Format("key: {1}; up/down: {2}; script: {3} `r`n", keyName, state, StrReplace(scriptLine, "`r`n", ", "))
    ih.curLine := logLine
    ih.strokeRecord := strokeRecord
    ih.ticker := A_TickCount
    
    if (scriptLine) {
        ih.recordedLog.set(ih.recordedLog.value . "`r`n" . scriptLine)
    }

    if (ih.saveLog) {
        FileAppend(logLine, "./keylog.txt", "utf-8")
    }
}