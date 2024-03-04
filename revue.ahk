#Include "./typeChecker.ahk"
#Include "./JSON.ahk"

class ReactiveSignal {
    __New(val) {
        this.value := val is Object ? this.mapify(val) : val
        this.subs := []
        this.comps := []
    }

    get(mutateFunction := 0) {
        if (mutateFunction != 0 && mutateFunction is Func) {
            return mutateFunction(this.value)
        } else {
            return this.value
        }
    }

    set(newSignalValue) {
        if (newSignalValue = this.value) {
            return
        }
        this.value := newSignalValue is Func
            ? newSignalValue(this.value)
            : newSignalValue

        ; notify all computed signals
        for comp in this.comps {
            comp.sync(this.value)
        }

        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update()
        }
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }

    addComp(computed) {
        this.comps.Push(computed)
    }

    mapify(obj) {
        if (!(obj is Object)) {
            return
        }
        return JSON.parse(JSON.stringify(obj))
    }
}

class ComputedSignal {
    __New(signal, mutation) {
        checkType(signal, ReactiveSignal, "First parameter is not a ReactiveSignal.")
        checkType(mutation, Func, "Second parameter is not a Function.")

        this.signal := signal
        this.mutation := mutation
        this.value := this.mutation.Call(this.signal.get())
        this.subs := []

        signal.addComp(this)
    }

    sync(newVal) {
        this.value := this.mutation.Call(newVal)
        for ctrl in this.subs {
            ctrl.update()
        }
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }
}

class AddReactive {
    __New(controlType, GuiObject, options := "", textString := "", depend := 0, key := 0, event := 0) {
        ; params type checking
        checkType(GuiObject, Gui, "First(GuiObject) param is not a Gui Object.")
        checkType(options, String, "Second(options) param is not a String.")
        checkTypeDepend(depend)
        checkTypeEvent(event)

        this.ctrlType := controlType
        this.GuiObject := GuiObject
        this.options := options
        this.formattedString := textString
        this.innerText := RegExMatch(textString, "\{\d+\}") ? this.handleFormatStr(textString, depend, key) : textString
        this.depend := depend
        this.key := key

        ; add control
        this.ctrl := this.GuiObject.Add(this.ctrlType, options, this.innerText)

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
            this.event := event[1]
            this.callback := event[2]
            this.ctrl.OnEvent(this.event, (*) => this.callback())
        }
    }

    update() {
        if (this.ctrl is Gui.Text || this.ctrl is Gui.Button) {
            this.ctrl.Text := this.handleFormatStr(this.formattedString, this.depend, this.key)
        } else if (this.ctrl is Gui.Edit) {
            this.ctrl.Value := this.handleFormatStr(this.formattedString, this.depend, this.key)
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

    ; control option methods
    setOptions(newOptions) {
        this.ctrl.Opt(newOptions)
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

    setDepend(depend) {
        this.depend := depend
        this.subscribe(this.depend)
    }

    setEvent(event, callback) {
        this.ctrl.OnEvent(event, (*) => callback())
    }
}

class AddReactiveText extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New("Text", GuiObject, options, innerText, depend, key, event)
    }
}

class AddReactiveEdit extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New("Edit", GuiObject, options, innerText, depend, key, event)
    }
}

class AddReactiveButton extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New("Button", GuiObject, options, innerText, depend, key, event)
    }
}

class AddReactiveRadio extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New("Radio", GuiObject, options, innerText, depend, key, event)
    }
}

class AddReactiveCheckBox extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New("CheckBox", GuiObject, options, innerText, depend, key, event)
    }
}

class AddReactiveComboBox extends AddReactive {
    __New(GuiObject, options, mapObj, depend := 0, key := 0, event := 0) {
        ; mapObj: a Map(value, optionText) map object
        this.key := key
        this.mapObj := mapObj
        this.vals := []
        this.text := []
        for val, text in this.mapObj {
            this.vals.Push(val)
            this.text.Push(text)
        }
        super.__New("ComboBox", GuiObject, options, this.text, depend, key, event)
    }

    ; overiding the getValue() of ReactiveControl. Returning the value of mapObj instead.
    getValue() {
        return this.vals[this.ctrl.Value]
    }
}