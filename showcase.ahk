#SingleInstance Force
#Include "./AddReactive.ahk"

TEST := Gui(, "AddReactive")
ShowCase(TEST)
TEST.Show()

ShowCase(App) {
    this := App.Component("ShowCase")

    staff := signal([
        { name: "Amy", pos: "manager", age:"??" },
        { name: "Chloe", pos: "supervisor", age:"??" },
        { name: "Elody", pos: "attendent", age:"??" }
    ])

    this.render := (this) => this.Add(
        App.IndexList(() => (
            App.AddEdit("w200 h20", "Staff Name: {1}, age: {2}"),
            App.AddText("w200 h20", "Staff Position: {3}"),
        ), staff, ["name", "age", "pos"]
    ))

    return this
}

F12:: Reload