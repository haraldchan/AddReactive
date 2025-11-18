#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
StackBoxTest(oGui)
ogui.Show()

StackBoxTest(App) {
    toggleDisable(*) {
        App.getComponent("$test-stack-box").setEnable(false)
    }

    return (
        StackBox(App, 
            {
                name: "test-stack-box",
                fontOptions: "s12 bold",
                fontName: "Times New Roman",
                groupbox: { 
                    title: "This is a StackBox",
                    options: "Section w250 r12",

                },
                checkbox: {
                    title: "StackBox with CheckBox title",
                    options: "Checked w250"
                }, 
            },
            () => [
                App.AddText("xs10 yp+20 w200 h20", "some text"),
                SomeComponent(App),
                App.AddText("xs10 yp+20 w200 h21", "other text")
            ]
        ),

        App.AddText("vbelow x10 y+5 w200 h20", "below StackBox"),
        App.AddButton("x10 y+10 w80 h20", "disable").onClick(toggleDisable)
    )
}

SomeComponent(App) {
    comp := Component(App, A_ThisFunc)

    comp.render := this => this.Add(
        App.AddText("xs10 yp+20 w200 h30", "Inside a component"),
        StackBox(App, { groupbox: { title: "gb", options: "Section yp+20 w200 r6" } }, () => [
            App.AddText("xs10 y+5 w200 h20", "below StackBox inner"),
        ])
    )

    return comp.render()
}