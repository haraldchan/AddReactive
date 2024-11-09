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

john := {
    name: "John",
    age: 30,
    contact: {
        tel: 8888888,
        email: "johndoe@gmail.com"
    }
}

staff := signal(john).as(Person)

staff.update(["contact", "tel"], 12349)
staff.update("email", "jonny@hotmail.com")