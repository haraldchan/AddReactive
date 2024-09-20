#SingleInstance Force
#Include "./AddReactive.ahk"

TEST := Gui(, "AddReactive")
App(TEST)
TEST.Show()

App(App) {
    staff := signal([
        { name: "Amy", pos: "manager", age:"??" },
        { name: "Chloe", pos: "supervisor", age:"??" },
        { name: "Elody", pos: "attendent", age:"??" }
    ])

    return (
        App.IndexList(() => (
            App.AddEdit("w200 h20", "Staff Name: {1}, age: {2}"),
            App.AddText("w200 h20", "Staff Position: {3}"),
        ), staff, ["name", "age", "pos"])
    )
}

F12:: Reload