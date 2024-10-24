#SingleInstance Force
#Include "./AddReactive.ahk"
#Include "./useDebug.ahk"

Person := Struct({
    name: String,
    age: Number,
    fn: Func
})


user := Map(
    "name", "hc", 
    "age", 35, 
    "fn", ()=>{} 
)

user2 := {
	name: "john", 
    age: 40, 
    fn: ()=>[] 
}

p := Person.new(user)
p2 := Person.new(user2)

msgbox p.name
msgbox p2.age


F12:: Reload
