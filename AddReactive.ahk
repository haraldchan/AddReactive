#Include "./JSON.ahk"
#Include "./type-checker.ahk"
#Include "./AddReactive-Ctrls.ahk"
#Include "./functions/function-index.ahk"
#Include "./extend-methods/extend-methods-index.ahk"

class signal {
    __New(val) {
        this.value := ((val is Class) or (val is Func))
            ? val
                : val is Object
                    ? this.mapify(val)
                    : val
        this.subs := []
        this.comps := []
        this.effects := []
    }

    set(newSignalValue) {
        prevValue := this.value

        if (newSignalValue = this.value) {
            return
        }

        this.value := newSignalValue is Func
            ? newSignalValue(this.value)
                : newSignalValue

        ; change to Map()
        if (!(newSignalValue is Class) && newSignalValue is Object) {
            this.value := this.mapify(this.value)
        }

        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update()
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
    __New(depend, effectFn) {
        depend.addEffect(effectFn)
    }
}

class AddReactive {
    __New(GuiObject, controlType, options := "", textString := "", depend := 0, key := 0, event := 0) {
        ; params type checking
        checkType(GuiObject, Gui, "Second(GuiObject) param is not a Gui Object.")
        if (controlType != "ListView") {
            checkType(options, String, "First(options) param is not a String.")
        }
        checkTypeDepend(depend)
        ; checkTypeEvent(event)

        this.GuiObject := GuiObject
        this.ctrlType := controlType
        this.options := options
        this.formattedString := textString
        this.depend := depend
        this.key := key

        ; ListView options
        if (controlType = "ListView") {
            this.lvOptions := options.lvOptions
            this.itemOptions := options.HasOwnProp("itemOptions")
                ? options.itemOptions
                : ""
            this.checkedRows := []
        }

        ; textString handling
        if (controlType = "ComboBox" ||
            controlType = "DropDownList") {
            this.innerText := textString
        } else if (controlType = "ListView") {
            this.titleKeys := textString.keys
            this.innerText := textString.HasOwnProp("titles")
                ? textString.titles
                : this.titleKeys
            this.colWidths := textString.HasOwnProp("widths")
                ? textString.widths
                : this.titleKeys.map(item => "AutoHdr")
        } else {
            this.innerText := RegExMatch(textString, "\{\d+\}")
                ? this.handleFormatStr(textString, depend, key)
                : textString
        }

        ; add control
        if (controlType = "ListView") {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.lvOptions, this.innerText)
            this.handleListViewUpdate(true)

            for width in this.colWidths {
                this.ctrl.ModifyCol(A_Index, width)
            }

        } else {
            this.ctrl := this.GuiObject.Add(this.ctrlType, this.options, this.innerText)
        }

        ; add subscribe
        if (depend = 0) {
            return
        } else if (depend is Array) {
            for dep in depend {
                dep.addSub(this)
            }
        } else {
            depend.addSub(this)
        }

        ; add event
        if (event != 0) {
            if (event.every(item => item is Array)) {
                ; multiple events
                for e in event {
                    this.ctrl.OnEvent(e[1], e[2])
                }
            } else {
                ; single event
                this.ctrl.OnEvent(event[1], event[2])
            }
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

    handleListViewUpdate(isFirst := false) {
        this.ctrl.Delete()
        for item in this.depend.value {
            itemIn := item
            rowData := this.titleKeys.map(key => itemIn[key])
            this.ctrl.Add(this.itemOptions, rowData*)
        }

        this.ctrl.Modify(1, "Select")
        this.ctrl.Focus()
    }

    update() {
        if (this.ctrl is Gui.Text || this.ctrl is Gui.Button) {
            ; update text label
            this.ctrl.Text := this.handleFormatStr(this.formattedString, this.depend, this.key)
        }

        if (this.ctrl is Gui.Edit) {
            ; update text value
            this.ctrl.Value := this.handleFormatStr(this.formattedString, this.depend, this.key)
        }

        if (this.ctrl is Gui.ListView) {
            ; update list items
            this.handleListViewUpdate()
        }

        if (this.ctrl is Gui.CheckBox) {
            ; update text label
            this.ctrl.Text := this.handleFormatStr(this.formattedString, this.depend, this.key)
        }
    }


    ; APIs
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

    getValue() {
        return this.ctrl.Value
    }

    setValue(newValue) {
        this.ctrl.Value := newValue is Func
            ? newValue(this.ctrl.Value)
                : newValue
    }

    getInnerText() {
        return this.ctrl.Text
    }

    setInnerText(newInnerText) {
        this.ctrl.Text := newInnerText is Func
            ? newInnerText(this.ctrl.Text)
                : newInnerText
    }

    disable(state) {
        this.ctrl.Enabled := state
    }
}

class IndexList {
    __New(guiObj, controlType, options, innerText, depend := 0, key := 0, event := 0) {
        loop depend.value.length {
            guiObj.AddReactive(controlType, options, innerText, depend, A_Index, event)
        }
    }
}

class KeyList {
    __New(guiObj, controlType, options, innerText, depend := 0, key := 0, event := 0) {
        loop depend.value.length {
            guiObj.AddReactive(controlType, options, innerText, depend, [[A_Index], key*], event)
        }
    }
}

Gui.Prototype.AddReactive := AddReactive
Gui.Prototype.IndexList := IndexList
Gui.Prototype.KeyList := KeyList

; for lsp {
; revue.ahk
; /**
;  *D
;  */
; AddReactive(controlType[, options, textString, depend, key, event]) => Gui.Control

; /**
;  *
;  */
; AddReactiveText([options, textString, depend, key, event]) => Gui.Text

; /**
;  *
;  */
; AddReactiveEdit([options, textString, depend, key, event]) => Gui.Edit

; /**
;  *
;  */
; AddReactiveButton([options, textString, depend, key, event]) => Gui.Button

; /**
;  *
;  */
; AddReactiveCheckBox([options, textString, depend, key, event]) => Gui.CheckBox

; /**
;  *
;  */
; AddReactiveRadio([options, textString, depend, key, event]) => Gui.Radio

; /**
;  *
;  */
; AddReactiveDropDownList([options, mapObject, depend, key, event]) => Gui.DDL

; /**
;  *
;  */
; AddReactiveComboBox([options, mapObject, depend, key, event]) => Gui.ComboBox
; }