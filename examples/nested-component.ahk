#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui("+Resize","")
NestedComponentTest(oGui)
oGui.Show()

NestedComponentTest(App) {

    return Parent(App)
}

Parent(App) {
    comp := Component(App, A_ThisFunc)
    isShow := signal(true)

    handleSubmit(*) {
        formData := comp.submit()
        msgbox(JSON.stringify(formData))
    }

    handleVisible(*) {
        isShow.set(v => !v)
        comp.visible(isShow.value)
    }

    comp.render := this => this.Add(
        App.AddEdit("vparent w200", "This is Parent."),
        Child_1(App),
        Child_2(App),
        App.ARButton("w100 h40", "submit").OnEvent("Click", handleSubmit),
    )

    return (
        comp.render(),
        App.ARButton("x+10 w100 h40", "show/hide").OnEvent("Click", handleVisible)
    )
}

Child_1(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddEdit("vchildOne w200", "This is the first Child."),
        GrandChild(App)
    )

    return comp.render()
}

Child_2(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddEdit("vchildTwo w200", "This is the second Child.")
    )

    return comp.render()
}

GrandChild(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddEdit("vgrandChild w200", "This is the Grandchild.")
    )

    return comp.render()
}