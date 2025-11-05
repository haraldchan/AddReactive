class Show {
    __New(renderCallBack, _signal, conditionFn) {
        this.renderCallBack := renderCallBack
        this._signal := _signal
        this.conditionFn := conditionFn
        this.ctrls := []

        effect(this._signal, cur => this.toggleShowHide(conditionFn(cur)))

        ; mount & save controls
        ctrls := renderCallBack()
        this.saveCtrls(this.ctrls, ctrls is Array ? ctrls : [ctrls])
        this.toggleShowHide(conditionFn(this._signal.value))
    }

    saveCtrls(savedCtrls, renderedCtrls) {
        for control in renderedCtrls {
            ; native control 
            if (control is Gui.Control) {
                savedCtrls.Push(control)
            }

            ; AddReactive control
            if (control is AddReactive) {
                savedCtrls.Push(control.ctrl)
            }

            ; Array
            if (control is Array) {
                this.saveCtrls(savedCtrls, control)
            }

            ; IndexList
            if (control is IndexList) {
                for listControl in control.ctrlGroups {
                    this.saveCtrls(savedCtrls, listControl)
                }
            }

            ; nested component
            if (control is Component) {
                this.ctrls.Push(control.ctrls*)
                if (control.childComponents.Length > 0) {
                    this.saveCtrls(savedCtrls, control.childComponents)
                }
            }
        }
    }

    toggleShowHide(condition) {
        for ctrl in this.ctrls {
            ctrl.Visible := condition
        }
    }
}