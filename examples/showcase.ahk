#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
App(oGui)
ogui.Show()

App(App) {
    color := signal("Red")
    colorComponents := OrderedMap(
        "Red", Red(App),
        "Blue", Blue(App),
        "Green", Red(App),
    )

    return (
        App.AddDropDownList("w150", ["Red", "Blue", "Green"])
        .OnEvent("Change", (ctrl, _) => color.set(ctrl.Text)),
        
        Dynamic(
            color, 
            colorComponents, 
            ; pass in an object of props that use by all components in Dynamic
            { style: "w200 h30" }
        )
    )
}


Red(App) {
    R := Component(App, A_ThisFunc)
    ; announce props as a receiver
    R.defineProps({ style: "" })
    R.render := (this) => this.Add(App.AddText(this.props.style, "RED TEXT"))
    
    return R
}

Blue(App) {
    B := Component(App, A_ThisFunc)
    B.defineProps({ style: "" })
    B.render := (this) => this.Add(App.AddEdit(this.props.style, "BLUE EDIT"))

    return B
}

Green(App) {
    G := Component(App, A_ThisFunc)
    G.defineProps({ style: "" })
    G.render := (this) => this.Add(App.AddRadio(this.props.style, "GREEN RADIO"))

    return G
}