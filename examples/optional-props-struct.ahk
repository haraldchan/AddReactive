#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
OptionalPropsStructTest(oGui)
oGui.Show()

OptionalPropsStructTest(App) {
    return (
        StaffComponent(App, { name: "Jenny", age: 60}),
        StrictStaffComponent(App, { name: "Jarvis", age: 24, tel: 74488382 })
    )
}

StaffComponent(App, props) {
    s := optionalProps(props, {
        name: "John",
        age:  35,
        tel:  95737593
    })

    return (
        App.AddGroupBox("Section w220 r4", "Staff Information")
        App.AddText("xs10 yp+10 w200", "name: " . s.name),
        App.AddText("xs10 yp+10 w200", "age:  " . s.age),
        App.AddText("xs10 yp+10 w200", "tel:  " . s.tel)
    )
}

StrictStaffComponent(App, props) {
    s := optionalProps(props, Struct({
        name: String,
        age:  Integer,
        tel:  Integer
    }))

    return (
        App.AddGroupBox("Section w220 r4", "Staff Information(strict)")
        App.AddText("xs10 yp+10 w200", "name: " . s.name),
        App.AddText("xs10 yp+10 w200", "age:  " . s.age),
        App.AddText("xs10 yp+10 w200", "tel:  " . s.tel)
    )    
}