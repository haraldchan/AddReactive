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
        ; update val with new value
        this.val := newSignalValue is Func
            ? newSignalValue(this.val)
            : newSignalValue
        for ctrl in this.subs {
            ctrl.update(this)
        }
        for comp in this.comps {
            comp.sync(this.val)
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
    __New(controlType, GuiObject, options, innerText, depend, event := 0) {
        this.depend := depend
        this.GuiObject := GuiObject
        this.options := options
        this.innerText := innerText
        this.fromattedText := this.reformat(innerText, depend)
        this.ctrlType := controlType

        this.ctrl := this.GuiObject.Add(this.ctrlType, options, this.fromattedText)
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

    setOptions(newOptions) {
        this.ctrl.Opt(newOptions)
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

    update(depend) {
        if (this.ctrl is Gui.Text || this.ctrl is Gui.Button) {
            this.ctrl.Text := this.reformat(this.innerText, depend)
        } else if (this.ctrl is Gui.Edit) {
            this.ctrl.Value := this.reformat(this.innerText, this.depend)
        }
    }

    reformat(text, depend) {
        reconcat(text, val) {
            lCurl :=  InStr(text, "{") + 1
            rCurl := InStr(text, "}") 

            index := Trim(SubStr(text, lCurl, rCurl - lCurl - 1 )) = "" 
                ? 1 
                : Trim(SubStr(text, lCurl, rCurl - lCurl - 1 ))

            lPart := SubStr(text, 1, lCurl - 1)
            rPart := SubStr(text, rCurl)

            return Format(lPart . "{1}" . rPart, val)
        }
        
        newStr := text
        vals := []
        if (depend is Array) {
            for dep in depend {
                vals.Push(dep.val)  
            }
        } else {
            vals.Push(depend.val)

        }
        loop vals.Length {
            newStr := reconcat(newStr, vals[A_Index])
            newStr := StrReplace(newStr, "{", "",,,1)
            newStr := StrReplace(newStr, "}", "",,,1)
        }
        return newStr
    }
}

class addReactiveButton extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Button", GuiObject, options, innerText, depend, event)
    }
}

class addReactiveEdit extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Edit", GuiObject, options, innerText, depend, event)
    }

    getValue() {
        return this.ctrl.Value
    }
}

class addReactiveCheckBox extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("CheckBox", GuiObject, options, innerText, depend, event)
    }

    getValue() {
        return this.ctrl.Value
    }

    setValue(newValue) {
        this.ctrl.Value := newValue is Func
            ? newValue(this.ctrl.Value)
            : newValue
    }
}

class addReactiveComboBox extends ReactiveControl {
    __New(depend, GuiObject, options, items, event := 0) {
        this.items := items
        this.vals := []
        this.texts := []
        for val, text in items {
            this.vals.Push(val)
            this.texts.Push(text)
        }
        super.__New("ComboBox", depend, GuiObject, options, this.texts, event)
    }

    getValue() {
        return this.vals[this.ctrl.Value]
    }
}

class addReactiveText extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Text", GuiObject, options, innerText, depend, event)
    }
}

class addReactiveRadio extends ReactiveControl {
    __New(GuiObject, options, innerText, depend, event := 0) {
        super.__New("Radio", GuiObject, options, innerText, depend, event)
    }
}