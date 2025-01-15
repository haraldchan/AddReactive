#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
UsePropsStructTest(oGui)
oGui.Show()

UsePropsStructTest(App) {
    return (
        StaffComponent(App, { name: "Jenny", age: 60 }),
        StrictStaffComponent(App, { name: "Jarvis", age: 24, tel: "74488382" })
    )
}

StaffComponent(App, props) {
    s := useProps(props, {
        name: "John",
        age:  35,
        tel:  95737593
    })

    return (
        App.AddGroupBox("Section x20 w220 r3", "Staff Information"),
        App.AddText("xs10 yp+20 w200", "name: " . s.name),
        App.AddText("xs10 yp+20 w200", "age:  " . s.age),
        App.AddText("xs10 yp+20 w200", "tel:  " . s.tel)
    )
}

StrictStaffComponent(App, props) {
    s := useProps(props, Struct({
        name: String,
        age:  Integer,
        tel:  Integer
    }))

    return (
        App.AddGroupBox("Section x20 w220 r3", "Staff Information(strict)"),
        App.AddText("xs10 yp+20 w200", "name: " . s.name),
        App.AddText("xs10 yp+20 w200", "age:  " . s.age),
        App.AddText("xs10 yp+20 w200", "tel:  " . s.tel)
    )    
}