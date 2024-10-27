#SingleInstance Force
#Include "./AddReactive.ahk"

Contact := Struct({
    tel: Integer,
    email: String
})

Grand := Struct({
    grandfather: String
})

Family := Struct({
    father: String,
    mother: String,
    grandparents: Grand
})

Person := Struct({
    name: String,
    age: Integer,
    contact: Contact,
    family: Family,
    hobby: [String]
})

john := Person.new({
    name: "John",
    age: 30,
    ; new: "new"
    contact: {
        tel: 8888888,
        email: "johndoe@gmail.com"
    },
    family: {
        father: "Jonny",
        mother: "Dolores",
        grandparents : {
            grandfather: "Johaness"
        }
    },
    hobbies: ["tennis", "game", "code"]
})



msgbox john["family"]["grandparents"]["grandfather"]

F12:: Reload
