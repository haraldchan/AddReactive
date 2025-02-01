#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
MultiDepEffectTest(oGui)
oGui.Show()

MultiDepEffectTest(App) {
    num1 := signal(1)
    num2 := signal(2)

    effect([num1, num2], (n1, n2) => MsgBox(n1 + n2))

    return (
        ; array dep
        App.AddGroupBox("Section w100 r3", "array"),
        App.ARText("xs y+20", "num 1: {}", ).OnEvent("Click", (*) => num1.set(n => n + 1)),
        App.ARText("xs y+10", "num 2: {}", ).OnEvent("Click", (*) => num2.set(n => n + 1))
    )
}