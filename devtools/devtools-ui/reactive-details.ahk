; TODO:
/**
 * Pt. Dynamic Control for different type of value
 *  - String|Number: Edit
 *  
 *  - Object|Map|Array<String|Number>: 2-col ListView for key/val or index/val
 *  
 *  - Array<Object|Map>: multi-col ListView
 * 
 * Pt. Hence, needs a type validating func, perhaps Struct.New is useful.
 */

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