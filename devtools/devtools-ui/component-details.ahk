#Include "./debugger-info.ahk"

ComponentDetails(dtUI, selectedNodeContent) {
    signalList := computed(selectedNodeContent, n => filterReactives(n, "signal"))
    computedList := computed(selectedNodeContent, n => filterReactives(n, "computed"))
    filterReactives(nodeContent, classType) {
        return ArrayExt.map(
                   ArrayExt.filter(nodeContent["debuggers"], d => d.value["class"] == classType),
                   d => { varName: d.value["varName"], value: d.value["signal"].value }
               )
    }

    colDetails := {
        keys: ["varName", "value"],
        titles: ["var name", "value"],
        widths: [130, 240]
    }

    options := {
        lvOptions: "ReadOnly -LV0x10 LV0x4000 w380 yp+20",
    }
    
    showDebuggerInfo(LV, row) {
        varName := LV.GetText(row)
        d := ArrayExt.find(selectedNodeContent.value["debuggers"], d => d.value["varName"] == varName)
        DebuggerInfo(d)
    }

    return (
        dtUI.ARGroupBox("Section x+10 w400 h500", "<{1}>", selectedNodeContent, ["name"])
            .SetFont("S10.5"),
        
        ; component call stack
        dtUI.ARText("xs10 yp+25 w180 h20", "Call file").SetFont("s9 Bold"),
        dtui.AddEdit("xs10 yp+20 w380 h50 ReadOnly", selectedNodeContent.value["file"]),
        
        ; signals
        dtUI.AddText("xs10 yp+60 w180 h20", "Signals").SetFont("s9 Bold"),
        dtUI.ARListView(options, colDetails, signalList)
            .OnEvent("DoubleClick", showDebuggerInfo),
        
        ; computeds
        dtUI.AddText("xs10 yp+120 w180 h20", "Computeds").SetFont("s9 Bold"),
        dtUI.ARListView(options, colDetails, computedList)
            .OnEvent("DoubleClick", showDebuggerInfo)
    )
}