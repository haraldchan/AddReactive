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
	ct.addChildren("B11", "B1")
	ct.addChildren("B12", "B1")
	ct.addChildren("B111", "B11")

	ct.addChildren("C")
	ct.modifyNode("C", { label: "C", id: "123" })

	
	
	
	tree := signal(ct)

	options := {
		tvOptions: "w300 h600",
		itemOptions: ""
	}

	updateTree(*) {
		ct.addChildren("D")
		tree.set(() => ct)
	}

	return (
		App.ARTreeView(options, tree).SetFont("s10.5")
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

	getNode(label, curNode := this.root) {
		if (label == curNode.content.label) {
			return curNode
		}

		if (curNode.childrens.Length > 0) {
			for childNode in curNode.childrens {
				res := this.getNode(label, childNode)
				if (res) {
					return res
				}
			}
		}

		return false
	}

	modifyNode(label, newContent) {
		targetNode := this.getNode(label)
		if (!targetNode) {
			return false
		}

		targetNode.content := newContent

		return true
	}

	addChildren(label, parentLabel := 0) {
		newNode := CompNode({ label: label })

		if (!parentLabel && !this.root) {
			this.root := newNode
		}

		if (!parentLabel && this.root) {
			this.root.childrens.Push(newNode)
			newNode.parent := this.root
		}

		parentNode := this.getNode(parentLabel)
		if (!parentNode) {
			return false
		}

		newNode.parent := parentNode
		parentNode.childrens.Push(newNode)

		return newNode
	}
}