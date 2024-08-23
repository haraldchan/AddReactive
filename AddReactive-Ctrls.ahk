class AddReactiveText extends AddReactive {
    /**
     * Add a reactive Text control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} [event] Events and callback function objects.
     * @returns {AddReactiveText}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        this.key := key
        super.__New(GuiObject, "Text", options, innerText, depend, key, event)
    }
}

class AddReactiveEdit extends AddReactive {
    /**
     * Add a reactive Edit control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} [event] Events and callback function objects.
     * @returns {AddReactiveEdit}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        this.key := key
        super.__New(GuiObject, "Edit", options, innerText, depend, key, event)
    }
}

class AddReactiveButton extends AddReactive {
    /**
     * Add a reactive Button control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} [event] Events and callback function objects.
     * @returns {AddReactiveButton}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        this.key := key
        super.__New(GuiObject, "Button", options, innerText, depend, key, event)
    }
}

class AddReactiveCheckBox extends AddReactive {
    /**
     * Add a reactive CheckBox control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} [event] Events and callback function objects.
     * @returns {AddReactiveCheckBox}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        this.key := key
        super.__New(GuiObject, "CheckBox", options, innerText, depend, key, event)
    }
}

class AddReactiveRadio extends AddReactive {
    /**
     * Add a reactive Radio control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} [depend] Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} [event] Events and callback function objects.
     * @returns {AddReactiveRadio}     
     */
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(innerText, [String, Number], "Parameter #2 (innerText) is not a String")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        this.key := key
        super.__New(GuiObject, "Radio", options, innerText, depend, key, event)
    }
}

class AddReactiveDropDownList extends AddReactive {
    __New(GuiObject, options, mapObj, depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(mapObj, Map, "Parameter #2 (Map Object) is not a Map")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        ; mapObj: a Map(value, optionText) map object
        this.key := key
        this.mapObj := mapObj
        this.vals := []
        this.text := []
        for val, text in this.mapObj {
            this.vals.Push(val)
            this.text.Push(text)
        }
        super.__New(GuiObject, "DropDownList", options, this.text, depend, key, event)
    }

    ; overiding the getValue() of ReactiveControl. Returning the value of mapObj instead.
    getValue() {
        return this.vals[this.ctrl.Value]
    }
}

class AddReactiveComboBox extends AddReactive {
    __New(GuiObject, options, mapObj, depend := 0, key := 0, event := 0) {
        checkType(options, String, "Parameter #1 (options) is not a String")
        checkType(mapObj, Map, "Parameter #2 (Map Object) is not a Map")
        checkTypeDepend(depend)
        checkType(event, event = 0 ? Number : Map, "Parameter 'Event' is not a Map")

        ; mapObj: a Map(value, optionText) map object
        this.key := key
        this.mapObj := mapObj
        this.vals := []
        this.text := []
        for val, text in this.mapObj {
            this.vals.Push(val)
            this.text.Push(text)
        }
        super.__New(GuiObject, "ComboBox", options, this.text, depend, key, event)
    }

    getValue() {
        return this.vals[this.ctrl.Value]
    }
}

class AddReactiveListView extends AddReactive {
    /**
     * Add a reactive ListView control to Gui
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {{keys: string[], titles: string[], width: number[]}} columnDetails Descriptor object contains keys of col value, column title texts and column width.
     * @param {signal} depend Subscribed signal
     * @param {array} [key] the keys or index of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} [event] Events and callback function objects.
     * @returns {AddReactiveListView}     
     */
    __New(GuiObject, options, columnDetails, depend := 0, key := 0, event := 0) {
        ; options type checking
        checkType(options, Object, "Parameter #1 (options) is not an Object")
        checkType(options.lvOptions, String, "options.lvOptions is not a string")
        if (options.HasOwnProp("itemOptions")) {
            checkType(options.itemOptions, String, "options.itemOptions is not a string")
        }
        ; colTitleGrid type checking
        checkType(columnDetails, Object, "Parameter #2 is (columnDetails) is not an Object")
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
        super.__New(GuiObject, "ListView", options, columnDetails, depend, key, event)
    }
}

class IndexList {
    /**
     * Creates a list of multiple reactive controls, ordered by index.
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} controlType Control type to create. Available: Text, Edit, CheckBox, Radio.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} depend Subscribed signal
     * @param {[ event: Event, callback: ()=>void ]} event Events and callback function objects.
     * @return {Gui.Control[]}
     */
    __New(guiObj, controlType, options, innerText, depend := 0, key := 0, event := 0) {
        loop depend.value.length {
            guiObj.AddReactive(controlType, options, innerText, depend, A_Index, event)
        }
    }
}

class KeyList {
    /**
     * Creates a list of multiple reactive controls, render each item by keys.
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} controlType Control type to create. Available: Text, Edit, CheckBox, Radio.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string} innerText Text or formatted text to hold signal values.
     * @param {signal} depend Subscribed signal
     * @param {array} key the keys of the signal's value
     * @param {[ event: Event, callback: ()=>void ]} event Events and callback function objects.
     * @return {Gui.Control[]}
     */
    __New(guiObj, controlType, options, innerText, depend := 0, key := 0, event := 0) {
        loop depend.value.length {
            guiObj.AddReactive(controlType, options, innerText, depend, [[A_Index], key*], event)
        }
    }
}

; mount to Gui.Prototype
Gui.Prototype.AddReactiveText := AddReactiveText
Gui.Prototype.AddReactiveEdit := AddReactiveEdit
Gui.Prototype.AddReactiveButton := AddReactiveButton
Gui.Prototype.AddReactiveCheckBox := AddReactiveCheckBox
Gui.Prototype.AddReactiveRadio := AddReactiveRadio
Gui.Prototype.AddReactiveComboBox := AddReactiveComboBox
Gui.Prototype.AddReactiveDropDownList := AddReactiveDropDownList
Gui.Prototype.AddReactiveListView := AddReactiveListView
Gui.Prototype.IndexList := IndexList
Gui.Prototype.KeyList := KeyList