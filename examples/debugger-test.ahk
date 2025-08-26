#SingleInstance Force
#Include "../useAddReactive.ahk"
#Include "./ddl-combobox.ahk"

g := Gui()
App(g)
g.Show()

App(App) {
	count := signal(1)
	somesig := signal("some")

	return (
		App.ARText("vcounter w200 h10", "Attached Signal Value: {1}", count),
		DoubledCount(App, count),
		App.AddButton("w100 h40", "++").OnEvent("Click", (*) => count.set(c => c + 1)),
		DdlComboBoxTest(App)
	)
	
}

DoubledCount(App, count) {
	doubled := computed(count, c => c * 2)

	return (
		App.ARText("w200 h10", "Doubled Count: {1}", doubled),
		TripleCount(App, count),
		QuadrupleCount(App, doubled)
	)
}

TripleCount(App, count) {
	trippled := computed(count, c => c * 3)

	return App.ARText("w200 h10", "Trippled Count: {1}", trippled)
}

QuadrupleCount(App, doubled) {
	quadrupled := computed(doubled, d => d * 2)

	return App.ARText("w200 h10", "Quadruple Cound: {1}", quadrupled)
}


; DevToolsUI()