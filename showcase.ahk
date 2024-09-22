#SingleInstance Force
#Include "./AddReactive.ahk"

TEST := Gui(, "AddReactive")
ShowCase(TEST)
TEST.Show()

ShowCase(App) {
    this := App.Component("ShowCase")

    staff := signal([
        { name: "Amy", pos: "manager", age:30 },
        { name: "Chloe", pos: "supervisor", age:24 },
        { name: "Elody", pos: "attendent", age:20 }
    ])

    ageAverage := computed(staff, cur => 
        cur.map(s => s["age"]).reduce((acc, cur) => acc + cur, 0) / cur.Length
    )

    this.render := render
    render(this){
        return (
            this.Add(
                App.IndexList(() => (
                    App.AddEdit("w200 h20", "Staff Name: {1}, age: {2}"),
                    App.AddText("w200 h20", "Staff Position: {3}"),
                ), staff, ["name", "age", "pos"]),
                App.AddReactiveText("w200 h20", "Average age: {1}", ageAverage)
            )
        )
    }

    return this
}

F12:: Reload