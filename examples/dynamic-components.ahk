#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
DynamicComponent(oGui)
ogui.Show()

DynamicComponent(App) {
    color := signal("Red")
    colorComponents := OrderedMap(
        "Red", Red,
        "Blue", Blue,
        "Green", Green,
    )

    return (
        App.AddDropDownList("w150 Choose1", ["Red", "Blue", "Green"])
           .OnEvent("Change", (ctrl, _) => color.set(ctrl.Text)),
        
        Dynamic(color, colorComponents, { app: App, style: "x20 y50 w200" })
    )
}


Red(props) {
    App := props.app

    R := Component(App, A_ThisFunc)
    R.render := (this) => this.Add(App.AddText(props.style, "RED TEXT"))
    
    return R
}

Blue(props) {
    App := props.app

    B := Component(App, A_ThisFunc)
    B.render := (this) => this.Add(App.AddEdit(props.style, "BLUE EDIT"))

    return B
}

Green(props) {
    App := props.app

    G := Component(App, A_ThisFunc)
    G.render := (this) => this.Add(App.AddRadio(props.style, "GREEN RADIO"))

    return G
}

DevToolsUI()