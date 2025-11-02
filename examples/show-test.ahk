#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
ShowTest(oGui)
oGui.Show()

ShowTest(App) {
    flag := signal(1)

    return (
        Show(() => [ App.ARText("w200 h30 @AlignCenter", "one") ], flag, f => f == 1),
        Show(() => [ App.ARText("w200 h30 @AlignCenter", "two") ], flag, f => f == 2),
        Show(() => [ App.ARText("w200 h30 @AlignCenter", "three") ], flag, f => f == 3),
        ; Show(() => [ Red({ app: App, style: "w200 h30 @AlignCenter" }).render() ], flag, f => f == 4),
        Show(() => [
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
        ], flag, f => f == 4),

        App.AddButton("w200 h25", "--").OnEvent("Click", (*) => flag.set(f => f - 1))
        App.AddButton("w200 h25", "++").OnEvent("Click", (*) => flag.set(f => f + 1))
    )
}

Red(props) {
    App := props.app

    R := Component(App, A_ThisFunc)
    R.render := (this) => this.Add(
        App.ARText(props.style, "RED TEXT"),
        Blue(props).render()
    )
    
    return R
}

Blue(props) {
    App := props.app

    B := Component(App, A_ThisFunc)
    B.render := (this) => this.Add(
        App.AREdit(props.style, "BLUE EDIT"),
        Green(props).render()
    )

    return B
}

Green(props) {
    App := props.app

    G := Component(App, A_ThisFunc)
    G.render := (this) => this.Add(App.ARRadio(props.style, "GREEN RADIO"))

    return G
}
