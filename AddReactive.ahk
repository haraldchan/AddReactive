#Include "./JSON.ahk"
#Include "./type-checker.ahk"
#Include "./AddReactive-Ctrls.ahk"
#Include "./functions/function-index.ahk"
#Include "./extend-methods/extend-methods-index.ahk"

class signal {
    /**
     * Creates a reactive signal variable.
     * @param {any} initialValue The initial value of the signal.This argument is ignored after the initial render.
     * @return {Signal}
     */
    __New(val) {
        this.value := (val is Object && !(val is Func) && !(val is Class)) ? this.mapify(val) : val
        this.subs := []
        this.comps := []
        this.effects := []
    }

    /**
     * Set the new value of the signal.
     * @param {any} newSignalValue New state of the signal. Also accept function object.
     * @returns {void} 
     */
    set(newSignalValue) {
        prevValue := this.value

        if (newSignalValue = this.value) {
            return
        }

        this.value := newSignalValue is Func ? newSignalValue(this.value) : newSignalValue

        ; change to Map()
        if (!(newSignalValue is Class) && newSignalValue is Object) {
            this.value := this.mapify(this.value)
        }

        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update(this)
        }

        ; notify all computed signals
        for comp in this.comps {
            comp.sync(this)
        }

        ; run all effects
        for effect in this.effects {
            if (effect.MaxParams = 1) {
                effect(this.value)
            } else if (effect.MaxParams = 2) {
                effect(this.value, prevValue)
            } else {
                effect()
            }
        }
    }

    update(key, newValue) {
        if (!(this.value is Object)) {
            throw TypeError(Format("update can only handle Array/Object/Map; `n`nCurrent Type: {2}", Type(newValue)))
        }

        if (this.value is Map) {
            updater := Map()
        } else if (this.value is Array) {
            updater := []
        }

        updater := this.value
        updater[key] := newValue

        this.set(updater)
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }

    addComp(computed) {
        this.comps.Push(computed)
    }

    addEffect(effectFn) {
        this.effects.Push(effectFn)
    }

    mapify(obj) {
        if (!(obj is Object)) {
            return obj
        }
        return JSON.parse(JSON.stringify(obj))
    }
}

class computed {
    /**
     * Create a computed signal which derives a reactive value.
     * @param {signal | signal[]} depend The signal derives from.
     * @param {Func} mutation computation function expression.
     * @return {computed}
     */
    __New(_signal, mutation) {
        checkType(_signal, [signal, computed, Array], "First parameter is not a signal.")
        checkType(mutation, Func, "Second parameter is not a Function.")

        this.signal := _signal
        this.mutation := mutation
        this.subs := []
        this.comps := []
        this.effects := []

        if (this.signal is Array) {
            this.subbedSignals := Map()

            for s in this.signal {
                this.subbedSignals[s] := s.value
                s.addComp(this)
            }
            this.value := this.mutation.Call(this.subbedSignals.values()*)
        } else {
            this.signal.addComp(this)
            this.value := this.mutation.Call(this.signal.value)
        }
    }

    sync(subbedSignal) {
        if (this.signal is Array) {
            for s in this.subbedSignals {
                if (s = subbedSignal) {
                    this.subbedSignals[s] := s.value
                    break
                }
            }
            this.value := this.mutation.Call(this.subbedSignals.values()*)
        } else {
            this.value := this.mutation.Call(subbedSignal.value)
        }

        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update()
        }

        ; notify all computed signals
        for comp in this.comps {
            comp.sync(this)
        }

        ; run all effectss
        if (this.effects.Length > 0) {
            for effect in this.effects {
                effect()
            }
        }

    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }

    addComp(computed) {
        this.comps.Push(computed)
    }

    addEffect(effectFn) {
        this.effects.Push(effectFn)
    }
}

class effect {
    /**
     * Create a effect that runs when the value of depend signal changes.
     * @param {signal} depend The signal associated with.
     * @param {(new?, prev?) => void} effectFn Callback function object. 
     * First param retrieves the new value of the signal, second param retrives previous value.
     * @example effect(signal, (new, prev) => MsgBox(Format("New: {1}, prev: {2}", new, prev)))
     */
    __New(depend, effectFn) {
        depend.addEffect(effectFn)
    }
}

class AddReactive {
    /**
     * Creates a new reactive control and add it to the window.
     * @param {Gui} GuiObject The target Gui Object.
     * @param {string} controlType Control type to create. Available: Text, Edit, CheckBox, Radio, DropDownList, ComboBox, ListView.
     * @param {string} options Options apply to the control, same as Gui.Add.
     * @param {string|Array|Object} content Text or formatted text for text, options for DDL/ComboBox, column option object for ListView.
     * @param {signal|Array|Object} depend Subscribed signal, or an array of signals. 
     * @param {string|number} key A key or index as render indicator.
     * @param {[ event: Event, callback: ()=>void ]} event Events and callback function objects.
     * @returns {AddReactive} 
     */
    __New(GuiObject, controlType, options := "", textString := "", depend := 0, key := 0, event := 0) {
        this.GuiObject := GuiObject
        this.ctrlType := controlType
        this.options := this.handleArcName(options)
        this.formattedString := textString
        this.depend := this.filterDepends(depend)
        this.checkStatusDepend := ""
        this.key := key

        ; ListView options
        if (controlType = "ListView") {
            this.lvOptions := options.lvOptions
            this.itemOptions := options.HasOwnProp("itemOptions") ? options.itemOptions : ""
            this.checkedRows := []
        }

        ; textString handling
        if (controlType = "ComboBox" || controlType = "DropDownList") {
            this.innerText := textString
        } else if (controlType = "ListView") {
            this.titleKeys := textString.keys
            this.innerText := textString.HasOwnProp("titles") ? textString.titles : this.titleKeys
            this.colWidths := textString.HasOwnProp("widths") ? textString.widths : this.titleKeys.map(item => "AutoHdr")
        } else {
            this.innerText := RegExMatch(textString, "\{\d+\}") ? this.handleFormatStr(textString, depend, key) : textString
        }

        ; add control
        if (controlType = "ListView") {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.lvOptions, this.innerText)
            this.handleListViewUpdate()
            for width in this.colWidths {
                this.ctrl.ModifyCol(A_Index, width)
            }
        } else if (controlType = "CheckBox" && this.HasOwnProp("checkValueDepend")) {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.options, this.innerText)
            this.ctrl.Value := this.checkValueDepend.value
            this.ctrl.OnEvent("Click", (ctrl, *) => this.checkValueDepend.set(ctrl.Value))
        } else {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.options, this.innerText)
        }

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

        ; add event
        if (event != 0) {
            for e, cb in event {
                this.ctrl.OnEvent(e, cb)
            }
        }
    }

    handleArcName(options){
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

    filterDepends(depend) {
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
        
    handleFormatStr(formatStr, depend, key) {
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

    handleListViewUpdate() {
        this.ctrl.Delete()
        for item in this.depend.value {
            itemIn := item
            rowData := this.titleKeys.map(key => itemIn[key])
            this.ctrl.Add(this.itemOptions, rowData*)
        }

        this.ctrl.Modify(1, "Select")
        this.ctrl.Focus()
    }

    ; updating subs
    update(signal) {
        if (this.ctrl is Gui.Text || this.ctrl is Gui.Button) {
            ; update text label
            this.ctrl.Text := this.handleFormatStr(this.formattedString, this.depend, this.key)
        }

        if (this.ctrl is Gui.Edit) {
            ; update text value
            this.ctrl.Value := this.handleFormatStr(this.formattedString, this.depend, this.key)
        }

        if (this.ctrl is Gui.ListView) {
            ; update from checkStatusDepend
            if (this.checkStatusDepend = signal) {
                this.ctrl.Modify(0, this.checkStatusDepend.value = true ? "-Checked" : "+Checked")
                return
            }
            ; update list items
            this.handleListViewUpdate()
        }

        if (this.ctrl is Gui.CheckBox) {
            ; update from checkStatusDepend
            if (this.checkStatusDepend = signal) {
                this.ctrl.Value := this.CheckStatusDepend.value
                return
            }
            ; update text label
            this.ctrl.Text := this.handleFormatStr(this.formattedString, this.depend, this.key)
            if (this.HasOwnProp("checkValueDepend")) {
                this.ctrl.Value := this.checkValueDepend.Value
            }
        }
    }


    ; APIs
    /**
     * Registers one or more functions to be call when given event is raised. 
     * @param {String | Map} event Event name | An Map contains key-value pairs of event-callback.
     * @param {Func} fn (optional) Event callback function.
     */
    OnEvent(event, fn := 0) {
        if (event is Map) {
            for e, cb in event {
                this.ctrl.OnEvent(e, cb)
            }
        } else {
            this.ctrl.OnEvent(event, fn)
        }
    }

    setOptions(newOptions) {
        this.ctrl.Opt(newOptions)
    }

    setFont(options := "", fontName := "") {
        this.ctrl.SetFont(options, fontName)
    }
}

Gui.Prototype.AddReactive := AddReactive