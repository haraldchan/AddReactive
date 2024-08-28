class Component {
    __New(name) {
        checkType(name, String, "Parameter #1 is not a string")
        this.name := name
        this.ctrls := []
    }
    
    Add(controls*) {
        ctrls := []

        for control in controls {
            if (control is Array) {
                this.Add(control*)
            }

            control.groupName := "$$" . this.name
            
            if (InStr(Type(Control), "AddReactive")) {
                ctrls.Push(control.ctrl)
            } else {
                ctrls.Push(control)
            }
        }
        
        this.ctrls.Push(ctrls*)
    }

    visible(bool) {
        for ctrl in this.ctrls {
            ctrl.visible := bool
        }
    }
}