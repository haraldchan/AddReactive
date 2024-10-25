#SingleInstance Force
#Include "./AddReactive.ahk"

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

F12:: Reload