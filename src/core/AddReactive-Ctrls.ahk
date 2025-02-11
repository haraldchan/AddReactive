class AddReactiveText extends AddReactive {
    /**
     * Add a reactive Text control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveText}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Text", options, content, depend, key)
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
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal.
     * @param {array} [key] the keys or index of the signal's value.
     * @returns {AddReactiveEdit}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Edit", options, content, depend, key)
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
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveButton}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Button", options, content, depend, key)
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
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "CheckBox", options, content, depend, key)
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
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveRadio}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, [String, Number], "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "Radio", options, content, depend, key)
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

        super.__New(GuiObject, "DropDownList", options, , depend, key)
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
        super.__New(GuiObject, "ComboBox", options, , depend, key)
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
        colDiff := newColumnDetails.keys.Length - this.titleKeys.Length
        if (colDiff > 0) {
            loop colDiff {
                this.ctrl.InsertCol()
            }
        } else if (colDiff < 0) {
            loop Abs(colDiff) {
                this.ctrl.DeleteCol(this.titleKeys.Length - A_Index)
            }
        }

        this.titleKeys := newColumnDetails.keys
        this.content := newColumnDetails.HasOwnProp("titles") ? newColumnDetails.titles : this.titleKeys
        this.colWidths := newColumnDetails.HasOwnProp("widths") ? newColumnDetails.widths : this.titleKeys.map(item => "AutoHdr")

        for title in this.content {
            this.ctrl.ModifyCol(A_Index, this.colWidths[A_Index], title)
        }
    }
}
class ARListView extends AddReactiveListView {
    ; alias
}


class AddReactiveGroupBox extends AddReactive {
    /**
     * Add a reactive GroupBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, String, "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "GroupBox", options, content, depend, key)
    }
}
class ARGroupBox extends AddReactiveGroupBox {
    ; alias
}


class AddReactiveDateTime extends AddReactive {
    /**
     * Add a reactive GroupBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} content Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", content := "", depend := 0, key := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(content, String, "Parameter #2 (content) is not a String")
        checkTypeDepend(depend)

        this.key := key
        super.__New(GuiObject, "GroupBox", options, content, depend, key)
    }
}
class ARDateTime extends AddReactiveDateTime {
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
Gui.Prototype.AddReactiveGroupBox := AddReactiveGroupBox
Gui.Prototype.ARGroupBox := ARGroupBox
Gui.Prototype.AddReactiveDateTime := AddReactiveDateTime
Gui.Prototype.ARDateTime := ARDateTime