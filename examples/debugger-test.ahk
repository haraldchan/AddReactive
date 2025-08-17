#SingleInstance Force
#Include "../useAddReactive.ahk"


aGui := Gui()
TreeViewTest(aGui)
aGui.Show()

TreeViewTest(App) {
	global tree := signal(CALL_TREE)
	selectedNodeContent := signal("")



	options := {
		tvOptions: "x10 w300 h300 ",
		itemOptions: "Expand"
	}

	clickTest(ctrl, itemId) {
		content := ctrl.arcWrapper.shadowTree.getNodeById(itemId).content.debuggers.map(d => JSON.stringify(d))
		selectedNodeContent.set(JSON.stringify(content))
	}

	showTree(*) {
		msgbox CALL_TREE.root.childrens[1].stackString
	}

	return (
		App.ARTreeView(options, tree).SetFont("s10.5").OnEvent("Click", ClickTest),
	)
}



g := Gui()
App(g)
g.Show()

App(App) {
	count := signal(1)

	return (
		App.ARText("w200 h10", "Attached Signal Value: {1}", count),
		DoubledCount(App, count),
		App.AddButton("w100 h40", "++").OnEvent("Click", (*) => count.set(c => c + 1))
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




tree.set(t => CALL_TREE)