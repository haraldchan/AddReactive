#Include "./revue.ahk"
#Include "./utils.ahk"
#Include "./revue_component.ahk"
#SingleInstance Force

Example := Gui("+MinSize250x300 +AlwaysOnTop", "testGui")

NumberTexts(Example)
NumberList(Example)
Counter(Example)
MouseTracker(Example)
ObjectText(Example)
ObjectList(Example)

Example.Show()

F12:: Reload