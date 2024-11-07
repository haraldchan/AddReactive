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

jeff := {
    name: "Jeff",
    age: 22,
    new: "new",
    contact: {
        tel: 4432133,
        email: "jeff-nelson@gmail.com"
    }
}

j := signal(jeff).as(Person) 
; casts as type, uses checkType() for normal things,
; creates new instance of this object/map,
; if it is a struct already, validates it.

signal.set("str") ; gets type error
