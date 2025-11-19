ReactiveDetails(debugger) {
    RD := Gui(, debugger["signalName"])

    valueToShow := debugger["debugger"].value["signalInstance"].value is Object
        ? JSON.stringify(debugger["debugger"].value["signalInstance"].value)
        : debugger["debugger"].value["signalInstance"].value

    return (
        RD.AddText("w200 h200", valueToShow),

        RD.Show()
    )
}