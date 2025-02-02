#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
MultiDepEffectTest(oGui)
oGui.Show()

MultiDepEffectTest(App) {
    num1 := signal(1)
    num2 := signal(2)

    effect([num1, num2], (n1, n2) => MsgBox(Format("num1's value: {1}, num2's value: {2}", n1, n2)))

    return (
        ; array dep
        App.AddGroupBox("Section w150 r3", "array"),
        App.ARText("xs yp+20", "num 1: {1}", num1).OnEvent("Click", (*) => num1.set(n => n + 1)),
        App.ARText("xs yp+20", "num 2: {1}", num2).OnEvent("Click", (*) => num2.set(n => n + 1))
    )
}