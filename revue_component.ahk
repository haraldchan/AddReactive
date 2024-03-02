#Include "./revue.ahk"
#Include "./utils.ahk"
#SingleInstance Force

Counter(App) {
	aNum := ReactiveSignal(666)
	bNum := ComputedSignal(aNum, n => n + 333)

	return (
		AddReactiveText(App, "h15 w200", "Component number: {1}", aNum),
		AddReactiveText(App, "h15 w200", "Component number: {1}", bNum),
		App.AddButton("h50 w150", "++")
		   .OnEvent("Click", (*) => aNum.set(n => n + 1))
	)
}

NumberTexts(App) {
	num := ReactiveSignal(5)
	num2 := ComputedSignal(num, n => n * 2)

	return (
		AddReactiveText(App, "h15 w200","num is {1}, it's reactive!", num),
		AddReactiveText(App, "h15 w200", "double num is {1}, also reactive!", num2),
		AddReactiveText(App, "h15 w200", "num 1 is {1}, num2 is {2}", [num, num2]),
		App.AddButton("y+25 h40 w150", "++")
			.OnEvent("Click", (*) => num.set(n => n + 1))
	)
}

MouseTracker(App) {
	mouseX := ReactiveSignal(0)
	mouseY := ReactiveSignal(0)
	isTracking := ReactiveSignal(true)

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

	SetTimer trackMouse, 100,

	return (
		AddReactiveText(App, "y+25 h40 w200", "mouse pos X: {1}; `nmouse pos Y: {2}", [mouseX, mouseY]),
		App.AddCheckbox("Checked h15 w200", "Track mouse").OnEvent("Click", (*) => toggleTracking()),
		App.OnEvent("Close", (*) => SetTimer(trackMouse, 0))
	)
}

NumberList(App) {
	nums := ReactiveSignal(["a","b","c"])

	randomArr(){
		return [Random(1, 10), Random(1, 10),Random(1, 10)]
	}

	return (
		nums.value.map(item => AddReactiveText(App, "h15 w200", " - list num: {1}", nums,, A_Index)),
		AddReactiveText(App, "h15 w200", "First: {1}, Second: {2}, Third: {3}.", nums),
		App.AddButton("y+25 h40 w150", "assign new item")
	   		.OnEvent("Click", (*) => nums.set(randomArr()))
	)
}