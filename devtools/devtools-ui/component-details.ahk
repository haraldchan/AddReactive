#Include "./debugger-info.ahk"

ComponentDetails(dtUI, selectedNodeContent) {
    showDebuggerInfo(debugger) => DebuggerInfo(debugger)

    return (
        dtUI.ARGroupBox("Section w200 h300", "<{1}>", selectedNodeContent, v => v["name"])
            .SetFont("S10.5"),
        
        ; file
        dtUI.AddText("xs w180 h20", "Script file path").SetFont("s10"),
        dtui.AddEdit("xs w180 h40 ReadOnly", selectedNodeContent.value["file"]),

        ; signals
        dtUI.AddText("xs w180 h20", "Signals").SetFont("s10"),
        selectedNodeContent.value.debuggers.map(debugger => 
            StrLower(debugger.value.class) == "signal" && 
            dtUI.ARText("xs w180 h400", "{1} : {2}", debugger, ["varName", "value"])
                .OnEvent("Click", (*) => showDebuggerInfo(debugger))
        ),

        ; computeds
        dtUI.AddText("xs w180 h20", "Computeds").SetFont("s10"),
        selectedNodeContent.value.debuggers.map(debugger => 
            StrLower(debugger.value.class) == "computed" && 
            dtUI.ARText("xs w180 h400", "{1} : {2}", ["varName", "value"])
                .OnEvent("Click", (*) => showDebuggerInfo(debugger))
        )
    )
}