DebuggerInfo(debugger) {
    dd := Gui(, debugger.value["varName"])
    dd.SetFont(,"微软雅黑")
    
    displaySignalValue := computed(debugger.value["signal"], ds => ds is Object ? JSON.stringify(ds, 0, "") : ds)
    listenersGroupBoxHeight := (50 * (debugger.value["signal"].comps.Length - 1)) + (50 * (debugger.value["signal"].subs.Length - 1))
    listenersGroupBoxHeight := listenersGroupBoxHeight > 0 ? listenersGroupBoxHeight + 60 : 0
    callStackGroupBoxHeight := 85 * debugger.value["stacks"].Length

    return (
        ; basic info
        dd.AddGroupBox("Section x10 w300 h120", " Info ").SetFont("s10.5 Bold"),
        ; varName
        dd.AddText("xs10 yp+30 w100 h20", "Var Name"),
        dd.AddEdit("ReadOnly w150 h20 x+10", debugger.value["varName"]),
        
        ; signal type
        dd.AddText("xs10 yp+30 w100 h20", "Class Type"),
        dd.AddEdit("ReadOnly w150 h20 x+10", debugger.value["class"]),
        
        ; current value
        dd.AddText("xs10 yp+30 w100 h20", "Current Value"),
        dd.AREdit("vDebuggerInfoDisplay ReadOnly w150 h20 x+10", "{1}", displaySignalValue),
        
        ; ; subscribers
        ; dd.AddText("x10 w100 h20", "Listeners").SetFont("s10.5 Bold"),
        dd.AddGroupBox("Section x10 w300 h" . listenersGroupBoxHeight , " Listeners ").SetFont("s10.5 Bold"),
        ; subbed computed
        debugger.value["signal"].comps.Length > 1 && dd.AddText("xs10 yp+30 w100 h20", "Computeds").SetFont("Bold"),
        ArrayExt.map(debugger.value["signal"].comps, comp => comp.debugger && (
            dd.AddText("xs10 yp+30 w100 h20", "Var Name"),
            dd.AddEdit("ReadOnly x+10 w150 h20", comp.debugger.value["varName"])
        )),

        ; controls 
        debugger.value["signal"].subs.Length > 1 && dd.AddText("xs10 yp+30 w100 h20", "Controls").SetFont("Bold"),
        ArrayExt.map(
            ArrayExt.filter(debugger.value["signal"].subs, s => s.ctrl.Name !== "DebuggerInfoDisplay"), 
                ctrl => dd.AddEdit("ReadOnly yp+50 w260 r4", Format("
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
        dd.AddGroupBox("Section x10 w300 h" . callStackGroupBoxHeight, " Call Stack ").SetFont("s10.5 Bold"),
        ArrayExt.map(debugger.value["stacks"], stack => dd.AddEdit("ReadOnly xs10 w260 r3 " . (A_Index == 1 ? "yp+30" : "yp+70") , stack)),

        dd.Show()
    )
}