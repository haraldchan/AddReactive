#Include "./revue.ahk"
#Include "./utils.ahk"
#Include "./revue_component.ahk"
#SingleInstance Force

Example := Gui("+MinSize250x300 +AlwaysOnTop", "testGui")

Counter(Example)
NumberTexts(Example)
NumberList(Example)
MouseTracker(Example)

Example.Show()

F12:: Reload