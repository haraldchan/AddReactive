class Component {
    __New(name) {
        checkType(name, String, "Parameter #1 is not a signal")
        this.name := name
        this.arcs := []
        this.ctrls := []
    }
    
    Add(controls*) {
        ctrls := []

        for control in controls {
            control.groupName := "$$" . this.name
            
            if (InStr(Type(Control), "AddReactive")) {
                ctrls.Push(control.ctrl)
            } else {
                ctrls.Push(control)
            }
        }

        this.ctrls := ctrls
    }

    visible(bool) {
        for ctrl in this.ctrls {
            ctrl.visible := bool
        }
    }
}