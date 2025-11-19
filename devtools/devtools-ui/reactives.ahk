#Include "./reactive-details.ahk"

Reactives(App) {
    lvOptions := {
        lvOptions: "xs10 yp+20 w350 r10 LV0x4000 Grid NoSortHdr"
    }

    columnDetails := {
        keys: ["signalName", "caller", "value"],
        titles: ["Signal Name", "Component", "Value"],
        widths: [120, 100, 100]
    }

    signals := computed(DebuggerList.debuggers, cur => ArrayExt.filter(cur, item => item["signalType"] == "signal"))
    computeds := computed(DebuggerList.debuggers, cur => ArrayExt.filter(cur, item => item["signalType"] == "computed"))
    
    handleShowSignalDetails(LV, row, signalList) {
        if (row == 0 || row > 10000) {
            return
        }

        ReactiveDetails(signalList[row])
    }

    onMount() {

    }

    return (
        StackBox(App,
            {
                name: "signals",
                fontOptions: "bold",
                groupbox: {
                    title: "Signals / States",
                    options: "Section x20 y30 w380 r11"
                }
            },
            () => [
                App.ARListView(lvOptions, columnDetails, signals)
                   .onDoubleClick((LV, row) => handleShowSignalDetails(LV, row, signals.value))
            ]
        ),

        StackBox(App,
            {
                name: "computeds",
                fontOptions: "bold",
                groupbox: {
                    title: "Computeds / Deriveds",
                    options: "Section x20 y+5 w380 r11"
                }
            },
            () => [
                App.ARListView(lvOptions, columnDetails, computeds)
                   .onDoubleClick((LV, row) => handleShowSignalDetails(LV, row, computeds.value))
            ]
        ),
        
        onMount()
    )
}