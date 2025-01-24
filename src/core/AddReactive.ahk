class AddReactive {
    /**
     * Creates a new reactive control and add it to the window.
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} controlType Control type to create. Available: Text, Edit, CheckBox, Radio, DropDownList, ComboBox, ListView.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string|Array|Object} content Text or formatted text for text, options for DDL/ComboBox, column option object for ListView.
     * @param {signal|Array|Object} depend Subscribed signal, or an array of signals. 
     * @param {string|number} key A key or index as render indicator.
     * @returns {AddReactive} 
     */
    __New(GuiObject, controlType, options := "", content := "", depend := 0, key := 0) {
        this.GuiObject := GuiObject
        this.ctrlType := controlType
        this.options := this._handleArcName(options)
        this.content := content
        this.depend := this._filterDepends(depend)
        this.checkStatusDepend := ""
        this.key := key

        ; ListView options
        if (controlType == "ListView") {
            this.lvOptions := options.lvOptions
            this.itemOptions := options.HasOwnProp("itemOptions") ? options.itemOptions : ""
            this.checkedRows := []
        }

        ; textString handling
        if (controlType == "ComboBox" || controlType == "DropDownList") {
            if (depend.value is Array) {
                this.optionTexts := depend.value
            } else if (depend.value is Map) {
                this.optionTexts := depend.value.keys()
                this.optionsValues := depend.value.values()
            }
        } else if (controlType == "ListView") {
            this.titleKeys := content.keys
            this.formattedContent := content.HasOwnProp("titles")
                ? content.titles
                : this.titleKeys.map(key => (key is Array) ? key[key.Length] : key)
            this.colWidths := content.HasOwnProp("widths") ? content.widths : this.titleKeys.map(item => "AutoHdr")
        } else {
            this.formattedContent := RegExMatch(content, "\{\d+\}") ? this._handleFormatStr(content, depend, key) : content
        }

        ; add control
        if (controlType == "ListView") {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.lvOptions, this.formattedContent)
            this._handleListViewUpdate()
            for width in this.colWidths {
                this.ctrl.ModifyCol(A_Index, width)
            }
        } else if (controlType == "CheckBox" && this.HasOwnProp("checkValueDepend")) {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.options, this.formattedContent)
            this.ctrl.Value := this.checkValueDepend.value
            this.ctrl.OnEvent("Click", (ctrl, *) => this.checkValueDepend.set(ctrl.Value))
        } else if (controlType == "ComboBox" || controlType == "DropDownList") {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.options, this.optionTexts)
        } else {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.options, this.formattedContent)
        }
        this.ctrl.arcWrapper := this

        ; add subscribe
        if (this.depend = 0) {
            return
        } else if (this.depend is Array) {
            for dep in this.depend {
                dep.addSub(this)
            }
        } else {
            this.depend.addSub(this)
        }
    }

    _handleArcName(options) {
        optionsString := this.ctrlType = "ListView" ? options.lvOptions : options

        optionsArr := StrSplit(optionsString, " ")
        arcNameIndex := optionsArr.findIndex(item => InStr(item, "$"))

        if (arcNameIndex != "") {
            this.name := optionsArr.RemoveAt(optionsArr.findIndex(item => InStr(item, "$")))
            this.GuiObject.arcs.Push(this)
        }

        formattedOptions := ""
        for option in optionsArr {
            formattedOptions .= option . " "
        }

        if (this.ctrlType = "ListView") {
            options.lvOptions := formattedOptions
            return options
        }

        return formattedOptions
    }

    _filterDepends(depend) {
        if (depend is Array) {
            checkValueObject := depend.find(d => d is Object && d.HasOwnProp("checkValue"))
            if (checkValueObject != "") {
                this.checkValueDepend := (depend.RemoveAt(depend.findIndex(d => d is Object && d.HasOwnProp("checkValue")))).checkValue
                this.checkValueDepend.addSub(this)
            }
            return depend
        } else if (depend is Object && depend.HasOwnProp("checkValue")) {
            this.checkValueDepend := depend.checkValue
            this.checkValueDepend.addSub(this)
            return 0
        } else {
            return depend
        }
    }

    _handleFormatStr(formatStr, depend, key) {
        vals := []

        if (key = 0) {
            handleKeyless()
        } else if (key is Number) {
            handleKeyNumber()
        } else {
            handleKeyObject()
        }

        handleKeyless() {
            if (depend = 0) {
                return
            }

            if (depend is Array) {
                for dep in depend {
                    vals.Push(dep.value)
                }
            } else if (depend.value is Array) {
                vals := depend.value
            } else {
                vals.Push(depend.value)
            }
        }

        handleKeyNumber() {
            for item in depend.value {
                vals.Push(depend.value[key])
            }
        }

        handleKeyObject() {
            if (key[1] is Array) {
                for k in key {
                    if (A_Index = 1) {
                        continue
                    }
                    vals.Push(depend.value[key[1][1]][k])
                }
            } else {
                for k in key {
                    vals.Push(depend.value[k])
                }
            }
        }

        return Format(formatStr, vals*)
    }

    _handleListViewUpdate() {
        this.ctrl.Delete()

        for item in this.depend.value {
            ; item -> Object || Map || OrderedMap
            if (item.base == Object.Prototype) {
                itemIn := JSON.parse(JSON.stringify(item))
            } else if (item is Map) {
                itemIn := item
            }

            rowData := this.titleKeys.map(key => getRowData(key, itemIn))
            getRowData(key, itemIn, layer := 1) {
                if (key is String) {
                    if (itemIn.Has(key)) {
                        return itemIn[key]
                    } else {
                        return getFirstMatch(key, itemIn)
                    }
                }

                if (key is Array) {
                    return getExactMatch(key, itemIn, 1)
                }
            }

            this.ctrl.Add(this.itemOptions, rowData*)
        }

        this.ctrl.Modify(1, "Select")
        this.ctrl.Focus()

        ; find nested key by exact query path
        getExactMatch(keys, item, index) {
            if !(item is Map) {
                return item
            }

            return getExactMatch(keys, item[keys[index]], index + 1)
        }

        ; find the first matching key
        getFirstMatch(key, item) {
            if (item.Has(key)) {
                return item[key]
            }

            for k, v in item {
                if (v is Map) {
                    res := getFirstMatch(key, v)
                    if (res != "") {
                        return res
                    }
                }
            }
        }
    }

    ; updating subs
    update(signal) {
        if (this.ctrl is Gui.Text || this.ctrl is Gui.Button) {
            ; update text label
            this.ctrl.Text := this._handleFormatStr(this.content, this.depend, this.key)
        }

        if (this.ctrl is Gui.Edit) {
            ; update text value
            this.ctrl.Value := this._handleFormatStr(this.content, this.depend, this.key)
        }

        if (this.ctrl is Gui.ListView) {
            ; update from checkStatusDepend
            if (this.checkStatusDepend = signal) {
                this.ctrl.Modify(0, this.checkStatusDepend.value = true ? "-Checked" : "+Checked")
                return
            }
            ; update list items
            this._handleListViewUpdate()
        }

        if (this.ctrl is Gui.CheckBox) {
            ; update from checkStatusDepend
            if (this.checkStatusDepend = signal) {
                this.ctrl.Value := this.CheckStatusDepend.value
                return
            }
            ; update text label
            this.ctrl.Text := this._handleFormatStr(this.content, this.depend, this.key)
            if (this.HasOwnProp("checkValueDepend")) {
                this.ctrl.Value := this.checkValueDepend.Value
            }
        }

        if (this.ctrl is Gui.ComboBox || this.ctrl is Gui.DDL) {
            ; replace the list content
            this.ctrl.Delete()
            this.ctrl.Add(signal.value is Array ? signal.value : signal.value.keys())
            this.ctrl.Choose(1)
            if (signal.value is Array) {
                this.optionTexts := signal.value
            } else {
                this.optionsTexts := signal.value.keys()
                this.optionsValues := signal.value.values()
            }
        }
    }

    ; APIs
    /**
     * Registers one or more functions to be call when given event is raised. 
     * @param {Map<String, Func>|<String, Func>} event Event name | An Map contains key-value pairs of event-callback.
     * ```
     * ; single event
     * AddReactive.OnEvent("Click", (*) => (...))
     * 
     * ; multiple events
     * AddReactive.OnEvent(Map(
     *   "Click", (*) => (...), 
     *   "DoubleClick", (*) => (...)
     * )
     * 
     * ```
     * @returns {AddReactive} 
     */
    OnEvent(event*){
        if (event[1] is Map) {
            for eventName, callbackFn in event[1] {
                this.ctrl.OnEvent(eventName, callbackFn)
            }
        } else {
            this.ctrl.OnEvent(event[1], event[2])
        }

        return this
    }

    Opt(newOptions) {
        this.ctrl.Opt(newOptions)
        return this
    }

    /**
     * Sets the font typeface, size, style, and/or color for controls added to the window from this point onward.
     * ```
     * AddReactiveText("...", "Text").SetFont("cRed s12", "Arial")
     * ```
     * @param {String} options Font options. C: color, S: size, W: weight, Q: quality
     * @param {String} fontName Name of font to set. 
     */
    SetFont(options := "", fontName := "") {
        this.ctrl.SetFont(options, fontName)
        return this
    }
}

Gui.Prototype.AddReactive := AddReactive
Gui.Prototype.arcs := []
Gui.Prototype.arcGroups := []