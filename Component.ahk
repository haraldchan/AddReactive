class Component {
    /**
     * Create a component instance.
     * @param {String} name The unique name of the component
     */
    __New(GuiObj, name, props := {}) {
        checkType(name, String, "Parameter #1 is not a string")
        this.name := name
        this.props := props
        this.ctrls := []

        GuiObj.components.Push(this)
    }

    /**
     * Specify native or AddReactive controls to in component
     * @param {...Gui.Control|...AddReactive} controls 
     * @returns {Component}
     */
    Add(controls*) {
        for item in controls {
            if (item is Array) {
                for c in item {
                    checkType(item, Gui.Control, "Parameter is not Gui.Control or Array of Gui.Control")
                }
            } else {
                checkType(item, Gui.Control, "Parameter is not Gui.Control or Array of Gui.Control")
            }
        }

        ctrls := []

        for control in controls {
            if (control is Array) {
                this.Add(control*)
            }

            if (InStr(Type(Control), "AddReactive")) {
                control.ctrl.groupName := "$$" . this.name
                ctrls.Push(control.ctrl)
            } else {
                control.groupName := "$$" . this.name
                ctrls.Push(control)
            }
        }
        this.ctrls.Push(ctrls*)

        return this
    }

    /**
     * Define additional props
     * @param {Object} props props Object
     */
    defineProps(props) {
        for name, val in props.OwnProps() {
            this.DefineProp(name, {Value: val})
        }
    }

    /**
     * Sets the visibility state of the component
     * @param {boolean} isShow 
     */
    visible(isShow) {
        for ctrl in this.ctrls {
            ctrl.visible := isShow
        }
    }

    /**
     * Collects the values from named controls of the component and composes them into an Object.
     * @returns {Object} 
     */
    submit() {
        formData := {}

        for ctrl in this.ctrls {
            if (ctrl.name != "") {
                formData.DefineProp(ctrl.name, { Value: ctrl.Value })
            }
        }

        return formData
    }
}

Gui.Prototype.Component := Component
Gui.Prototype.components := []