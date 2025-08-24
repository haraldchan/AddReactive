DebuggerInfo(debugger) {
    dd := Gui("+AlwaysOnTop", debugger.value["varName"])
    dd.SetFont(,"微软雅黑")

    return (
        ; basic info
        dd.AddText("x10 w100 h20", "Info").SetFont("s10.5 Bold"),
        ; varName
        dd.AddText("x10 w100 h20", "Variable"),
        dd.AddEdit("ReadOnly w150 h20 x+10", debugger.value["varName"]),
        
        ; signal type
        dd.AddText("x10 w100 h20", "Class Type"),
        dd.AddEdit("ReadOnly w150 h20 x+10", debugger.value["class"]),
        
        ; current value
        dd.AddText("x10 w100 h20", "Current Value"),
        dd.AREdit("vDebuggerInfoDisplay ReadOnly w150 h20 x+10", "{1}", debugger.value["signal"]),
        
        ; ; subscribers
        dd.AddText("x10 w100 h20", "Listeners").SetFont("s10.5 Bold"),
        ; subbed computed
        dd.AddText("x10 w100 h20", "Computeds").SetFont("Bold"),
        ArrayExt.map(debugger.value["signal"].comps, comp => (
            dd.AddText("x10 w100 h20", "Name"),
            dd.AddEdit("ReadOnly x+10 w150 h20", comp.debugger.value["varName"])
        )),

        ; controls 
        dd.AddText("x10 w100 h20", "Controls").SetFont("Bold"),
        ArrayExt.map(
            ArrayExt.filter(debugger.value["signal"].subs, s => s.ctrl.Name !== "DebuggerInfoDisplay"), 
                ctrl => dd.AddEdit("ReadOnly w260 r4", Format("
                    (
                        Name:`t`t{1}
                        Type:`t`t{2}
                        Hwmd:`t`t{3}
                        ClassNN:`t`t{4}
                    )", ctrl.ctrl.Name, ctrl.ctrl.Type, ctrl.ctrl.Hwnd, ctrl.ctrl.ClassNN
                )
            )
        ),

        ; call stack
        dd.AddText("x10 w100 h20", "Call Stack").SetFont("s10.5 Bold"),
        debugger.value["stacks"].map(stack => dd.AddEdit("ReadOnly w260 r3", stack)),

        dd.Show()
    )
}