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
    __New(GuiObj, name) {
        checkType(name, String, "Parameter #1 is not a string")
        this.GuiObj := GuiObj
        this.name := name
        this.ctrls := []
        this.childComponents := []
        this.isDisabled := false
        this.isVisible := true

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
                if (Control is AddReactive) {
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

                ; nested component
                if (control is Component) {
                    this.childComponents.Push(control)
                }
            }
        }

        ctrls := []
        saveControls(ctrls, controls)
        this.ctrls.Push(ctrls*)

        return this
    }

    /**
     * Sets the visibility state of the component.
     * @param {Integer|Func} isShow a true/false value or a computation function to change visibility of the component.
     */
    visible(isShow) {
        this.isVisible := isShow is Func ? isShow(this.isVisible) : isShow

        for ctrl in this.ctrls {
            ctrl.visible := this.isVisible 
        }

        this._handleChildComponentVisible(this.isVisible , this.childComponents)
    }

    _handleChildComponentVisible(state, childComponents) {
        if (childComponents.Length == 0) {
            return
        }

        for component in childComponents {
            component.visible(state)
            if (component.childComponents.Length > 0) {
                this._handleChildComponentVisible(state, component.childComponents)
            }
        }
    }

    /**
     * Collects the values from named controls of the component and composes them into an Object.
     * @returns {Object} 
     */
    submit(hide := false) {
        if (hide == true) {
            this.GuiObj.hide()
        }

        formData := {}

        for ctrl in this.ctrls {
            if (ctrl.name != "") {
                formData.DefineProp(ctrl.name, { Value: ctrl.Value })
            }
        }

        this._handleChildComponentSubmit(formData, this.childComponents)

        return formData
    }

    _handleChildComponentSubmit(dataObj, childComponents) {
        if (childComponents.Length == 0) {
            return
        }

        for component in childComponents {
            componentFormData := component.submit()
            if (component.childComponents.Length > 0) {
                this._handleChildComponentSubmit(componentFormData, component.childComponents)
            }
            dataObj.DefineProp(component.name, { Value: componentFormData })
        }
    }

    /**
     * Sets the enabled state of the component.
     * @param {Integer|Func} disabled a true/false value or a computation function to change enabled of the component.
     */
    disable(disabled) {
        this.isDisabled := disabled is Func ? disabled(this.isDisabled) : disabled

        for ctrl in this.ctrls {
            ctrl.Enabled := !this.isDisabled
        }

        this._handleChildComponentDisable(this.isDisabled, this.childComponents)
    }

    _handleChildComponentDisable(state, childComponents) {
        if (childComponents.Length == 0) {
            return
        }

        for component in childComponents {
            component.disable(state)
            if (component.childComponents.Length > 0) {
                this._handleChildComponentDisable(state, component.childComponents)
            }
        }
    }
}

Gui.Prototype.components := []