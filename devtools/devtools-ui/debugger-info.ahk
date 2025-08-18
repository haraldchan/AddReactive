DebuggerInfo(debugger) {
    dd := Gui("+AlawaysOnTop", debugger.value["varName"])
    dd.SetFont("微软雅黑")

    return (
        ; basic info
        dd.AddText("w100 h20", "Info").SetFont("s10.5 Bold"),
        ; varName
        dd.AddText("w100 h20", "Variable"),
        dd.AddEdit("ReadOnly w80 h20 x+10", debugger.value["varName"]),
        
        ; signal type
        dd.AddText("w100 h20", "Class Type"),
        dd.AddEdit("ReadOnly w80 h20 x+10", debugger.value["class"]),
        
        ; current value
        dd.AddText("w100 h20", "Current Value"),
        dd.AddEdit("ReadOnly w80 h20 x+10", "{1}", debugger, ["value"]),
        
        ; subscribers
        dd.AddText("w100 h20", "Listeners").SetFont("s10.5 Bold"),
        ; subbed computed
        dd.AddText("w100 h20", "Computeds"),
        debugger.signal.comps.map(comp => (
            dd.AddText("w100 h20", "Name"),
            dd.AddText("ReadOnly w80 h20", comp.debugger.value["varName"]),
        )),

        ; controls 
        dd.AddText("w100 h20", "Controls"),
        debugger.signal.subs.map(ctrl => dd.AddEdit("w100 r3", Format("
            (
                Name:    {1}
                Type:    {2}
                Hwmd:    {3}
                ClassNN: {4}
            )", (ctrl.Name, ctrl.Type, ctrl.Hwnd, ctrl.ClassNN)
        ))),

        ; call stack
        dd.AddText("w100 h20", "Call Stack").SetFont("s10.5 Bold"),
        debugger.value["stacks"].map(stack => dd.AddEdit("w150 h40", stack)),

        dd.Show()
    )
}