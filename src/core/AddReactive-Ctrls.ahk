class AddReactiveText extends AddReactive {
    /**
     * Add a reactive Text control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveText}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Text", options, innerText, depend, key)
    }
}
class ARText extends AddReactiveText {
    ; alias
}

class AddReactiveEdit extends AddReactive {
    /**
     * Add a reactive Edit control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal.
     * @param {array} [key] the keys or index of the signal's value.
     * @returns {AddReactiveEdit}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Edit", options, innerText, depend, key)
    }
}
class AREdit extends AddReactiveEdit {
    ; alias
}

class AddReactiveButton extends AddReactive {
    /**
     * Add a reactive Button control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveButton}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Button", options, innerText, depend, key)
    }
}
class ARButton extends AddReactiveButton {
    ; alias
}

class AddReactiveCheckBox extends AddReactive {
    /**
     * Add a reactive CheckBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "CheckBox", options, innerText, depend, key)
    }
}
class ARCheckBox extends AddReactiveCheckBox {
    ; alias
}

class AddReactiveRadio extends AddReactive {
    /**
     * Add a reactive Radio control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveRadio}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Radio", options, innerText, depend, key)
    }
}
class ARRadio extends AddReactiveRadio {
    ; alias
}

class AddReactiveDropDownList extends AddReactive {
    __New(GuiObject, options, depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkTypeDepend(depend)
        this.key := key

        super.__New(GuiObject, "DropDownList", options,, depend, key)
    }
}
class ARDropDownList extends AddReactiveDropDownList {
    ; alias
}
class ARDDL extends AddReactiveDropDownList {
    ; alias
}

class AddReactiveComboBox extends AddReactive {
    __New(GuiObject, options, depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "ComboBox", options,, depend, key)
    }
}
class ARComboBox extends AddReactiveComboBox {
    ; alias
}

class AddReactiveListView extends AddReactive {
    /**
     * Add a reactive ListView control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param { {keys: string[], titles: string[], width: number[]} } columnDetails Descriptor object contains keys of col value, column title texts and column width.
     * @param {signal} depend Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveListView}     
     */
    __New(GuiObject, options, columnDetails, depend := 0, key := 0) {
        ; options type checking
        checkType(options, Object.Prototype, "Parameter #1 (options) is not an Object")
        checkType(options.lvOptions, String, "options.lvOptions is not a string")
        if (options.HasOwnProp("itemOptions")) {
            checkType(options.itemOptions, String, "options.itemOptions is not a string")
        }
        ; colTitleGrid type checking
        checkType(columnDetails, Object.Prototype, "Parameter #2 is (columnDetails) is not an Object")
        checkType(columnDetails.keys, Array, "columnDetails.keys is not an Array")
        if (columnDetails.HasOwnProp("titles")) {
            checkType(columnDetails.titles, Array, "columnDetails.titles is not an Array")
        }
        if (columnDetails.HasOwnProp("widths")) {
            checkType(columnDetails.widths, Array, "columnDetails.widths is not an Array")
        }
        ; depend type checking
        checkTypeDepend(depend)
        checkType(depend.value, Array, "Depend value of AddReactive ListView is not an Array")

        this.key := key
        super.__New(GuiObject, "ListView", options, columnDetails, depend, key)
    }

    setColumndDetails(newColumnDetails, columnOptions := "") {
        this.titleKeys := newColumnDetails.keys
        this.innerText := newColumnDetails.HasOwnProp("titles") ? newColumnDetails.titles : this.titleKeys
        this.colWidths := newColumnDetails.HasOwnProp("widths") ? newColumnDetails.widths : this.titleKeys.map(item => "AutoHdr")

        for title in this.innerText {
            this.ctrl.ModifyCol(A_Index, columnOptions, title)
        }
    }
}
class ARListView extends AddReactiveListView {
    ; alias
}

; mount to Gui.Prototype
Gui.Prototype.AddReactiveText := AddReactiveText
Gui.Prototype.ARText := ARText
Gui.Prototype.AddReactiveEdit := AddReactiveEdit
Gui.Prototype.AREdit := AREdit
Gui.Prototype.AddReactiveButton := AddReactiveButton
Gui.Prototype.ARButton := ARButton
Gui.Prototype.AddReactiveCheckBox := AddReactiveCheckBox
Gui.Prototype.ARCheckBox := ARCheckBox
Gui.Prototype.AddReactiveRadio := AddReactiveRadio
Gui.Prototype.ARRadio := ARRadio
Gui.Prototype.AddReactiveComboBox := AddReactiveComboBox
Gui.Prototype.ARComboBox := ARComboBox
Gui.Prototype.AddReactiveDropDownList := AddReactiveDropDownList
Gui.Prototype.ARDropDownList := ARDropDownList
Gui.Prototype.ARDDL := ARDDL
Gui.Prototype.AddReactiveListView := AddReactiveListView
Gui.Prototype.ARListView := ARListView