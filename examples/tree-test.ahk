#SingleInstance Force
#Include "../useAddReactive.ahk"

oGui := Gui()
TreeViewTest(oGui)
oGui.Show()

TreeViewTest(App) {
	ct := CompTree()
	ct.addChildren("root node")

	ct.addChildren("A")
	ct.addChildren("A1", "A")
	ct.addChildren("A2", "A")

	ct.addChildren("B")
	ct.addChildren("B1", "B")
	ct.addChildren("B1", "B")
	ct.addChildren("B11", "B1")
	ct.addChildren("B11", "B1")
	ct.addChildren("B111", "B11")

	ct.addChildren("C")

	
	
	
	tree := signal(ct)
	selectedNodeContent := signal(JSON.stringify(ct.root.content))



	options := {
		tvOptions: "x10 w300 h300 ",
		itemOptions: "Expand"
	}

	updateTreeD(*) {
		ct.addChildren("D")
		tree.set((t) => ct)
	}

	updateTreeB123(*) {
		ct.addChildren("B123", "B1")
		tree.set((t) => ct)
	}


	clickTest(ctrl, itemId) {
		content := ctrl.arcWrapper.shadowTree.getNodeById(itemId).content
		selectedNodeContent.set(JSON.stringify(content))
	}

	FocusTest(ctrl, itemId) {
		
	}

	ItemSelectTest(ctrl, itemId) {
		; msgbox itemId
	}

	ItemExpandTest(ctrl, itemId) {
		
	}



	return (
		App.ARTreeView(options, tree)
		   .SetFont("s10.5")
		   .OnEvent(
		   		"Click", ClickTest,
		   		; "Focus", FocusTest,
		   		; "ItemSelect", ItemSelectTest,
		   		; "ItemExpand", ItemExpandTest,
		),

		App.ARText("x+10 w200 h300", "node content:`n{1}", selectedNodeContent),


		App.AddButton("x10 w100 h30", "add D").OnEvent("Click", updateTreeD),
		App.AddButton("x+10 w100 h30", "add B123").OnEvent("Click", updateTreeB123)
	)
}

class CompNode {
	__New(nodeContent) {
		this.content := nodeContent
		this.parent := ""
		this.childrens := []
	}
}

class CompTree {
	__New() {
		this.root := ""
	}

	getNode(text, curNode := this.root) {
		if (text == curNode.content.text) {
			return curNode
		}

		if (curNode.childrens.Length > 0) {
			for childNode in curNode.childrens {
				res := this.getNode(text, childNode)
				if (res) {
					return res
				}
			}
		}

		return false
	}

	modifyNode(text, newContent) {
		targetNode := this.getNode(text)
		if (!targetNode) {
			return false
		}

		targetNode.content := newContent

		return true
	}

	addChildren(text, parentLabel := 0) {
		newNode := CompNode({ text: text })

		if (!parentLabel && !this.root) {
			this.root := newNode
			return newNode
		}

		if (!parentLabel && this.root) {
			this.root.childrens.Push(newNode)
			newNode.parent := this.root
			return newNode
		}

		parentNode := this.getNode(parentLabel)
		if (!parentNode) {
			return false
		}

		newNode.parent := parentNode
		parentNode.childrens.Push(newNode)

		return true
	}
}