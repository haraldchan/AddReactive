#SingleInstance Force
#Include "./AddReactive.ahk"

TEST := Gui("+Resize", "AddReactive")
App(TEST)
TEST.Show()

App(App){
    colors := signal("red")
    colorComponents := Map(
        "red", RedText(App),
        "blue", BlueEdit(App),
        "green", GreenRadio(App)
    )

    return (
        ShowCase(App),
        Dynamic(colors, colorComponents),
        App.AddButton("w200 h30", "Change color!")
           .OnEvent("Click", (*) => colors.set("blue"))
    )
}

ShowCase(App) {
    staff := signal([
        { name: "Amy", pos: "manager", age: 30 }, 
        { name: "Chloe", pos: "supervisor", age: 24 }, 
        { name: "Elody", pos: "attendant", age: 20 }
    ])

    ageAverage := computed(staff, cur =>
        Round(cur.map(s => s["age"]).reduce((acc, cur) => acc + cur, 0) / cur.Length)
    )

    return (
        IndexList(() => [
            App.AddEdit("w200 h20", "Staff Name: {1}, age: {2}"),
            App.AddText("w200 h20", "Staff Position: {3}")
        ], staff, ["name", "age", "pos"]),
        App.AddReactiveText("w200 h20", "Average age: {1}", ageAverage)
    )
}



RedText(App) {
    rt := Component(App, A_ThisFunc)
    
    rt.render := (this) => this.Add(
        App.AddText("w200 h30", "Red Text")
    )

    return rt
}

BlueEdit(App) {
    be := Component(App, A_ThisFunc)

    be.render := (this) => this.Add(
        App.AddEdit("w200 h30", "Blue Edit")
    )

    return be
}

GreenRadio(App) {
    gr := Component(App, A_ThisFunc)

    gr.render := (this) => this.Add(
        App.AddRadio("w200 h30", "Green Radio")
    )

    return gr
}


F12:: Reload