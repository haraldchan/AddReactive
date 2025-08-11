#SingleInstance Force
#Include "../useAddReactive.ahk"

g := Gui()
App(g)
g.Show()

App(App) {
	count := signal(1)

	return (
		App.ARText("w200 h10", "Attached Signal Value: {1}", count),
		DoubledCount(App, count),
		App.AddButton("w100 h40", "++").OnEvent("Click", (*) => count.set(c => c + 1)),

		SignalTracker.trackings.values().map(
			debugger => 
			App.ARText(
					"w500 h15", 
					"varName: {1}, class: {2}, value: {3}, scope: {4}", 
					debugger, 
					["varName", "class", "value", "scope"]
				)
		)
	)
	
}

DoubledCount(App, count) {
	doubled := computed(count, c => c * 2)

	return (
		App.ARText("w200 h10", "Doubled Count: {1}", doubled),
		TripleCount(App, count)
	)
}

TripleCount(App, count) {
	trippled := computed(count, c => c * 3)

	return App.ARText("w200 h10", "Trippled Count: {1}", trippled)
}