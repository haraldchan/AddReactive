#SingleInstance Force
#Include "../useAddReactive.ahk"

Contact := Struct({
    tel: Integer,
    email: String
})

Person := Struct({
    name: String,
    age: Integer,
    contact: Contact
})

john := Person.new({
    name: "John",
    age: 30,
    contact: {
        tel: 8888888,
        email: "johndoe@gmail.com"
    }
})

staffname := signal("john").as(String)

oGui := Gui()
oGui.ARText("w500", "current staff: {1}", staffname)
oGui.Show()
