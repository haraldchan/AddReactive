#SingleInstance Force
#Include "../useAddReactive.ahk"

g := Gui()
App(g)
g.Show()

store := useStore("test-store", {
    states: {	
        count: { number: 1 }
    },
    deriveds: {
        doubled: this => this.count.value["number"] * 2,
    },
    methods: {
        showAdd: (this, formatStr) => MsgBox(Format(formatStr, this.count.value, this.doubled.value, this.count.value + this.doubled.value)),
    }
})

App(App) {
	count := signal(1, { name: "count" })
	somesig := signal("some", { name: "someSig" })

	return (
		App.ARText("vcounter w200 h20", "Attached Signal Value: {1}", count),
		DoubledCount(App, count),
		App.AddButton("w100 h40", "count++").OnEvent("Click", (*) => count.set(c => c + 1)),
		App.AddButton("w100 h40", "store.count++").OnEvent("Click", (*) => store.count.set(c => { number: c["number"] + 1 }))
	)
	
}

DoubledCount(App, count) {
	doubled := computed(count, c => c * 2, { name: "doubled" })

	return (
		App.ARText("w200 h20", "Doubled Count: {1}", doubled),
		TripleCount(App, count),
		QuadrupleCount(App, doubled)
	)
}

TripleCount(App, count) {
	trippled := computed(count, c => c * 3, { name: "tripled" })

	return App.ARText("w200 h20", "Trippled Count: {1}", trippled)
}

QuadrupleCount(App, doubled) {
	quadrupled := computed(doubled, d => d * 2, { name: "quadrupled" })

	return App.ARText("w200 h20", "Quadruple Cound: {1}", quadrupled)
}


DevToolsUI()