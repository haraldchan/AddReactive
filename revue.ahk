#Include "./typeChecker.ahk"

class ReactiveSignal {
    __New(val) {
        this.val := val
        this.subs := []
        this.comps := []
    }

    get(mutateFunction := 0) {
        if (mutateFunction != 0 && mutateFunction is Func) {
            return mutateFunction(this.val)
        } else {
            return this.val
        }
    }

    set(newSignalValue) {
        if (newSignalValue = this.val) {
            return
        }
        this.val := newSignalValue is Func
            ? newSignalValue(this.val)
            : newSignalValue
        ; notify all computed signals
        for comp in this.comps {
            comp.sync(this.val)
        }
        ; notify all subscribers to update
        for ctrl in this.subs {
            ctrl.update(this)
        }
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }

    addComp(computed) {
        this.comps.Push(computed)
    }
}

class ComputedSignal {
    __New(signal, mutation) {
        checkType(signal, ReactiveSignal, "First parameter is not a ReactiveSignal.")
        checkType(mutation, Func, "Second parameter is not a Function.")

        this.signal := signal
        this.mutation := mutation
        this.val := this.mutation.Call(this.signal.get())
        ; msgbox this.mutation.Call(this.signal.get())
        this.subs := []

        signal.addComp(this)
    }

    sync(newVal) {
        this.val := this.mutation.Call(newVal)
        for ctrl in this.subs {
            ctrl.update(this)
        }
    }

    addSub(controlInstance) {
        this.subs.Push(controlInstance)
    }
}

class ReactiveControl {
    __New(controlType, GuiObject, options, formattedString, depend, event := 0) {
        checkType(GuiObject, Gui, "First(GuiObject) param is not a Gui Object.")
        checkType(options, String, "Second(options) param is not a String.")
        checkTypeFormattedString(formattedString)
        checkTypeDepend(depend)
        checkTypeEvent(event)

        this.depend := depend
        this.GuiObject := GuiObject
        this.options := options
        this.formattedString := formattedString
        this.innerText := this.reformat(formattedString, depend)
        this.ctrlType := controlType

        this.ctrl := this.GuiObject.Add(this.ctrlType, options, this.innerText)
        if (event != 0) {
            this.event := event[1]
            this.callback := event[2]
            this.ctrl.OnEvent(this.event, (*) => this.callback())
        }

        if (depend is Array) {
            for dep in depend {
                dep.addSub(this)
            }
        } else {
            depend.addSub(this)
        }

    }

    update(depend) {
        if (this.ctrl is Gui.Text || this.ctrl is Gui.Button) {
            this.ctrl.Text := this.reformat(this.formattedString, this.depend)
        } else if (this.ctrl is Gui.Edit) {
            this.ctrl.Value := this.reformat(this.formattedString, this.depend)
        }
    }

    reformat(formatString, depend) {
        vals := []

        if (depend is Array) {
            for dep in depend {
                vals.Push(dep.val)
            }
        } else {
            vals.Push(depend.val)

        }

        return Format(formatString, vals*)
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

    setEvent(event, callback) {
        this.ctrl.OnEvent(event, (*) => callback())
    }
}

class AddReactiveText extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Text", GuiObject, options, innerText, depend, event)
    }
}

class AddReactiveEdit extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Edit", GuiObject, options, innerText, depend, event)
    }
}

class AddReactiveButton extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Button", GuiObject, options, innerText, depend, event)
    }
}

class AddReactiveRadio extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Radio", GuiObject, options, innerText, depend, event)
    }
}

class AddReactiveCheckBox extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("CheckBox", GuiObject, options, innerText, depend, event)
    }
}

class AddReactiveComboBox extends ReactiveControl {
    __New(depend, GuiObject, options, mapObj, event := 0) {
        ; mapObj: a Map(value, optionText) map object
        this.mapObj := mapObj
        this.vals := []
        this.text := []
        for val, text in this.mapObj {
            this.vals.Push(val)
            this.text.Push(text)
        }
        super.__New("ComboBox", depend, GuiObject, options, this.text, event)
    }

    ; overiding the getValue() of ReactiveControl. Returning the value of mapObj instead.
    getValue() {
        return this.vals[this.ctrl.Value]
    }
}