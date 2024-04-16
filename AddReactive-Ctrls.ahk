class AddReactiveText extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New(GuiObject, "Text", options, innerText, depend, key, event)
    }
}

class AddReactiveEdit extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New(GuiObject, "Edit", options, innerText, depend, key, event)
    }
}

class AddReactiveButton extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New(GuiObject, "Button", options, innerText, depend, key, event)
    }
}

class AddReactiveCheckBox extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New(GuiObject, "CheckBox", options, innerText, depend, key, event)
    }
}

class AddReactiveRadio extends AddReactive {
    __New(GuiObject, options := "", innerText := "", depend := 0, key := 0, event := 0) {
        this.key := key
        super.__New(GuiObject, "Radio", options, innerText, depend, key, event)
    }
}

class AddReactiveDropDownList extends AddReactive {
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
        super.__New(GuiObject, "DropDownList", options, this.text, depend, key, event)
    }

    ; overiding the getValue() of ReactiveControl. Returning the value of mapObj instead.
    getValue() {
        return this.vals[this.ctrl.Value]
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
        super.__New(GuiObject, "ComboBox", options, this.text, depend, key, event)
    }

    getValue() {
        return this.vals[this.ctrl.Value]
    }
}

class AddReactiveListView extends AddReactive {
    ; options of ListView: { lvOptions:"", itemOptions:"" }
    ; colTitleMap indicates the relationship between column titles and the actual key of depend obj.
    __New(GuiObject, options, colTitleGrid, depend := 0, key := 0, event := 0) {
        this.key := key
        ; colTitleGrid is a grid array in the form of:
        ; { keys: [keys*], titles: [titles*] }, not using Map because index is needed
        ; only handle items that needs to be render
        super.__New(GuiObject, "ListView", options, colTitleGrid, depend, key, event)
        ; depend of ListView should be [{},{}...]
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