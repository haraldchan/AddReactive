class StackBox {
    /**
     * Creates a StackBox component for containing child controls.
     * @param {Gui} guiObj The GUI object to which the StackBox belongs
     * @param {Object} options The options for the StackBox
     * ```
     * StackBox(gui, options, () => [...])
     * 
     * options := {
     *     ; available options
     *     name: "stack-box",
     *     fontOptions: "s12 bold",
     *     fontName: "Times New Roman",
     *          
     *     ; GroupBox options
     *     groupbox: { 
     *         title: "This is a StackBox",
     *         options: "Section w250 r9",
     *     },
     * 
     *     ; (optional) Use a CheckBox as title
     *     checkbox: {
     *         title: "StackBox with CheckBox title",
     *         options: "Checked w250"
     *     }, 
     * }
     * ```
     * @param {()=>Array<Gui.Control|AddReactive>} renderCallback The callback function to render the StackBox's content
     * ```
     * StackBox(gui, options, renderCallback)
     * 
     * renderCallback := () => [
     *     gui.AddText(...),
     *     gui.AddEdit(...)
     *     ; ...
     * ]
     * ```
     */
    __New(guiObj, options, renderCallback) {
        this.gui := guiObj
        this.name := options.HasOwnProp("name") ? "$" . options.name : ""
        if (this.name) {
            this.gui.components.Push(this)
        }

        this.fontName := options.HasOwnProp("fontName") ? options.fontName : ""
        this.fontOptions := options.HasOwnProp("fontOptions") ? options.fontOptions : ""
        this.renderCallback := (*) => renderCallback()
        this.ctrls := []

        ; GroupBox option
        this.gbOption := options.groupbox.options
        this.gbTitle := options.groupbox.HasOwnProp("title") && !options.HasOwnProp("checkbox") ? options.groupbox.title : ""
        ; CheckBox option
        this.checkbox := options.HasOwnProp("checkbox") ? options.checkbox : ""
        if (this.checkbox) {
            this.checkbox.options := this.checkbox.HasOwnProp("options") ? this.checkbox.options . " xs10 yp" : " xs10 yp"
        }

        ; mount controls
        this._renderStackBox(this.gui)
    }

    _saveCtrls(savedCtrls, renderedCtrls) {
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
                this._saveCtrls(savedCtrls, control)
            }

            ; IndexList
            if (control is IndexList) {
                for listControl in control.ctrlGroups {
                    this._saveCtrls(savedCtrls, listControl)
                }
            }

            ; nested component
            if (control is Component) {
                this.ctrls.Push(control.ctrls*)
                if (control.childComponents.Length > 0) {
                    this._saveCtrls(savedCtrls, control.childComponents)
                }
            }

            ; Dynamic
            if (control is Dynamic) {
                this._saveCtrls(savedCtrls, control.components)
            }
        }
    }

    setEnable(isEnabled) {
        for control in this.ctrls {
            if (A_Index < 3) {
                continue
            }
            control.Enabled := isEnabled
        }

        if (this.HasOwnProp("cbCtrl")) {
            this.cbCtrl.Value := isEnabled
        }
    }

    _renderStackBox(App) {
        ; mount GroupBox
        this.gbCtrl := App.AddGroupBox(this.gbOption, this.gbTitle)
        this.gbCtrl.SetFont(this.fontOptions, this.fontName)
        this.ctrls.Push(this.gbCtrl)
        this.gbCtrl.GetPos(&gbX, &gbY, &gbWidth, &gbHeight)

        ; mount CheckBox if using check box as title
        if (this.checkbox) {
            this.cbCtrl := App.AddCheckbox(this.checkbox.options, this.checkbox.title)
            this.cbCtrl.SetFont(this.fontOptions, this.fontName)
            this.cbCtrl.OnEvent("Click", (ctrl, _) => this.setEnable(ctrl.Value))
            this.ctrls.Push(this.cbCtrl)
        }

        ; mount controls
        this._saveCtrls(this.ctrls, this.renderCallback())

        ; set enable
        if (this.checkbox) {
            this.setEnable(this.cbCtrl.Value)
        }

        ; bottom
        bottom := App.AddText(Format("xs10 h20 {1} {2}", gbWidth, "y" . (gbY + gbHeight - 20)))
        bottom.Visible := false
        this.ctrls.InsertAt(this.checkbox ? 3 : 2, bottom)
    }
}

Gui.Prototype.AddStackBox := StackBox