#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
NestedComponentTest(oGui)
oGui.Show()

NestedComponentTest(App) {

    return Parent(App)
}

Parent(App) {
    comp := Component(App, A_ThisFunc)

    handleSubmit(*) {
        formData := comp.submit()
        msgbox(JSON.stringify(formData))
    }

    comp.render := this => this.Add(
        App.AddEdit("vparent w200", "This is Parent."),
        Child_1(App),
        Child_2(App),
        App.ARButton("w100 h40", "submit").OnEvent("Click", handleSubmit)
    )

    return comp
}

Child_1(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddEdit("vchildOne w200", "This is the first Child."),
        GrandChild(App)
    )

    return comp
}

Child_2(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddEdit("vchildTwo w200", "This is the second Child.")
    )

    return comp
}

GrandChild(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddEdit("vgrandChild w200", "This is the Grandchild.")
    )

    return comp
}