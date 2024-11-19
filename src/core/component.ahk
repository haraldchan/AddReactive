class Component {
    /**
     * Create a component instance.
     * ```
     * comp := Component(guiObj, "componentName")
     * 
     * Comp(guiObj) {
     *   c := Component(guiObj, A_ThisFunc)
     *   ; ...
     *   return c
     * }
     * ```
     * @param {String} name The unique name of the component
     * @param {Object} props 
     */
    __New(GuiObj, name, props := {}) {
        checkType(name, String, "Parameter #1 is not a string")
        this.name := name
        this.props := {}
        this.defineProps(props)
        this.ctrls := []

        GuiObj.components.Push(this)
    }

    /**
     * Specify native or AddReactive controls to in component
     * @param {...Gui.Control|...AddReactive} controls 
     * @returns {Component}
     */
    Add(controls*) {
        saveControls(ctrlsArray, controls) {
            for control in controls {
                ; native control
                if (control is Gui.Control) {
                    control.groupName := "$$" . this.name
                    ctrlsArray.Push(control)
                }

                ; AddReactive control
                if (control is AddReactive) {
                    control.ctrl.groupName := "$$" . this.name
                    ctrlsArray.Push(control.ctrl)
                }

                ; Array
                if (control is Array) {
                    saveControls(ctrlsArray, control)
                }

                ; IndexList
                if (control is IndexList) {
                    for listControl in control.ctrlGroups {
                        saveControls(ctrlsArray, listControl)
                    }
                }
            }
        }

        ctrls := []
        saveControls(ctrls, controls)
        this.ctrls.Push(ctrls*)

        return this
    }

    /**
     * Define additional props
     * @param {Object} props props Object
     */
    defineProps(props) {
        checkType(props, Object.Prototype)
        for name, val in props.OwnProps() {
            this.props.DefineProp(name, { Value: val })
        }
    }

    /**
     * Sets the visibility state of the component
     * @param {boolean} isShow 
     */
    visible(isShow) {
        state := isShow is Func
            ? isShow()
            : isShow
        for ctrl in this.ctrls {
            ctrl.visible := state
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

Gui.Prototype.components := []
