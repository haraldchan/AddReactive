#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
ShowTest(oGui)
oGui.Show()

ShowTest(App) {
    flag := signal(1)

    return (
        Show(() => App.ARText("w200 h30 @AlignCenter", "one").setFont("cRed"), flag, f => f == 1),
        Show(() => App.ARText("w200 h30 @AlignCenter", "two"), flag, f => f == 2),
        Show(() => App.ARText("w200 h30 @AlignCenter", "three"), flag, f => f == 3),

        Show(() => [
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
            App.ARText("w200 h30 @AlignCenter", "we are FOUR!"),
        ], flag, f => f == 4),

        App.AddButton("w200 h25", "minus").onClick((*) => flag.set(f => f - 1)).setfont("bold"),
        App.AddButton("w200 h25", "plus").onClick((*) => flag.set(f => f + 1)).setfont("italic")
    )
}
