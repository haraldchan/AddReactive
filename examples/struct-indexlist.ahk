#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
StructIndexListTest(oGui)
oGui.Show()

StructIndexListTest(App) {
    Staff := Struct({
        name: String,
        age: Integer,
        pos: String
    })

    staffList := signal([
        { name: "amy", age: 29, pos: "manager" },
        { name: "chloe", age: 20, pos: "supervisor" },
        { name: "harald", age: 35, pos: "supervisor" }
    ]).as([Staff])

    handleChange(*) {
        ; newList := [staffList.value*]
        ; newList[3] := { name: "Victoria", age: "awef", pos: "attendant" }
        ; staffList.set(newList)

        staffList.update(2, { name: "Victoria", age: 29, pos: "attendant" })
    }

    return (
        IndexList(() => [
            App.AddText("x20 y+30 w80", "name:"),
            App.AddText("w150 x+10", "{1}"),
            App.AddText("x20 w80", "age:"),
            App.AddText("w150 x+10", "{2}"),
            App.AddText("x20 w80", "pos:"),
            App.AddText("w150 x+10", "{3}")
        ], staffList, ["name", "age", "pos"]),

        App.AddButton("X20 y+10", "change").OnEvent("Click", handleChange)
    )
}
