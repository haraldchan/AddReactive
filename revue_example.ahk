#Include "./revue.ahk"
#Include "./utils.ahk"
#Include "./revue_component.ahk"
#SingleInstance Force

App(){
	num := ReactiveSignal(0)
	
	Example := Gui("+MinSize250x300 +AlwaysOnTop", "testGui")

	Text(Example, num, AnotherText)
	Edit(Example, num)
	Button(Example, num)

	Example.Show()
}

AnotherText(App, signal){
	num2 := ComputedSignal(signal, n => n * 2)

	return AddReactiveText(App, "h20 w300", "number2 : {1}", num2)
}

Text(App, signal, text2) {
	return (
		AddReactiveText(App, "h20 w300", "number : {1}", signal),
		text2(App, signal)
	)
}

Edit(App, signal) {
	updateText(*) {
		signal.set(e.getInnerText() = "" ? 0 : e.getInnerText())
	}

	return e := AddReactiveEdit(App, "h20 w300 Number", "{1}", signal,, ["LoseFocus", updateText])
}

Button(App, signal) {
	return AddReactiveButton(App, "h50 w200", "++", signal,, ["Click", (*) => signal.set(n => n + 1)])
}


App()
F12:: Reload