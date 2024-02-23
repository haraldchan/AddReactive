#Include "./revue.ahk"
#SingleInstance Force

increment := Gui("+MinSize250x300 +AlwaysOnTop","testGui")

num := ReactiveSignal(5)
num2 := ComputedSignal(num, num => num * 2)

mouseX := ReactiveSignal(0)
mouseY := ReactiveSignal(0)
isTracking := ReactiveSignal(true) 

addReactiveText(increment, "h15 w200", "num is {1}, it's reactive!", num)
addReactiveText(increment, "h15 w200", "double num is {1}, also reactive!", num2)
increment.AddButton("y+25 h40 w150", "++").OnEvent("Click", (*) => num.set(num => num + 1))

addReactiveText(increment, "y+25 h15 w200", "mouse pos X : {1}", mouseX)
addReactiveText(increment, "h15 w200", "mouse pos Y : {1}", mouseY)
increment.AddCheckbox("Checked h15 w200", "Track mouse").OnEvent("Click", (*) => toggleTracking())

SetTimer trackMouse, 100
increment.OnEvent("Close", (*) => SetTimer trackMouse, 0)
increment.Show()

trackMouse(){
	CoordMode "Mouse", "Screen"

	MouseGetPos &x, &y 
	mouseX.set(x)
	mouseY.set(y)
}

toggleTracking(){
	isTracking.set(t => !t)
	if (isTracking.get() = false) {
		SetTimer trackMouse, 0
	} else {
		SetTimer trackMouse, 100
	}
}

F12::Reload