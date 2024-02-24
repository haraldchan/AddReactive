#Include "./revue.ahk"
#SingleInstance Force

Example := Gui("+MinSize250x300 +AlwaysOnTop", "testGui")

num := ReactiveSignal(5)
num2 := ComputedSignal(num, n => n * 2)

mouseX := ReactiveSignal(0)
mouseY := ReactiveSignal(0)
isTracking := ReactiveSignal(true)

addReactiveText(Example, "h15 w200", "num is {1}, it's reactive!", num)
addReactiveText(Example, "h15 w200", "double num is {1}, also reactive!", num2)
addReactiveText(Example, "h15 w200", "num 1 is {1}, num2 is {2}", [num, num2])

Example.AddButton("y+25 h40 w150", "++").OnEvent("Click", (*) => num.set(n => n + 1))

addReactiveText(Example, "y+25 h40 w200", "mouse pos X: {1}; `nmouse pos Y: {2}", [mouseX, mouseY])
Example.AddCheckbox("Checked h15 w200", "Track mouse").OnEvent("Click", (*) => toggleTracking())

SetTimer trackMouse, 100
Example.OnEvent("Close", (*) => SetTimer(trackMouse, 0))

Example.Show()

trackMouse() {
	CoordMode "Mouse", "Screen"

	MouseGetPos &x, &y
	mouseX.set(x)
	mouseY.set(y)
}

toggleTracking() {
	isTracking.set(t => !t)
	if (isTracking.get() = false) {
		SetTimer trackMouse, 0
	} else {
		SetTimer trackMouse, 100
	}
}

F12:: Reload