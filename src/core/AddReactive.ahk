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
                this.optionTexts := MapExt.keys(depend.value)
                this.optionsValues := MapExt.values(depend.value)
            }
        } else if (controlType == "ListView") {
            this.titleKeys := content.keys
            this.formattedContent := content.HasOwnProp("titles")
                ? content.titles
                : ArrayExt.map(this.titleKeys, key => (key is Array) ? key[key.Length] : key)
            this.colWidths := content.HasOwnProp("widths") ? content.widths : ArrayExt.map(this.titleKeys, item => "AutoHdr")
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
        if (!this.depend) {
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
        optionsString := this.ctrlType == "ListView" ? options.lvOptions : options

        optionsArr := StrSplit(optionsString, " ")
        arcNameIndex := ArrayExt.findIndex(optionsArr, item => InStr(item, "$"))

        if (arcNameIndex) {
            this.name := optionsArr.RemoveAt(arcNameIndex)
            this.GuiObject.arcs[this.name] := this
        }

        formattedOptions := ""
        for option in optionsArr {
            formattedOptions .= option . " "
        }

        if (this.ctrlType == "ListView") {
            options.lvOptions := formattedOptions
            return options
        }

        return formattedOptions
    }

    _filterDepends(depend) {
        if (depend is Array) {
            checkValueObject := ArrayExt.find(depend, d => d is Object && d.HasOwnProp("checkValue"))
            if (checkValueObject != "") {
                this.checkValueDepend := (depend.RemoveAt(
                    ArrayExt.findIndex(depend, d => d is Object && d.HasOwnProp("checkValue"))
                )).checkValue
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

        if (!key) {
            handleKeyless()
        } else if (key is Number) {
            handleKeyNumber()
        } else {
            handleKeyObject()
        }

        handleKeyless() {
            if (!depend) {
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
                    if (A_Index == 1) {
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

            rowData := ArrayExt.map(this.titleKeys, key => getRowData(key, itemIn))
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
            if (this.checkStatusDepend == signal) {
                this.ctrl.Modify(0, this.checkStatusDepend.value == true ? "-Checked" : "+Checked")
                return
            }
            ; update list items
            this._handleListViewUpdate()
        }

        if (this.ctrl is Gui.CheckBox) {
            ; update from checkStatusDepend
            if (this.checkStatusDepend == signal) {
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
            this.ctrl.Add(signal.value is Array ? signal.value : MapExt.keys(signal.value))
            this.ctrl.Choose(1)
            if (signal.value is Array) {
                this.optionTexts := signal.value
            } else {
                this.optionsTexts := MapExt.keys(signal.value)
                this.optionsValues := MapExt.values(signal.value)
            }
        }
    }

    ; APIs
    /**
     * Sets a depend signal for AddReactive Control.
     * @param {Signal} depend 
     */
    SetDepend(depend) {
        this.depend := this._filterDepends(depend)
        this.update(this.depend)

        return this
    }

    /**
     * Registers one or more functions to be call when given event is raised. 
     * @param {<String, Func>} event key-value pairs of event-callback.
     * ```
     * ; single event
     * AddReactive.OnEvent("Click", (*) => (...))
     * 
     * ; multiple events
     * AddReactive.OnEvent(
     *   "Click", (*) => (...), 
     *   "DoubleClick", (*) => (...)
     * )
     * 
     * ```
     * @returns {AddReactive} 
     */
    OnEvent(event*) {
        loop event.Length {
            if (Mod(A_Index, 2) == 0) {
                continue
            }

            this.ctrl.OnEvent(event[A_Index], event[A_Index + 1])
        }

        return this
    }

    /**
     * Sets various options and styles for the appearance and behavior of the control.
     * @param newOptions Specify one or more control-specific or general options and styles, each separated from the next with one or more spaces or tabs.
     */
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

    /**
     * Sets the font reactively with depend signal and option map.
     * ```
     * color := signal("red")
     * options := Map(
     *  "red", "cRed"
     *  "blue", "cBlue"
     *  "green", "cGreen"
     * )
     * 
     * AddReactiveText("...", "Text").SetFontStyles(options, color)
     * ; or
     * AddReactiveText("...", "{1}", color).SetFontStyles(options)
     * ```
     * @param {Map} optionMap A Map with depend signal value as keys, font options as values
     * @param {Signal} [depend] Signal dependency. If omitted, it will use the AddReactive.depend instead.
     */
    SetFontStyles(optionMap, depend := this.depend) {
        checkType(optionMap, Map)
        checkType(depend, signal)

        effect(depend, cur => this.ctrl.SetFont(optionMap.has(cur) ? optionMap[cur] : optionMap["default"]))
        return this
    }

    /**
     * Sets keyboard focus to the control.
     */
    Focus() {
        this.ctrl.Focus()
        return this
    }
}

Gui.Prototype.AddReactive := AddReactive
Gui.Prototype.arcs := Map()
Gui.Prototype.arcs.Default := ""