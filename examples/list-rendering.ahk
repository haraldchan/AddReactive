#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
ListRenderingTest(oGui)
oGui.Show()

ListRenderingTest(App) {
    staffList := signal([
        { name: "frankie", pos: "manager", contact: { tel: 12345678, email: "example@163.com" } },
        { name: "aurora", pos: "attendant", contact: { tel: 87654212, email: "example222@163.com" } },
        { name: "alex", pos: "supervisor", contact: { tel: 66666666, email: "example33333@163.com" } },
    ])

    Contact := Struct({ tel: Integer, email: String })
    Staff := Struct({ name: String, pos: String, contact: Contact })

    chloe := signal({ 
        name: "chloe", 
        pos: "supervisor", 
        contact: { 
            tel: 888888, 
            email: "chloez@163.com" 
        } 
    }).as(Staff)

    return (
        App.ARText("w500 h20", "List Rendering").SetFont("s10.5 Bold"),
        
        3.times(() => App.ARText(
            "w500 h20", "name: {1}, position: {2}, email: {3}",
            staffList,
            { index: A_Index, keys: ["name", "pos", item => item["contact"]["tel"] ] }
        )),

        App.ARText("w500 h20", "name: {1}, position: {2}, tel: {3}", chloe, ["name", "pos", (v) => v["contact"]["email"]])
    )
}

; DevToolsUI()

