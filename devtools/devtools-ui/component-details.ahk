#Include "./debugger-info.ahk"

ComponentDetails(dtUI, selectedNodeContent) {
    signalList := computed(selectedNodeContent, n => filterReactives(n, "signal"))
    computedList := computed(selectedNodeContent, n => filterReactives(n, "computed"))
    filterReactives(nodeContent, signalType) {
        return pipe(
            debuggers => ArrayExt.filter(debuggers, d => d.value["signalType"] == signalType),
            filtered => ArrayExt.map(filtered, d => {
                signalName: d.value["signalName"],
                value: d.value["signalInstance"].value is Object ? JSON.stringify(d.value["signalInstance"].value, 0, "") : d.value["signalInstance"].value
            })
        )(nodeContent["debuggers"])
    }

    colDetails := {
        keys: ["signalName", "value"],
        titles: ["Signal Name", "Value"],
        widths: [130, 240]
    }

    options := {
        lvOptions: "ReadOnly -LV0x10 LV0x4000 w380 r10 yp+20",
    }
    
    showDebuggerInfo(LV, row) {
        signalName := LV.GetText(row)
        d := ArrayExt.find(selectedNodeContent.value["debuggers"], d => d.value["signalName"] == signalName)
        DebuggerInfo(d)
    }

    return (
        ; component name
        dtUI.ARGroupBox("Section x+10 w400 h600", "<{1}>", selectedNodeContent, ["name"])
            .SetFont("S10.5"),

        ; source file
        dtUI.AddText("xs10 yp+30 w180 h20", "Source File").SetFont("s9 Bold"),
        dtUI.ARText("xs10 yp+20 w380 h40", "{1}", selectedNodeContent, ["file"]),   
        
        ; signals
        dtUI.AddText("xs10 yp+40 w180 h20", "Signals").SetFont("s9 Bold"),
        dtUI.ARListView(options, colDetails, signalList)
            .onDoubleClick(showDebuggerInfo),
        
        ; computeds
        dtUI.AddText("xs10 yp+200 w180 h20", "Computeds").SetFont("s9 Bold"),
        dtUI.ARListView(options, colDetails, computedList)
            .onDoubleClick(showDebuggerInfo)
    )
}