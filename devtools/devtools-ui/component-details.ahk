#Include "./debugger-info.ahk"

ComponentDetails(dtUI, selectedNodeContent) {
    signalList := computed(selectedNodeContent, n => filterReactives(n, "signal"))
    computedList := computed(selectedNodeContent, n => filterReactives(n, "computed"))
    filterReactives(nodeContent, classType) {
        return ArrayExt.map(
                   ArrayExt.filter(nodeContent["debuggers"], d => d.value["class"] == classType),
                   d => { 
                        varName: d.value["varName"], 
                        value: d.value["signal"].value is Object ? JSON.stringify(d.value["signal"].value, 0 , "") : d.value["signal"].value
                    }
               )
    }

    colDetails := {
        keys: ["varName", "value"],
        titles: ["var name", "value"],
        widths: [130, 240]
    }

    options := {
        lvOptions: "ReadOnly -LV0x10 LV0x4000 w380 r10 yp+20",
    }
    
    showDebuggerInfo(LV, row) {
        varName := LV.GetText(row)
        d := ArrayExt.find(selectedNodeContent.value["debuggers"], d => d.value["varName"] == varName)
        DebuggerInfo(d)
    }

    return (
        dtUI.ARGroupBox("Section x+10 w400 h600", "<{1}>", selectedNodeContent, ["name"])
            .SetFont("S10.5"),

        dtUI.AddText("xs10 yp+30 w180 h20", "Source File").SetFont("s9 Bold"),
        dtUI.ARText("xs10 yp+20 w380 h40", "{1}", selectedNodeContent, ["file"]),   
        
        ; signals
        dtUI.AddText("xs10 yp+40 w180 h20", "Signals").SetFont("s9 Bold"),
        dtUI.ARListView(options, colDetails, signalList)
            .OnEvent("DoubleClick", showDebuggerInfo),
        
        ; computeds
        dtUI.AddText("xs10 yp+200 w180 h20", "Computeds").SetFont("s9 Bold"),
        dtUI.ARListView(options, colDetails, computedList)
            .OnEvent("DoubleClick", showDebuggerInfo)
    )
}