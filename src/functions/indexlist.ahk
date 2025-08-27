; An AddReactive component to loop over signal.value and render multiple control groups accordingly.
class IndexList {
    /**
     * A looping component allows render controls base on signal
     * ```
     * IndexList(() => [ 
     *     oGui.AddText("...", "staff info"), 
     *     oGui.AddEdit("...", "name: {1}"),
     *     oGui.AddEdit("...", "title: {2}")
     * ], staff, ["name", "title"])
     * ```
     * @param {Func: ()=>[...Gui.Control|...AddReactive]} renderCallback An func object returns an array of Gui.Control/AddReactive controls.
     * ```
     * () => [ oGui.AddText("...", "staff info"), ... ]
     * ```
     * @param {signal} _signal A signal with the value type of Map/Object.
     * ```
     * staff := signal([
     *   { name: "Amy", title: "Manager"},
     *   { name: "Kevin", title: "Attendant"}
     * ])
     * ```
     * @param {Array} keys An array of keys to indicate value insert order.
     * ```
     * keys := ["name", "title"]
     * ```
     * @returns {IndexList}
     */
    __New(renderCallback, _signal, keys := []) {
        checkType(renderCallback, Func, "Parameter #2 is not a function.")
        checkType(_signal, [signal, computed], "Parameter #1 is not a signal/computed.")
        checkType(keys, Array, "Parameter #2 is not an Array.")

        this.renderCallBack := renderCallback
        this.signal := _signal
        this.keys := keys
        this.ctrlGroups := []
        this.templates := []

        loop this.signal.value.Length {
            ctrlGroup := renderCallback()
            checkType(ctrlGroup, Array, "Parameter #1 must return an Array of controls.")
            this.ctrlGroups.Push(ctrlGroup)
        }

        this._saveTemplates(this.ctrlGroups[1])
        this._updateListContent(this.signal.value)

        effect(this.signal, this._updateListContent)
    }

    _saveTemplates(controlGroup) {
        for control in controlGroup {
            if (control is Array) {
                this._saveTemplates(control)
            } else {
                this.templates.Push(control.Text)
            }
        }
    }

    _updateListContent(newValue) {
        for ctrlGroup in this.ctrlGroups {
            index := A_Index
            values := this.keys.map(key => newValue[index][key])

            for ctrl in ctrlGroup {
                updatedText := ""
                if (this.keys.length = 0) {
                    updatedText := Format(this.templates[A_Index], newValue[index])
                } else {
                    updatedText := Format(this.templates[A_Index], values*)
                }
                
                if (ctrl is Gui.Control) {
                    ctrl.Text := updatedText
                }
                if (ctrl is AddReactive) {
                    ctrl.ctrl.Text := updatedText
                }
            }
        }
    }
}